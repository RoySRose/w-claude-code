---
name: Vault 저장 시 Personal vs Ecosystem 판정 후 라우팅
description: 마스터가 기록 요청할 때 personal(형 본인/주변)인지 ecosystem(봇 운영)인지 판정해 적절한 vault 폴더로. 나중에 "예전에 X 하라고 한게 뭐였지?" 같은 retrieval 가능하도록.
type: feedback
originSessionId: 9b5d5762-49be-4809-9681-13bf4d17c1e9
---
# Vault 저장 시 Personal vs Ecosystem 판정 후 라우팅

마스터가 "이거 기록해줘" 할 때 옵시가 판정 후 적절한 vault 폴더로 저장. 나중에 retrieval 가능성을 염두에 두고 위치 선택.

**Why**: 2026-04-19 마스터 직접 지시 — "예전에 건강을 위해 매일 하라고 한게 모가 잇지?" 같은 future query 에 즉시 답할 수 있어야 함. 잘못된 폴더에 넣으면 검색 실패 → 형이 같은 정보를 다시 전달해야 함.

**How to apply**: 저장 요청 받으면 **판정 먼저, 쓰기 다음**. 판정 rubric:

## 판정 Rubric

| 유형 | 판정 기준 | 저장 폴더 | 예시 |
|---|---|---|---|
| **Personal — 형 본인** | 형의 몸·일정·취미·선호·가족·건강 | `Profile/` | 건강 루틴, 커리어, 기술스택, 운동 기록 |
| **Personal — 주변 사람** | 지인·친구·회사 동료·가족 | `People/` | 특정 인물 프로필/에피소드 |
| **Personal — 태오 개인** | 8세 아들 개인 (vs 커리큘럼 일반) | `Profile/김태오-*` | 태오 개인 병원 기록, 친구 관계 |
| **Personal — 사이드 프로젝트** | 형 개인 사이드 프로젝트 | `Projects/` | 여행 가이드 앱 등 |
| **Ecosystem — decision** | 6봇 구조·정책·옵시·햄토리 결정 | `Decisions/` | 4-Layer Config, Friction Rules |
| **Ecosystem — 구조** | ecosystem architecture snapshot | `AI-Agents/` | ecosystem-snapshot, PROTOCOL |
| **Ecosystem — 교육 사업** | 태오 세션에서 뽑은 커리큘럼 일반화 | `Education/Theo-Lab/` | 세션 로그, insights, rules |
| **Knowledge — 외부 지식** | 학습 과학·기술·범용 참고 자료 | `Lessons/` or `Technologies/` | 논문 요약, SDK 문서 |
| **운영 logs** | 일별 회고·ecosystem 활동 요약 | `Daily/` | 2026-04-18.md |

## 경계 애매한 케이스 원칙

1. **기본은 Personal 우선** — "형이/내가/저한테/내" 시작하면 무조건 Personal
2. **Ecosystem 은 봇 포함일 때만** — "옵시/햄토리/씽커/디지/연구자/초키/티처/전체 봇" 이 들어가야
3. **둘 다 해당 시 양쪽 박제 + wikilink** — Personal 에 원문, Ecosystem 에 적용 노트, 서로 `[[wikilink]]` 연결
4. **모르겠으면 묻기** — "이거 Personal 이에요 Ecosystem 이에요?" 한 줄. 잘못 넣고 재분류 비용 > 묻는 비용

## Retrieval 강화 장치

- **frontmatter tags**: 동일 성격 파일은 동일 tag schema 유지 (예: 건강 관련은 전부 `tags: [profile, health, routine, ...]`) — 단일 tag 로 collect 가능
- **wikilink 연결**: 관련 파일끼리 양방향 링크. 한 파일에서 연관 전체 탐색 가능
- **원문 verbatim 박제**: 형 코멘트는 반드시 원문 그대로 quote. 해석 안 함 — 나중에 형이 "내가 뭐라고 했었지?" 물으면 원문 복원 가능해야 함

## 구체 사례 — 2026-04-19 건강 루틴

- 요청: "YouTube 10분 루틴 영상 기록해줘"
- 판정: Personal — 형 본인 건강 → `Profile/`
- 저장: `Profile/김성욱-건강.md` (신규 생성, 향후 건강 항목 누적 구조)
- 향후 query "예전에 건강을 위해 매일 하라고 한게 뭐였지?" → `tags: [health]` 또는 `Profile/김성욱-건강.md` 직접 hit 으로 답 가능

## 관련 참고

- `/home/sungw/obsidian-vault/Decisions/2026-04-15-vault-ontology-policy.md` — ontology 박제 결정 (frontmatter/wikilink 규정 포함)
