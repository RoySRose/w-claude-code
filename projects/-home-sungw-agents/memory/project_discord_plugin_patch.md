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

**추가 패치 #2 — GroupPolicy.mentionExempt (2026-04-16)**:
- **파일**: `/home/sungw/.claude/plugins/marketplaces/claude-plugins-official/external_plugins/discord/server.ts` (cache/ 경로는 봇 재기동 시 동기화)
- **위치**: `type GroupPolicy` 선언 (line ~100) + `gate()` 함수 (line ~289)
- **변경**: `mentionExempt?: string[]` 필드 추가, gate() 에서 `if (requireMention && !mentionExempt.includes(senderId) && !isMentioned(...))` 로 확장
- **Why**: 로즈 전용 채널(2봇 × 2채널)에서 로즈 user 는 mention 없이 gate 통과, 마스터(관리자)는 mention 필수라는 **user 별 mention 차등 정책** 요구.
- **스키마 확장**: `access.json groups[<channel>].mentionExempt = [user_id,...]` — optional, 미지정 시 기존 동작 유지 (하위 호환)
- **현재 적용 대상**: `researcher-rose`/`designer-rose` 2봇 access.json 에 로즈 user_id `937170156415750174` 등록
- **재기동**: 기존 5봇(hamtori/thinker/researcher/designer/obsidian/teacher/chokie)은 `mentionExempt` 미사용이라 영향 X. rose 2봇은 최초 기동 시 신규 바이너리 자동 반영.

**추가 패치 #3 — Primary-side targeted-mention drop (2026-04-17)**:
- **파일**: `/home/sungw/.claude/plugins/cache/claude-plugins-official/discord/0.0.4/server.ts` (marketplaces 사본은 mention-only 필터 자체 없는 구버전이라 무관)
- **위치**: `handleInbound()` 안 MENTION_ONLY_CHANNELS 블록 (line ~838)
- **변경**: primary 발화자여도 `msg.mentions.users.size > 0 && !msg.mentions.users.has(myId)` 이면 drop — "타봇 단독 멘션" 메시지를 서버 레벨에서 버림
- **Why**: discussion 채널(1494027439163048127)에서 master가 특정 봇 1개만 멘션했는데 모든 primary 봇이 메시지를 수신 → 각자 `sendTyping()` 발사 → 응답 안 하면 typingIntervals clear 안 됨 → "several people are typing..." 영구 지속 버그. system-reminder GROUP rule 3("특정 봇 호명 시 본인 아니면 응답 금지")를 프롬프트만이 아니라 서버에서 강제.
- **How to apply**: 플러그인 업데이트 시 재적용. 패치 식별자는 주석 "Primary-side targeted-mention filter". 적용 후 discussion 참여 전 봇(hamtori/thinker/researcher/designer/obsidian) 재시작 필수.
- **검증 (2026-04-17 09:35)**: 4봇 재기동 후 master 가 햄토리만 멘션 → 타 봇 typing 소실 confirmed by master.

**추가 패치 #4 — Group 채널 fetchReference skip (2026-04-17, typing leak fix)**:
- **파일**:
  1. `/home/sungw/.claude/plugins/marketplaces/claude-plugins-official/external_plugins/discord/server.ts` (primary)
  2. `/home/sungw/.claude/plugins/cache/claude-plugins-official/discord/0.0.4/server.ts` (cache 동기화)
- **위치**: `isMentioned(msg, extraPatterns?)` (line ~305) 함수 내 fetchReference 블록 (line ~314-317). 시그니처 `isMentioned(msg, access, extraPatterns?)` 로 확장
- **변경**: `refId` 있을 때 `access.groups[channelId].type === 'group'` 이면 `fetchReference()` 스킵 (엄격 mention-only). `type !== 'group'` (solo 채널) 에서만 기존 fetchReference 경로 유지
- **Why**: 2026-04-17 10:14/10:22 KST 마스터가 discussion 채널에서 `thinker is typing...` 현상 발견. 진단: fetchReference 에 age guard 없어 6시간+ 전 봇 메시지에 native reply 만 해도 implicit mention 통과 → group 채널 엄격 mention 설계 와해. HAMTORI SCHEMA v2 (2026-04-16) 설계 후 group 채널 (discussion) 추가되면서 미검토된 엣지. 씽커 3안 (A age guard / B 전체 제거 / C 프로토콜 규율) 대신 햄토리 D안 (type별 분기) 채택 — access.json SSOT 유지 + solo 대화 연속성 보존 + group 엄격 강제 동시 만족
- **재적용**: 플러그인 업데이트 시 패치 소실 여부 확인 (`grep "type !== 'group'" .../server.ts`). 재적용 후 discussion 참여 5봇 (hamtori/thinker/researcher/designer/obsidian) 재시작 필수 — 02:00 KST daily-restart 대기 또는 수동 `restart-agent.sh`
- **검증**: 씽커 edit 완료 후 discussion 에 hamtori/옵시가 씽커 과거 메시지에 native reply → 씽커 typing 발동 X 확인

