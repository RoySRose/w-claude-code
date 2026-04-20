---
name: ecosystem 재설계 아이디어 = 옵시/햄토리 meta-skill 영역
description: 폴링→이벤트드리븐 전환, 훅 재설계, 스킬 폐루프 구조변경 같은 ecosystem-level 사고는 옵시/햄토리가 스킬로 보유해야 할 메타 능력
type: feedback
originSessionId: 9b5d5762-49be-4809-9681-13bf4d17c1e9
---
2026-04-17 마스터 선언: "이런 아이디어를 스킬로 가지고 있어야겠어 — 너(옵시)랑 햄토리는."

**Why**: 옵시 = ecosystem 관리자 + 전략적 지식 책임자, 햄토리 = 변화 전파 관리자. 두 봇이 ecosystem 구조 자체를 재설계하는 사고(polling→event-driven 전환, 중복 훅 판별, 책임 재분배 등)를 자연스럽게 수행해야 함. 일반 작업 스킬과 별개의 meta-skill 카테고리.

**How to apply**:
- 옵시/햄토리 세션에서 ecosystem 구조적 문제를 발견하면 "보고"에 그치지 말고 **재설계 대안까지 제시**
- 설계안은 self-contained (수치 기준 / 중복 체크 / 역할 적합성 / 기존 요소 정리 포함)
- 구현은 마스터 승인 후, 박제는 상시 (Decision Log / Known Gaps / memory)
- 다른 봇이 ecosystem 구조 변경을 제안하면 "이건 옵시/햄토리 영역" 라우팅 가능
