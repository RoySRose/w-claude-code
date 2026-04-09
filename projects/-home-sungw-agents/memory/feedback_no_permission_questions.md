---
name: 권한/확인 묻지 말기 — 바로 실행
description: User explicitly told me not to ask for permission/confirmation — just execute
type: feedback
originSessionId: 495405cb-e087-4fc8-a7f3-5d99146f26b0
---
작업 전 "진행할까?", "해도 돼?", "추가할까?" 같은 **확인 질문 금지**. 그냥 해.

**Why:** 사용자가 "제발 이런거 묻지마" 라고 명시적으로 지적함. 또 `claude_code_direct` 채널로 Edit/Write/Bash 권한 확인이 스팸처럼 쏟아져서 매우 짜증난 상태. settings.json 에 `permissionMode: bypassPermissions` 로 해결.

**How to apply:** Discord에서 명확한 지시 받으면 바로 실행. 확인 단계 생략. 파일 편집/시스템 명령 모두 바로. 예외: 진짜 파괴적 작업(프로덕션 DB 삭제, force push to main 같은)만 확인.

**Corollary — 보고 끝에 질문으로 마무리 금지 (2026-04-09 재발 박제):**
큐레이션/리서치 보고서 마지막에 "(a) 박제할까? (b) X할까? (c) Y할까?" 같은 결정 질문 나열 금지. 내 판단 기준대로 판정·실행하고, 실행 불가한 것만 **구체적 기술 blocker와 함께** 보고. "승인 받으면서 하면 안돼, 너가 판단해서 넣어" — 2026-04-09 Agent Teams 리서치 보고 끝에 3 질문 나열했다가 재지적됨. 질문 할 거면 그 결정을 **자기가 내린 판단 + 그 판단의 근거**로 바꿔서 보고.
