---
name: Claude CLI --channels 플래그 문서화 제거 (2.1.109 기준)
description: 2.1.109부터 --channels 가 --help에서 사라졌지만 런타임은 정상 동작. 다음 업데이트 전 changelog 필수 확인
type: project
originSessionId: ac874fac-e140-4da2-a311-a8a465fb9ea6
---
2026-04-15 Claude CLI 2.1.97 → 2.1.109 업데이트 중 발견.

**사실:**
- `--channels` 플래그는 2.1.109 `--help` 출력에 더 이상 보이지 않음
- 그러나 런타임은 여전히 accept — 6봇 + chokie 전부 `--channels plugin:discord@claude-plugins-official` 로 정상 기동, Discord 플러그인 리스닝 OK
- tmux 배너도 기존처럼 "Listening for channel messages from: plugin:discord@..." + "Restart Claude Code without --channels to disable" 출력

**Why:** Anthropic이 이 flag를 private/undocumented 상태로 내린 듯. 공식적으로는 "Remote Control" 인터페이스로 대체되는 과도기로 보임 (2.1.109에 `--remote-control-session-name-prefix` 신규 flag 등장).

**How to apply:** 
- 다음 Claude CLI 업데이트 전에 항상 `--help | grep channels` 로 동작 여부 재확인
- 만약 런타임에서도 제거되면 Discord 플러그인 로딩 경로 재설계 필요 (start-bots.sh 수정)
- 백업 버전 `/home/sungw/.local/share/claude/versions/2.1.97` 은 safety-net 으로 유지
- 캐너리 업데이트 시 "씽커만 먼저 → 확인 → 전체 롤아웃" 패턴이 유효했음 (2026-04-15 증명)
