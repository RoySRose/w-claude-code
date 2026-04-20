---
name: Edu Briefing W16 Feedback — 태오 세션 적합도 이슈
description: 2026-04-18 teacher reply 에서 온 W16 edu 브리핑 큐레이션 피드백. 8세 making material 부족, policy/risk 담론 과잉
type: project
originSessionId: 7c51d70e-45f3-4cfb-884d-80d6d37603e0
---
# Edu Briefing W16 Feedback

Teacher가 W16 브리핑(839건 / 15 top items) 큐레이션 후 보낸 feedback. 2026-04-18 KST, mail id `20260418-222939-33f85062`.

## Issue
- W16 top 15 중 **policy/risk 담론 13건, age-relevant 2건** (#1 Nikkei India 8세, #6 NPR China curriculum)
- 8세 making material로 직접 쓸 만한 건 0건 — teacher가 전부 메타인지로 번역해야 했음
- 번역 부담 크고, 실타래 making 강도 낮음

**Why:** Teacher의 주요 유저는 **태오(8세, 낙생초 1학년 5반)**. 세션은 "making + wondering" 구조라 구체적인 making 소스 필요. 현 브리핑 구조는 "정책 담론 → 8세 활동" 2단 변환 부담.

**How to apply:** 다음 W17 브리핑(2026-04-22 수요일 cron)부터 making/사용자 후기 지향 소스 포함 확인.
- `/home/sungw/.openclaw/workspace-researcher/edu/config.json` 에 2026-04-18 반영된 신규 쿼리:
  - HN: "AI tools kids review parents", "kids AI tutorial hands-on project", "AI toy review children"
  - Perplexity: 8세 parent review, tutorial 구체 예시, KR 한국어 쿼리
  - Google News: KR "초등학생 AI 도구 후기 부모", "아이 AI 활동 사례 블로그"
- W17 브리핑 생성 후 making-oriented 아이템 비율 체크 (목표: 15건 중 ≥ 5건)
- teacher confidence: med (1주차 데이터로 일반화 이름) — W17-W18 관찰 후 config 재조정 여부 판단

## Reference
- Original mail: `/home/sungw/agents/mail/researcher/done/20260418-222939-33f85062-edu-briefing-curated.md`
- Parent task id: `20260418-100001-c8a42e05`
- 채택된 주말 세션: A "AI한테 일부러 틀리게 시키기 챌린지" + B "10년 후 안 사라질 내 능력 지도"
- Discord teacher msg: id 1495053585015115920 (#cc-teacher)
