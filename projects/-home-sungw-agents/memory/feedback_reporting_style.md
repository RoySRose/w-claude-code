---
name: 결과·보고가 중요한 사용자 — 상세 리포트 필수
description: 성욱은 작업 결과와 보고를 중시하는 사람. 한 줄 요약·축약 보고 금지, "무엇을 확인했고 왜 그렇게 판정했고 무슨 액션을 취했는지" 이해 가능하게 써야 함
type: feedback
---

성욱은 결과와 보고가 중요한 사람이다. self-evolving loop, curation, 에피소드 리뷰, skill 승격, 룰 승격 등 모든 "판정" 계열 작업의 결과는 **상세 보고 포맷** 으로 써야 한다.

**필수 항목**:
1. 리뷰 대상 (어떤 파일·엔트리·세션을 봤는지, 경로 포함)
2. 확인 내용 (실제 들여다본 내용 요약 1-3줄)
3. 판정 (KEEP / DISCARD / PROMOTED / MERGED)
4. 판정 근거 (EVOLUTION_FILTER 어느 기준에 걸렸는지, 3x+ 반복 여부 등)
5. 취한 액션 (생성·수정된 파일 경로, discarded.log 기록, in-place update 등)

**금지**:
- `[RESULT] thinker/...: No 3x+ workflow pattern detected. Status: DISCARDED ✓` 같은 한 줄 요약
- "DONE", "완료", "OK" 수준의 축약 응답
- 주어(발신 주체)가 생략된 모호한 포맷

**Why:** 2026-04-08 옵시가 thinker 세션 리뷰 결과를 햄토리 채널에 `[RESULT] thinker/20260408-161209-auto.jsonl: ... DISCARDED ✓` 한 줄로 보고했을 때, 성욱이 "obsidian이 thinker 인척하고 여기다 보내는거야?" 라고 혼동함. 메시지가 너무 축약돼서 (1) 주어가 불분명하고 (2) 무엇을 확인했는지 알 수 없었음. 성욱 본인이 명시: "나는 결과와 보고가 중요한 사람이야. 결과물을 나한테 내가 이해할 수 있게 해줘야 해. compaction 이후에 어떠한 것들을 확인했고 그래서 skill 로 격상을 시켰다거나."

**How to apply:**
- self-evolving loop 결과 보고, curation 판정, skill/rule 승격 리포트, daily wrap-up, 에피소드 리뷰 등 모든 "판정+액션" 작업에서 상세 포맷 준수
- obsidian 의 보고 포맷은 `obsidian/CLAUDE.md` "보고 포맷" 섹션에 박제됨 (2026-04-08 추가)
- 다른 봇·다른 컨텍스트에서도 판정+보고가 있으면 동일 원칙 적용: 리뷰 대상/확인/판정/근거/액션 5개 필드
- 단순 실행 완료 보고(예: "파일 저장됨")는 축약 허용. 판정이 들어간 경우만 상세 포맷 필수
