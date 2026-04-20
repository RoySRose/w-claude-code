---
name: discussion 채널 — 봇간 자기개선 토론 채널 (ID 1494027439163048127)
description: 마스터 공식 네이밍 "discussion". 내부 별칭 "bot-lab" 사용 금지. mention-only 필터 + hop=20 + @everyone+정지키워드(잠깐/pause/stop) panic-button
type: project
originSessionId: 8dd4aa8e-894f-4976-8ec1-349a6ecc7859
---
# discussion 채널

**공식 네이밍**: `discussion` (2026-04-16 마스터 명명). 이전 내부 별칭 "bot-lab" 은 **사용 금지** — 코드 커밋/코멘트/문서 신규 작성 시 모두 "discussion" 으로 표기.

**Why**: 마스터가 직접 정정한 호칭. 일관된 네이밍은 ecosystem 내 검색·인지 비용을 줄인다.

**How to apply**:
- 신규 문서/commit/Discord 메시지/메모리에서 "discussion 채널" 로 지칭
- 기존 `bot-lab` 으로 커밋된 registry 코멘트/변수명은 historic 보존 (커밋 히스토리 파편화 방지). 다만 다음 touch 시 함께 rename
- `mention_only_channels` 배열의 channel_id 는 그대로 (`"1494027439163048127"`)

**채널 사양**:
- **채널 ID**: `1494027439163048127`
- **참여 봇**: hamtori / thinker / researcher / designer / obsidian (5봇, access.json `groups` 에 등록됨. 2026-04-16 최초 4봇 패치, 2026-04-17 씽커 참여 확장 — 마스터가 00:36 KST "씽커 너가 브리핑을 해주고" 로 명시적 참여 위임)
- **수신 규칙** (server.ts handleInbound pre-filter):
  - `@mention` 없는 메시지 → LLM 호출 없이 drop
  - `[hop:N]` 이 `DISCORD_MENTION_MAX_HOP`(=20) 이상이면 drop — 봇간 ping-pong 폭주 방지
  - `@everyone` + 정지 키워드(`잠깐`/`pause`/`stop`) 동시 등장 시 즉시 drop (panic button, 토큰 비용 0)
- **access.json**: 각 봇의 `groups["1494027439163048127"] = {"requireMention": true, "allowFrom": []}` — 멘션 필수, 발신자 화이트리스트 비움(다른 봇·마스터 모두 멘션으로 호출 가능)
- **hot reload**: `DISCORD_ACCESS_MODE=static` 미설정 → `loadAccess()` 가 inbound 마다 파일 재읽기. access.json 편집은 **재시작 불필요**

**운영 규약**:
- 봇들이 서로 멘션할 때 `[hop:N]` 태그로 hop 관리
- 마스터가 보내는 메시지는 hop_count 초기화 전제 (마스터는 순수 시작점)
- teacher 는 현재 참여 대상 아님 (2026-04-16 기준)

**박제 incident / 역사**:
- 2026-04-16 02:22 KST commit `460ab57` — mention-only 필터 구조 도입
- 2026-04-16 02:38 KST commit `1c1d616` — 채널 1494027439163048127 활성화 (max_hop 20, panic 키워드)
- 2026-04-16 02:53 KST 햄토리 — 4봇 access.json `groups` 엔트리 누락 발견, python patch + `.bak.20260416` 백업
- 2026-04-16 첫 테스트 — 마스터 `@햄토리 안녕` discussion 채널 첫 응답 성공
- 2026-04-16 마스터 — 채널 공식 네이밍 "discussion" 선포
