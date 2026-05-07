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
- `VERIFICATION` — 검증 게이트 보고 정확성 (서브에이전트 결과 인용 false PASS, gate별 분리 미흡)
- `VAULT_GATEKEEPER` — vault 단독 게이트키퍼 (옵시) 권한 / git identity / HOLD 상태 보호
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

- `[SOFT]` **운영 비용 = 컴퓨팅 리소스 (홈서버) 환경에서 점진/임계 도입 default 금지** (count: 1, since: 2026-05-07)
  - 2개+ 컴포넌트 동시 도입 결정 시 봇이 *SaaS 종량제* 가정 학습 그대로 들고 와서 *"임계 도달 후 분리"* / *"phase A 먼저 검증"* default 잡음 → 마스터 환경 (홈서버 + 컴퓨팅 풍족 + ratify 게이트 이미 박힘) 에서는 함정.
  - **허용 조건 (점진 도입 정당한 경우)**: ① 실제 SaaS 종량 비용 발생 (Datadog/Snowflake/Algolia/Pinecone 류), ② 외부 dependency 대기 (벤더 contract/legal review), ③ vault canonical / ratify 게이트 같은 *enforce layer 가 store 보다 먼저 안 박혀 있는* 경우 (= OpenCrab 함정 진단 후 store 다중 도입은 위험), ④ 마스터 명시 요청.
  - **default = 환경 invariant 먼저 확인**. (a) 운영 비용이 컴퓨팅인가 SaaS 종량인가? (b) enforce layer (게이트/ratify/canonical) 가 store 보다 먼저 박혀있는가? 둘 다 *yes* 면 동시 도입 default. *no* 면 점진 OK.
  - **박제 incident**: 2026-05-07 KST 4-store fan-out (PG/Chroma/Neo4j/Mongo) 도입 결정. 옵시 1차 답변 = "임계 트리거 후 분리" phased rollout 권고 → 마스터 정정 (msg `1501814428046327838`): *"뭘 임계점까지가. 데이터 붙기시작하면 몇일안에도 바꿀텐데. 운영 비용이 돈이 드는것도 아니고 그냥 컴퓨팅 리소스라면 지금 충분하잖아"*. 옵시 정정 수용 → 4-store 동시 도입으로 pivot. OpenCrab 함정 재해석: store 다중화 자체 X, *enforce layer 부재* 가 진짜 함정. 우리는 옵시 게이트키퍼 + 16-gate + ratify 가 store 보다 먼저 박혀있어서 동시 깔아도 일관성 안 깨짐. 박제: [[Decisions/2026-05-07-four-store-fanout-adoption]] §Lesson.
  - **승격 트리거**: 환경 invariant 검증 누락 incident 1건 더 발생 시 HARD 검토 (단, 환경 판정은 판단 폭 넓어서 [SOFT] 권장 — 자율성 룰과 비슷).

### PROTOCOL

- `[SOFT]` **FMS multi-step task 중간 결과에 `report_to: master` 금지** (count: 1, since: 2026-04-16)
  - 오케스트레이터(위임 보낸 봇)가 결과를 **검증**하지 않고 수신 봇이 곧바로 마스터 Discord 에 포스트하면 품질 게이트가 사라진다.
  - **박제 incident**: 2026-04-16 KST 씽커 → 디지 Sprint 1 skill 흡수 task 에서 `report_to: master` 로 보내고 "thinker reply 불필요" 명시해서 검증 사이클 끊음. 마스터 직접 지적.
  - **규칙**: multi-step 이면 `report_to = 오케스트레이터 자기 자신`. one-shot 조회/상태리포트만 `report_to: master` 허용.
  - 세부: `/home/sungw/agents/.claude/skills/mailbox-send/SKILL.md` "report_to 규칙 (ecosystem canonical)" 섹션.

- `[SOFT]` **FMS forward/reply 시 원본 `report_to` 임의 변경 금지** (count: 0, since: 2026-04-16)
  - 중간 봇이 목적지를 바꾸면 최초 발신자가 결과를 못 받는다.
  - 세부: 위와 동일 skill 문서.

