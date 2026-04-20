---
name: discord-reply-enforce Stop hook — transcript 출력만 하고 reply 미호출 방지
description: Discord 마스터 메시지에 reply tool 없이 턴 닫으면 exit 2로 block. 2026-04-17 설치, 6봇 전파 완료
type: project
originSessionId: 85f967a0-7e17-4151-8846-54908d8d6e9a
---
**사실**: `/home/sungw/agents/hooks/discord-reply-enforce.sh` Stop hook 설치. 6봇 (hamtori/thinker/researcher/designer/obsidian/teacher) `settings.json`의 `hooks.Stop`에 등록.

**Why:** 2026-04-17 KST 08:18 마스터가 "답하는데 왜 오래 걸리냐" 지적. 원인은 Claude Code 기본 UX 가정(text output = user-visible)과 Discord 봇 세션(reply tool만 user-facing) 사이의 inverse mismatch. 봇이 답을 transcript에 출력하고 "답했다"고 착각하며 턴을 닫는 실패 모드. CLAUDE.md 룰만으로는 망각하므로 hook으로 물리 강제.

**How to apply:**
- 동작: Stop hook이 transcript JSONL 역순 스캔 → 마지막 user text message가 `<channel source="plugin:discord:discord"...>` + `user_id="470970006449029130"`(마스터) 포함 + 이후 `mcp__plugin_discord_discord__(reply|edit_message|react)` tool_use 0건 → exit 2 + stderr 경고
- 봇간 메시지(다른 user_id)는 enforce 생략 — 너무 엄격하면 피해 큼
- 적용 시점: 각 봇 세션 **재시작 후**부터 (settings.json은 세션 시작 시 로드)
- 로그: `/home/sungw/agents/hooks/discord-reply-enforce.log` (BLOCK 이벤트만 기록)
- 테스트 케이스 4종 (BLOCK/PASS/SKIP-bot/SKIP-nonDiscord) 모두 통과 후 배포
- 향후 변경: MASTER_ID 상수 — `detect-correction.sh`·`bump_counter.py`와 동일 값. 변경 시 3곳 동시 갱신

**관련**: `feedback_discord_progress_updates.md` (상위 원칙: 침묵 금지), `feedback_discord_mention_only_no_wait_mode.md` (같은 계열 구조 문제).
