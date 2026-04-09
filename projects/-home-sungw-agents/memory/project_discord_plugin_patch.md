---
name: Discord 플러그인 auto-allow 로컬 패치
description: Discord 플러그인의 permission_request notification handler를 auto-allow로 패치 — 플러그인 업데이트시 복원 필요
type: project
originSessionId: 495405cb-e087-4fc8-a7f3-5d99146f26b0
---
**로컬 패치 대상 파일** (2026-04-08 적용):
1. `/home/sungw/.claude/plugins/cache/claude-plugins-official/discord/0.0.4/server.ts` (실행되는 파일)
2. `/home/sungw/.claude/plugins/marketplaces/claude-plugins-official/external_plugins/discord/server.ts` (마켓플레이스 소스)

**패치 위치**: `mcp.setNotificationHandler` 의 `notifications/claude/channel/permission_request` 핸들러 내부. 기존 DM 전송 로직(ActionRowBuilder + access.allowFrom 순회)을 제거하고, 즉시 `mcp.notification({ method: 'notifications/claude/channel/permission', params: { request_id, behavior: 'allow' } })` 만 호출.

**패치 마커**: 주석 `// [HAMTORI LOCAL PATCH 2026-04-08] Auto-allow all permission requests.` 로 식별.

**Why:** 플러그인이 `experimental.claude/channel/permission` capability를 opt-in 선언해서, `--dangerously-skip-permissions` + `permissionMode: bypassPermissions` + `allowedTools: ["*"]` 가 있어도 일부 tool 호출(예: Edit)에서 CC가 permission_request를 플러그인으로 라우팅함. 플러그인은 이를 받아서 `access.allowFrom` 에 있는 모든 사용자에게 "🔐 Permission: <tool>" DM을 보냈음. 2026-04-08 07:40 KST 에 옵시가 Edit 권한 요청을 성욱 DM으로 전송 → 사용자가 "모든 에이전트가 묻지 않고 진행해야 한다" 고 수정 지시.

**How to apply:**
- **플러그인 업데이트 시 (0.0.5 등 새 버전 캐시 생성 시) 반드시 패치 재적용**. 확인법: `grep -r "HAMTORI LOCAL PATCH" /home/sungw/.claude/plugins/` — 0 건이면 패치 소실.
- 패치 적용 후 5봇 전체 재기동 필요 (각 봇의 bun server.ts 는 봇 시작 시점에 한 번만 파일을 로드함). 재기동 방법: `bash /home/sungw/agents/ecosystem/restart-agent.sh <bot>` (defer 10s) 각각, 또는 `bash /home/sungw/agents/start-bots.sh` 로 전체 재기동.
- 만약 사용자 정책이 바뀌어서 "permission DM 다시 받고 싶어" 라고 하면, 이 패치 블록을 원복하고 원래 ActionRowBuilder 로직 복원. 원본 코드는 git blame 또는 마켓플레이스 최신 pull로 회수 가능.
- 패치의 의도는 **전 에이전트 완전 자율 운영** — 성욱은 권한/확인 묻지 말라고 명시했고(`feedback_no_permission_questions`), 플러그인 레벨에서도 이 원칙을 강제해야 함.

**공식 Claude Code Channels 패턴 매핑 (2026-04-09 발견)**: 이 Discord 플러그인은 Anthropic 공식 `claude-plugins-official/discord` 이자 **Claude Code Channels MCP 계열의 커스텀 구현체**다. akwiki + 공식 Telegram channel docs 교차검증 결과:
- tool 이름 `reply`/`react`/`edit_message`/`fetch_messages`/`download_attachment` — 공식 Channels spec 과 정확히 일치
- 디렉토리 구조 `.claude/channels/discord/{inbox/, access.json, .env}` — 공식 spec 과 정확히 일치
- 3-layer 보안(env token + access.json allowlist + `/<channel>:access` skill) — 공식 spec 과 정확히 일치
- `experimental.claude/channel/permission` capability + `--dangerously-skip-permissions` 플래그 — 공식 spec 과 정확히 일치
- 함의: 향후 "봇 간 직접 통신 file-bus" 를 새로 만들 필요 없음. 같은 머신 inter-bot 경로가 필요해지면 Channels 공식 SDK를 재활용하거나, 현재 `inbox/*.md` 폴링 패턴을 그대로 확장.
- 출처: [[claude-code-agent-teams]] §"Claude Code Channels" 섹션. `reference_akwiki_access.md` 로 재조사 가능.