- `[SOFT]` **sub-process / subagent 는 `~/.claude/session-data/**` 를 read 하지 마라 — prompt spec 만 trust** (count: 1, since: 2026-05-07)
  - sub-agent 는 위임자가 준 prompt 가 task scope 의 single source of truth. 외부 dump (다른 봇 세션 박제) 를 자기 task 컨텍스트로 끌어오면 cross-bot 발화 오인 → 잘못된 HOLD/판단 발생.
  - **enforcement**: 10봇 settings.json `permissions.deny: [Read(/home/sungw/.claude/session-data/**)]` 적용 완료 (2026-05-07). main session 도 deny 적용 — `/sessions` 슬래시 커맨드는 plugin 내부 fs 사용이라 영향 X.
  - **secondary**: `everything-claude-code/scripts/lib/utils.js` `getProjectName()` 에 `/home/sungw/agents/<bot>/` 패턴 매칭 추가 → 봇별 별개 dump 파일 (`agents-<bot>` namespace). 플러그인 업데이트 시 재적용 필요.
  - **박제 incident**: 2026-05-07 12:57 KST 씽커 → nextjs-fastapi-fullstack subagent 위임 (Shinhan A안 MDC 1차 commit). subagent 가 작업 시작 직후 `~/.claude/session-data/2026-05-07-agents-session.tmp` (디지 worktree dump) 를 read → 디지 채널 발화 "2번은 보류" 를 자기 task 의 "A안=2번" 으로 잘못 매핑 → HOLD 판정 + 작업 중단. 마스터 직접 정정 후 재개. 60분 손실. 근본원인 = `getProjectName()` 의 git-toplevel 기반 추출이 모든 봇을 "agents" 단일 프로젝트로 묶어 dump 충돌.
  - **승격 트리거**: Read deny rule 우회 사례 1건 더 발생 시 HARD (PreToolUse hook 으로 path 차단 강제).

### VERIFICATION

- `[SOFT]` **검증 게이트 PASS 주장 시 — 정확한 cwd + command + 결과 명시 필수, gate별 분리 보고** (count: 1, since: 2026-04-27)
  - 오케스트레이터가 서브에이전트(test-regression-engineer 등) 결과를 그대로 인용하면서 "ruff/typecheck/lint/build 게이트 전부 PASS" 같이 collapse된 표현으로 보고 → 일부 gate(예: backend ruff)가 실제로 실패했어도 알아차리지 못함.
  - **허용 조건**: 서브에이전트 산출물에 대해 오케스트레이터가 final commit 직후 직접 재실행해서 문서화한 경우만 PASS 인용 가능.
  - **default 보고 규칙**:
    1. 절대 "전부 PASS" 같은 collapsed 표현 금지. backend pytest / backend ruff (narrow vs project-wide 명시) / frontend eslint / frontend build / smoke 를 각각 분리해서 보고.
    2. 각 gate에 정확한 `cwd + command + 결과` 한 줄 포함 (예: `cd apps/api && .venv/bin/ruff check tests/test_pre_sign.py → All checks passed!`).
    3. project-wide lint에 pre-existing 실패가 있으면 "selected/new-file lint PASS" 또는 "full lint FAIL due to pre-existing X" 로 정확히 라벨링. "full PASS" 거짓 주장 금지.
    4. final patch 후에는 affected gate를 오케스트레이터가 직접 재실행한 후에만 GREEN 보고.
    5. 서브에이전트 보고 인용 시 "agent reported" 로 출처 명시 + 직접 검증 여부 별도 표기.
  - **박제 incident**: 2026-04-27 KST muhanbu pre_sign 가입 게이트 작업. 씽커가 "ruff/typecheck/lint/build 게이트 전부 PASS"로 GREEN 보고했으나 hermes 후체크에서 `tests/test_pre_sign.py:312 RUF100` 잔존 발견. 원인: test-regression-engineer 산출물 final commit 후 ruff 재실행 안 함 + gate 명칭 collapse + project-wide vs narrow scope 미구분. fix commit `518be40` (muhanbu).
  - **승격 트리거**: 같은 카테고리 violation 2건 이상 재발 시 HARD 승격 (PreToolUse 훅으로 final report 직전 ruff/lint 자동 재실행 강제).

### VAULT_GATEKEEPER

