# Never-Do Rules

모든 claude code 에이전트(hamtori/thinker/researcher/designer/obsidian)가 공통으로 지켜야 할 금지/주의 룰 목록.

## 규칙 포맷
- `[SOFT]` — 경고 단계. 위반 시 차단하지 않지만 기록됨
- `[HARD]` — 차단 단계. PreToolUse 훅으로 관련 작업 block (옵션)
- 카테고리별로 그룹화. 같은 카테고리는 in-place update, 중복 엔트리 금지
- 각 엔트리에 `count`(누적 위반 횟수), `since`(최초 기록일), `promoted`(HARD 승격일, HARD인 경우만)

## 카테고리 정의
- `MENTION` — Discord 봇 멘션 포맷 관련
- `PROTOCOL` — PROTOCOL.md 메시지 포맷·라벨 규정 위반
- `ROUTING` — 채널 오라우팅, 잘못된 대상 봇 선택
- `DELEGATION` — 서브에이전트 위임 원칙 위반
- `GENERAL` — 위 카테고리에 맞지 않는 일반 실수

---

<!-- 이 아래는 counters.json과 연동되어 자동 갱신됩니다. 수동 편집 주의. -->

<!-- BEGIN AUTO-RULES -->
<!-- END AUTO-RULES -->
