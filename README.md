# ProPain270

I build Android and macOS apps, along with tools for self-hosted services and network operations. My projects use Kotlin, Swift, Flutter, Python, C++ and Terraform. I care about recovering from interrupted work and making system state visible to the person using it.

## Selected projects

| Project | What it demonstrates |
| --- | --- |
| [Replay Android](https://github.com/ProPain270/replay-android-resume) | Kotlin/Compose emulator frontend with a JNI/C++ runtime, save recovery and adaptive controls. Validation includes 119 JVM tests, 9 emulator journeys and native core checks. [Validation notes](https://github.com/ProPain270/replay-android-resume/blob/main/VALIDATION.md) document hardware and distribution limits. |
| [HatchMap](https://github.com/ProPain270/hatchmap) | SwiftUI desktop app, Flutter client and Python services sharing a versioned JSON contract. The UI keeps stale and unknown data visible, while network analysis attributes traffic to devices and remote actions use an allow-list. |
| [Galaxy Flow](https://github.com/ProPain270/galaxy-flow-portfolio) | Local Android workspace with persisted notes, pause/recovery across lifecycle changes and explicit approval before a Calendar draft handoff. Fold/window observations stay separate from layout previews. [Validation notes](https://github.com/ProPain270/galaxy-flow-portfolio/blob/main/VALIDATION.md) cover 7 browser tests, 7 Kotlin tests and 8 emulator tests. |
| [UniFi + Home Assistant VLAN kit](https://github.com/ProPain270/unifi-haos-vlan-kit) | Terraform configuration for five network segments, three SSIDs, firewall isolation and switch-port profiles. Site variables and a deployment runbook make the configuration reusable. |

## Smaller tools

- [Medabots GBA toolkit](https://github.com/ProPain270/medabots-gba-toolkit): dependency-free Python tooling for binary data inspection, CSV editing and IPS patch creation. Game data is excluded.
- [Jellyfin Glance widget](https://github.com/ProPain270/jellyfin-glance-widget): Android home-screen widgets with background refresh, endpoint fallback and media/request mapping. The README records credential-storage and service-interoperability limits.
- [Agent discipline skills](https://github.com/ProPain270/agent-discipline-skills): six portable workflows for evidence tracking, decision review and controlled execution, plus a bounded toy simulation.

These are personal development projects. Each repository describes its build steps and current scope. Emulator and unit-test results have specific limits, which the validation notes spell out.
