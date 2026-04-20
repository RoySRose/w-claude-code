---
name: "순서대로 하라" = 출력 순서, 병렬 실행 금지 아님
description: 마스터가 "A 끝나고 B 해봐"라고 말해도 독립 가능한 subagent 작업이면 병렬 런칭하고 출력만 순서대로 전달. 2026-04-15 vibemotion 채팅 매커니즘→skill 분석 순차 진행 시 직접 지적받음.
type: feedback
originSessionId: 0547a83e-4c58-4e9f-a921-cb856e12b036
---
마스터 원문: "너가 센스있게 subagent 로 한번에 할 수 있는건 좀 하자" (2026-04-15 16:39 KST, Discord #cc-harness-sonnet)

## 규칙
"A 먼저 하고 B 해봐" 같은 순차 지시도:
- **독립적인 subagent 작업**이면 두 개 병렬 런칭
- 병렬 런칭 후 **출력은 지시 순서대로** 전달 (A 결과 먼저 보내고 B 결과 뒤에)
- Phase 1이 Phase 2 결과를 input으로 쓰지 않으면 반드시 병렬

**Why**: 마스터 시간 절약이 항상 우선. 직렬 대기 = 18분 침묵 위반 + 생산성 손실. Subagent는 격리 실행이라 서로 간섭 없음.

**How to apply**:
- 지시 분해 시 "B가 A 결과에 의존하는가?" 체크
- 의존 없으면 → 즉시 두 개 `Agent(run_in_background=true)` (또는 한 메시지에 2개 동시 런칭)
- Phase 1 먼저 완료되면 결과 전달하면서 "Phase 2 백그라운드 러닝 중"이라고만 언급
- 절대 Phase 2를 Phase 1 완료 후에 런칭하지 말 것 (최소 1턴 낭비)

## 판단 기준
"A가 끝나고 B"라는 말의 두 가지 해석:
1. **출력 순서**(대부분): "먼저 A 결과 보고, 그 다음 B 결과 보고" → 병렬 실행 OK
2. **실행 의존**(예외): "A 결과를 B에 input으로" → 직렬 필수

의심되면 **1번으로 가정**. 마스터는 기본적으로 효율적 병렬을 원한다.

## 재발 방지
- TaskCreate/TodoWrite에 Phase 1/2 둘 다 처음부터 in_progress로 등록
- 첫 메시지에서 "두 subagent 병렬 런칭했어, Phase 1이 먼저 돌아오면 바로 보고"라고 통지
