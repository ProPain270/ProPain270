#!/bin/bash
# SessionStart hook: in Claude Code cloud sessions, bring up Docker with
# ARM (arm64, arm/v7) emulation so multi-arch images can be run and built.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

"$CLAUDE_PROJECT_DIR/tools/setup_docker_arm.sh"