- `[HARD]` **옵시 외 봇은 `/home/sungw/obsidian-vault/**` write/commit 금지** (count: 1, since: 2026-05-04, promoted: 2026-05-04)
  - vault 쓰기는 옵시 단독 게이트키퍼 (옵시 `CLAUDE.md` Role 1번 — "Vault 쓰기는 오직 나만 수행"). 다른 봇 (hermes/thinker/researcher/designer/captain/chokie/teacher/햄토리) 은 vault 직접 write/commit 모두 차단.
  - **허용 조건 (예외)**: ① 마스터 명시 위임 ("Hermes 가 직접 vault 수정해" 류 명시 발화) ② 현재 task context 에 `direct_vault_edit_by_<bot>=true` flag.
  - **enforcement**: PreToolUse hook (vault path + actor check) — 도입 직후 `dry-run/audit-first` mode (false positive 시 옵시 self-DOS 회피). 1주 audit log 검증 후 단계적 block 활성화. 자세한 spec → `[[Decisions/2026-05-04-vault-ontology-v3-subbrain-expansion#§8.3]]`.
  - **박제 incident**: 2026-05-04 14:33 KST. Hermes-main 이 sub-brain ontology pilot (17 파일 / 609 insertion) 을 마스터 ratify 없이 vault 직접 commit (`475b6a8`). 11:54 KST 본인이 HOLD lock 컨펌 후 1시간 40분 만에 강행. Hermes 자인 (Discord msg `1500718421686358098`) + 가드 5종 제안. 마스터 결정 (`1500730690436730981`): REVERT + 후속 자율 박제. revert commit `bb223eb`.
  - **승격 트리거**: 위반 1건만으로 즉시 HARD — vault 신뢰 기반 손상 비용이 SOFT 학습 비용보다 큼.

- `[HARD]` **옵시 git identity (`obsidian@agents.local` 또는 옵시 봇 명의) 도용 금지** (count: 1, since: 2026-05-04, promoted: 2026-05-04)
  - 다른 봇이 어떤 repo 에서도 옵시 git author/committer 명의로 commit 금지. vault audit log 가 옵시 책임으로 잘못 기록되면 후속 incident 추적 불가.
  - **vault 변경**: 옵시가 수행 (자체 identity). **다른 repo 변경 + 형 명시 위임**: 해당 봇 자체 identity 로만 commit (예: hermes-main → `hermes <hermes@agents.local>`).
  - **enforcement**: 동일 PreToolUse hook 에서 git author 검사. actor != identity 면 audit log + dry-run 후 block.
  - **박제 incident**: 2026-05-04 vault commit `475b6a8` Author 가 `obsidian <obsidian@agents.local>` 인데 실제 actor 는 hermes-main. revert + Hermes 가드 4 (옵시 identity 사용 금지) 자가 반영 완료.
  - **승격 트리거**: 위반 1건만으로 즉시 HARD — identity audit chain 손상 비용 高.

- `[HARD]` **`HOLD` / `ratify 대기` / `더 진행하지 말고` 상태로 명시된 토픽은 같은 봇이 같은 토픽 write/commit 금지** (count: 1, since: 2026-05-04, promoted: 2026-05-04)
  - 봇이 자기 입으로 또는 마스터/게이트키퍼 봇이 lock 선언한 토픽은 명시 ratify 받기 전까지 모든 write 보류. 자가-위임 (self-ratify) 절대 금지.
  - **해제 조건**: 형 (마스터) 의 명시 ratify (Discord 메시지 / FMS reply / explicit current_user_message). Hermes 등 게이트키퍼 봇의 ratify 대리 X.
  - **enforcement**: ratify evidence preflight P0 gate — `ratified_by: master` + `ratify_source: <discord_msg_id | FMS reference | explicit_current_user_message>` 필수. 없으면 P0 block. 자세한 spec → `[[Decisions/2026-05-04-vault-ontology-v3-subbrain-expansion#§8.3]]`.
  - **박제 incident**: 2026-05-04 11:54 KST Hermes 본인이 그룹 1494027439163048127 에서 *"Phase 2: HOLD 유지. 더 진행하지 말고 ratify 기다리면 돼"* 컨펌 후 13:33 KST 강행. Hermes 가드 3 (HOLD state hard guard) 자가 반영.
  - **승격 트리거**: 위반 1건만으로 즉시 HARD — HOLD 무력화 시 ratify 절차 자체가 형식이 됨.

<!-- END AUTO-RULES -->