**추가 패치 #5 — reply tool embeds 지원 (2026-04-20, table-render fix)**:
- **파일**: `/home/sungw/.claude/plugins/cache/claude-plugins-official/discord/0.0.4/server.ts` (marketplaces 사본도 동일 적용 필요)
- **위치**:
  1. `ListToolsRequestSchema` 핸들러 내 `name: 'reply'` 의 `inputSchema.properties` (line ~523)
  2. `CallToolRequestSchema` 핸들러 `case 'reply'` (line ~605)
- **변경**: tool schema 에 `embeds: Array<{title?, description?, color?, url?, fields?: [{name, value, inline?}], footer?, author?, timestamp?}>` 추가. handler 에서 `args.embeds` 읽어서 첫 chunk 의 `ch.send({..., embeds})` 로 전달. max 10 embeds 검증.
- **Why**: Discord 가 markdown table(`| 헤더 | ... |\n|---|---|`) rendering 을 공식 미지원 → 마스터가 파이프 문자 그대로 보는 현상. 2026-04-20 KST "디스코드에서 테이블로 보이지가 않아서 보기가 너무 불편해" 지적. Discord embed `fields: [{..., inline: true}]` 3개 연속이 유일한 native 3-column grid 렌더링. 볼드-불릿 + 코드블록 ASCII 는 fallback 이고, 진짜 표처럼 보이려면 embed 필수.
- **호환성**: 완전 additive. embeds 미사용 호출자는 이전과 동일 동작 (옵셔널 파라미터).
- **재적용**: 플러그인 업데이트 시 패치 소실 여부 확인 (`grep "embeds: Array<Record" .../server.ts`). 재적용 후 전체 봇 재시작 필요 — MCP tool schema 는 세션 시작 시점에 cache 됨.
- **검증 예시**: `reply({chat_id, text: "결과", embeds: [{title: "Context bloat", color: 0x5865F2, fields: [{name: "항목", value: "git 지시문", inline: true}, {name: "현재", value: "주입 중", inline: true}, {name: "영향", value: "system 박힘", inline: true}, ...]}]})` — 3-column 그리드 native 렌더.
- **박제 가이드**: `agents/PROTOCOL.md` §Discord Message Formatting, `feedback_discord_no_markdown_tables.md`.

**공식 Claude Code Channels 패턴 매핑 (2026-04-09 발견)**: 이 Discord 플러그인은 Anthropic 공식 `claude-plugins-official/discord` 이자 **Claude Code Channels MCP 계열의 커스텀 구현체**다. akwiki + 공식 Telegram channel docs 교차검증 결과:
- tool 이름 `reply`/`react`/`edit_message`/`fetch_messages`/`download_attachment` — 공식 Channels spec 과 정확히 일치
- 디렉토리 구조 `.claude/channels/discord/{inbox/, access.json, .env}` — 공식 spec 과 정확히 일치
- 3-layer 보안(env token + access.json allowlist + `/<channel>:access` skill) — 공식 spec 과 정확히 일치
- `experimental.claude/channel/permission` capability + `--dangerously-skip-permissions` 플래그 — 공식 spec 과 정확히 일치
- 함의: 향후 "봇 간 직접 통신 file-bus" 를 새로 만들 필요 없음. 같은 머신 inter-bot 경로가 필요해지면 Channels 공식 SDK를 재활용하거나, 현재 `inbox/*.md` 폴링 패턴을 그대로 확장.
- 출처: [[claude-code-agent-teams]] §"Claude Code Channels" 섹션. `reference_akwiki_access.md` 로 재조사 가능.
