---
name: FMS 는 inotify 기반, polling 금지
description: filesystem mailbox watcher 설계 시 polling fallback 을 넣지 말 것. 이벤트 기반 (inotify + startup reconciliation) 이 의도된 설계.
type: feedback
originSessionId: fcd09806-e556-4702-ba21-b4cdc743d1f3
---
`ecosystem/mail-watcher.sh` 같은 filesystem mailbox watcher 설계 시 **polling 쓰지 마라**. inotifywait monitor mode (`-m`) + 기동 시 startup reconciliation 으로 충분하다.

**Why**: 마스터가 2026-04-09 FMS 설계 중 명시적으로 지적함. 내가 "inotify + polling 하이브리드 → 단순화하려면 polling 으로 통일" 로 플립했을 때: "아니 polling 을. 하면 아무것도 안할때도 끊임없이 polling 을 하는데 ecosystem/mail-watcher.sh 이거를 만드려는게. 처음 내가. 이야기한 아래를 실현하려는거 아니였어?" — 에이전트코리아 research 인용하며 이벤트 기반이 원래 의도임을 재확인. Polling 은 idle 시에도 CPU 쓰는 안티 패턴.

**How to apply**:
- filesystem event 감시에는 `inotifywait -m` (Linux) / `fswatch` (macOS) 사용.
- Watcher 다운타임 대비는 polling 이 아니라 **startup reconciliation** 으로 해결: 기동 시 pending/ 전수 스캔하여 missed events 재주입. 그 뒤 inotify loop 진입.
- "단순화" 명분으로 polling 전환 금지. "hybrid 복잡도 제거" 와 "더 단순한 메커니즘 선택" 은 다른 문제다 — 전자는 설계 정비, 후자는 성능 퇴보.
- 의심되면 원래 요구를 다시 읽고 설계 의도 재확인.
