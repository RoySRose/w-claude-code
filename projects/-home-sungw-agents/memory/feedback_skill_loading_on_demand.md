---
name: 모든 봇의 skill은 INDEX 기반 on-demand 로드 (기본 정책)
description: 봇 CLAUDE.md에서 skill 본문 전체를 @import하지 말고 INDEX.md(메타데이터만)만 로드. LLM이 리스트 보고 판단 후 Read tool로 본문 호출. 희석(attention dilution) 방지 + skill 개수 scale 내성
type: feedback
originSessionId: 495405cb-e087-4fc8-a7f3-5d99146f26b0
---
모든 봇의 skill loading 기본 전략은 **INDEX-only @import + on-demand full body read**이다. 조건 없음, 예외 없음, 임계 수치 없음 — 모든 봇에 uniform 적용.

**Why (2026-04-09 마스터 합의):**
1. "스킬이 계속 늘어날텐데 한번에 다 던지면 희석이 되잖아" — skill 본문 N개를 매 세션 @import하면 **attention dilution**. 각 skill의 신호가 1/N로 떨어져 관련 skill의 매칭·회상 품질 저하. 토큰 비용은 곁다리 문제, 희석이 본질
2. "Skill은 리스트랑 내용[설명]만 기본호출에 들어가서 llm이 판단해야지. 스킬 전체내용이 들어가지 않아야지" — 메타데이터(name/description/triggers)만 기본 컨텍스트에 있고, full body는 필요 시 `Read` tool로 lazy load
3. "트리거 없이 그냥 다 그쪽으로" — 임계 조건/예외 없음. 박제형은 과도기 전략이 아니라 애초에 잘못된 default였음. scale 관점에서 on-demand가 유일한 지속 가능한 전략

**How to apply:**
1. **새 봇 부트스트랩 시**: `CLAUDE.md`에 `@import ../common/skills/INDEX.md`만 추가. 본인 skills가 생기면 `@import skills/INDEX.md` 추가. **절대 `*.md` glob 금지**
2. **새 skill 승격 시**: 해당 봇의 `skills/INDEX.md`에 name/description/triggers/file 엔트리 추가. 본문 파일은 그대로 `skills/<slug>.md`로 저장하되 CLAUDE.md에 @import 안 함
3. **frontmatter 품질 필수**: 모든 skill은 `description` + `triggers` 필수. 이게 on-demand 매칭 품질을 좌우. 허접한 description은 LLM이 skill을 놓침
4. **본문 호출은 `Read`**: LLM이 INDEX에서 적합 skill 식별 후 `Read("agents/.../skill.md")`로 본문 로드
5. **`@import skills/*.md` 또는 `@import common/skills/*.md` 금지** — glob expansion은 본문 전체 로드를 의미. 이건 희석 발생 경로이자 master가 명시적으로 거부한 패턴

**옵시(나) 학습 이력 (3중 실수):**
- **2026-04-08 `81de09a`**: 5봇 부트스트랩 일괄 박제 시 `@import skills/*.md`를 default로 삽입. designer까지 일률 적용. "공유 자산 도입 = 모두 @import" 근거 없는 일반화.
- **2026-04-09 03:?? G12 진단**: designer/CLAUDE.md에서 마스터가 working tree에서 2줄 제거한 것을 "사고"로 오진. revert 권고 → 실행 → 2차 실수
- **2026-04-09 03:?? framing 오류**: 마스터 정정 후 "designer = Bot layer 예외" framing으로 박제 시도. 마스터가 다시 정정 ("왜 디지만 예외야?") → "봇별 정책" framing으로 재수정
- **2026-04-09 03:?? 임계 rubric 제안**: "박제형 vs on-demand = 두 대등 전략, 조건부 선택" rubric 초안 제시. 마스터가 다시 정정 ("트리거 없이 그냥 다 그쪽으로") → 임계 없이 uniform
- **교훈**: "ecosystem 일관성"을 default로 두고 일률 적용하는 성향이 옵시 안에 반복. 새 구조 도입 시 **default 자체를 의심**해야 함. 마스터가 4번 연속 정정했다는 건 옵시의 초기 framing이 근본적으로 틀렸다는 신호

**적용 완료 (2026-04-09 commit 68a1d82):**
- 6 CLAUDE.md 전환 (hamtori/thinker/researcher/designer/obsidian/teacher)
- 5 INDEX.md 생성 (common + 4 bots with skills)
- designer/CLAUDE.md의 "예외" 프레이밍 본문 제거

**연결:**
- 4-Layer Configuration Model: `obsidian-vault/AI-Agents/4-layer-config-model.md`
- snapshot §3 Skills Inventory: on-demand 전환 반영 필요 (v6 update)
- Decision: `obsidian-vault/Decisions/2026-04-09-skill-loading-on-demand.md` 박제 필요
