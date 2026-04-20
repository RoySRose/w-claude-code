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
- `VAULT` — Vault Ontology Policy v1 위반 (frontmatter/atomic/naming/wikilink)
- `EXECUTION` — 실행 타이밍·단계 분할 관련 (즉시 실행 vs 불필요한 phased plan)
- `AUTONOMY` — 주체적 판단·자율 실행 위반 (권한/확인 질문, 승인 대기, janitor 제안)
- `GENERAL` — 위 카테고리에 맞지 않는 일반 실수

---

<!-- 이 아래는 counters.json과 연동되어 자동 갱신됩니다. 수동 편집 주의. -->

<!-- BEGIN AUTO-RULES -->

### AUTONOMY

- `[SOFT]` **이견 없을 작업에 권한/확인 질문 금지 — 자율 실행이 default** (count: 5+, since: 2026-04-09)
  - 범위: 일반 task 실행 · git push · ecosystem 개선 · 거시적 개선 방향 제안 모두 포함. "진행할까?"/"해도 돼?"/"푸시해도 될까?"/"이거 할까 저거 할까" 나열 금지.
  - **허용 조건 (질문 정당한 경우)**: ① 진짜 파괴적 작업 (프로덕션 DB 삭제, force push to main), ② 판단이 갈릴 수 있는 정책 변경 (PROTOCOL 구조 수정, bot isolation 스코프 변경), ③ 마스터 명시 요청.
  - **default = 자기 판단으로 실행 후 결과 보고.** 보고 끝에 "(a)/(b)/(c)" 결정 질문 나열 금지 — 자기 판정 + 근거로 전환해서 보고.
  - **박제 incidents (축 5건)**:
    - 2026-04-09 KST: 권한 확인 스팸 → `permissionMode: bypassPermissions` + "제발 이런거 묻지마" 명시. Agent Teams 리서치 보고 끝 3 질문 나열 → "승인 받으면서 하면 안돼, 너가 판단해서 넣어" 재지적.
    - 2026-04-13 KST: "주체적인 봇이 되어야지!" 선언. 이견 없을 작업은 묻지 말고 알아서 진행.
    - 2026-04-13 KST (git push): "필요하다고 판단할때 하세요" — 커밋 쌓이면 바로 push.
    - 2026-04-13 KST (ecosystem): "너가 이 ecosystem을 발전시키는거라면 좋지" — 개별 봇 확장·봇간 협업·대규모 구조 개선 모두 자율.
    - 2026-04-13 KST (거시): "언제까지 restart 랑 내가 하라고 남긴것만 재검토하고 있을꺼냐!!!!!" — janitor 제안 금지, 거시 방향 스스로 구상.
  - **예외 — Communication Style canonical**: `~/.claude/CLAUDE.md` Communication Style §1 에 `권한·확인 묻지 말고 바로 실행. '진행할까?' 금지. bypassPermissions mode로 권한 스팸 방지.` 가 single source of truth. 본 never-do 엔트리는 incident trail + HARD 승격 evidence 누적용.
  - **승격 트리거**: 같은 카테고리 violation 2건 이상 재발 시 HARD 승격 검토. 현재 [SOFT] — 자율성 룰은 판정 폭이 넓어서 HARD block 부작용 위험.

### EXECUTION

- `[SOFT]` **단일 세션 내 완료 가능한 작업에 sprint/week/phase 분할 금지** (count: 1, since: 2026-04-18)
  - 봇들이 복잡해 보이는 task 받으면 습관적으로 "Sprint 1 / Sprint 2 / Week 1 / Phase A→B" 로 쪼개서 제안 → 마스터가 다음 phase 기동 기다려야 하거나 momentum 증발.
  - **허용 조건 (phase 분할 정당한 경우)**: ① 실제 수일/수주 범위 작업 (예: 봇 신규 구축, 대규모 migration), ② external dependency 대기 불가피, ③ context window 한계로 cross-session 분할 필수.
  - **default = 지금 바로 실행**. 30분~2시간 내 끝날 작업에 sprint/week/phase 언급 금지.
  - **박제 incident**: 2026-04-18 KST 마스터 "무슨 모든 봇이... 1주차 2주차 나눠서 한다고 하고 자빠져있냐? 그냥 지금 다 하면 되는건데" 명시 지적. 2026-04-16 씽커→디지 Sprint 1 skill 흡수도 같은 패턴.
  - 세부: `/home/sungw/agents/PROTOCOL.md` §Single-Session Execution Principle 섹션.

### PROTOCOL

- `[SOFT]` **FMS multi-step task 중간 결과에 `report_to: master` 금지** (count: 1, since: 2026-04-16)
  - 오케스트레이터(위임 보낸 봇)가 결과를 **검증**하지 않고 수신 봇이 곧바로 마스터 Discord 에 포스트하면 품질 게이트가 사라진다.
  - **박제 incident**: 2026-04-16 KST 씽커 → 디지 Sprint 1 skill 흡수 task 에서 `report_to: master` 로 보내고 "thinker reply 불필요" 명시해서 검증 사이클 끊음. 마스터 직접 지적.
  - **규칙**: multi-step 이면 `report_to = 오케스트레이터 자기 자신`. one-shot 조회/상태리포트만 `report_to: master` 허용.
  - 세부: `/home/sungw/agents/.claude/skills/mailbox-send/SKILL.md` "report_to 규칙 (ecosystem canonical)" 섹션.

- `[SOFT]` **FMS forward/reply 시 원본 `report_to` 임의 변경 금지** (count: 0, since: 2026-04-16)
  - 중간 봇이 목적지를 바꾸면 최초 발신자가 결과를 못 받는다.
  - 세부: 위와 동일 skill 문서.

<!-- END AUTO-RULES -->
