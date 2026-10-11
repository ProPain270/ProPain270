#!/bin/bash
# Start the Docker daemon and register ARM executables (arm64, arm/v7) to run
# on this x86_64 host through QEMU user-mode emulation (binfmt_misc).
#
# Follows https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
# ("Register ARM executables to run on x64 machines") using the maintained
# tonistiigi/binfmt image instead of the older multiarch/qemu-user-static.
#
# Idempotent: safe to run repeatedly. Requires root (or sudo) and a kernel
# with binfmt_misc support. Run `tools/setup_docker_arm.sh --check` to only
# verify the current state without changing anything.
set -euo pipefail

BINFMT_IMAGE="${BINFMT_IMAGE:-tonistiigi/binfmt:latest}"
BINFMT_DIR=/proc/sys/fs/binfmt_misc
CHECK_ONLY=0
[ "${1:-}" = "--check" ] && CHECK_ONLY=1

log() { printf '[docker-arm] %s\n' "$*"; }

if ! command -v docker >/dev/null 2>&1; then
  log "docker CLI not found; install Docker Engine first (https://docs.docker.com/engine/install/)"
  exit 1
fi

# 1. Make sure a Docker daemon is answering.
if ! docker info >/dev/null 2>&1; then
  if [ "$CHECK_ONLY" = 1 ]; then
    log "Docker daemon is not running"
    exit 1
  fi
  if command -v systemctl >/dev/null 2>&1 && systemctl is-system-running >/dev/null 2>&1; then
    log "starting docker via systemd"
    systemctl start docker
  elif command -v dockerd >/dev/null 2>&1; then
    log "starting dockerd in the background (no systemd here)"
    mkdir -p /var/log
    nohup dockerd >/var/log/dockerd.log 2>&1 &
  else
    log "dockerd not found; cannot start a daemon"
    exit 1
  fi
  for _ in $(seq 1 30); do
    docker info >/dev/null 2>&1 && break
    sleep 1
  done
  docker info >/dev/null 2>&1 || { log "Docker daemon did not come up; see /var/log/dockerd.log"; exit 1; }
fi
log "Docker daemon: $(docker version --format '{{.Server.Version}}') on $(uname -m)"

# 2. Make sure binfmt_misc is mounted so handlers can be registered.
if [ ! -e "$BINFMT_DIR/register" ]; then
  if [ "$CHECK_ONLY" = 1 ]; then
    log "binfmt_misc is not mounted"
    exit 1
  fi
  log "mounting binfmt_misc"
  mount -t binfmt_misc binfmt_misc "$BINFMT_DIR"
fi

# 3. Register QEMU handlers for ARM binaries unless they are already present.
if [ -e "$BINFMT_DIR/qemu-aarch64" ] && [ -e "$BINFMT_DIR/qemu-arm" ]; then
  log "ARM handlers already registered (qemu-aarch64, qemu-arm)"
elif [ "$CHECK_ONLY" = 1 ]; then
  log "ARM handlers are not registered"
  exit 1
else
  log "registering ARM handlers with $BINFMT_IMAGE"
  docker run --privileged --rm "$BINFMT_IMAGE" --install arm64,arm
fi

# 4. Report what buildx can now target.
log "buildx platforms: $(docker buildx inspect default 2>/dev/null | awk -F': ' '/^Platforms/ {gsub(/^ +/, "", $2); print $2}')"
log "try: docker run --rm --platform linux/arm64 mirror.gcr.io/library/alpine uname -m"
