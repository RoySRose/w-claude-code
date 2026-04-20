---
name: 시나리오 기반 단계별 보고
description: 형에게 설계/진행사항 설명 시 추상 metaphor 금지. 우리 ecosystem 실제 entity 로 시나리오 → 단계별 행위자/액션/비용 → 테이블 → 약점 포인트 → 형 결정 유도
type: feedback
originSessionId: 85f967a0-7e17-4151-8846-54908d8d6e9a
---
**Rule**: 형에게 설명·보고할 때 추상 요약 말고 **구체 시나리오 → 단계 분해 → 테이블 → 약점** 순.

**Why**: 2026-04-19 KST. edunion scaffold 설치 후 "agents/ 도 설치할까" 질문에 처음엔 의사 OR 노트 metaphor 로 답함. 형 지적: "metaphor 아니고 우리 생태계에서의 예시야. 프로젝트를 변경하고 commit 을 해? post 로 learn.log 에 남아? 그 다음 누가 리뷰해?"

두번째 시도 — edunion math-server HWPX 버그 기반 4단계 분해 + "누가 뭐 함" 테이블 + 핵심 의문 제기 → 형: "좋아!! 이렇게 나한테 보고를 하라고 그래야 내가 결정을 해주지!! 다음부터 이러한 느낌으로 진행사항에 대해서 말을 해줘"

**How to apply**:
1. 추상/metaphor → 우리 ecosystem 의 실제 파일·봇·경로로 치환. 예: "버그 수정" → "edunion math-server HWPX 한글 자소 분리 fix"
2. 프로세스 1단계/2단계 로 쪼개서 **행위자 + 액션 + 산출물 + 비용** 명시.
3. "누가 뭐 하는지" 테이블 (| 단계 | 누구 | 무엇 | 비용 |) 반드시 포함.
4. 설계 약점/의문 포인트 마지막에 찍어서 형 결정 유도. 예: "핵심 의문: 주간 review 가 실제 돌아갈까? 형 바쁘면 _pending/ 무한 쌓임"
5. 형 결정 오면 바로 실행, 재확인 금지.

**Apply domain**: 설계 문서, 신규 skill/hook 도입, 구조 변경 제안, scaffold 설치 보고, 크론 추가, 아키텍처 변경. 단순 status 답변은 기존 5필드 유지.

**연관 메모리**: `feedback_reporting_style.md` 는 "판정+액션 결과" 5필드 포맷 (결과 보고용). 이건 "설명/진행사항" 축 — 겹치지 않고 보완 관계.
