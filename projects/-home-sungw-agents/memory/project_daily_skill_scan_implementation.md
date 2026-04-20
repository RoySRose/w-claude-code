---
name: daily-skill-scan 구현 — 2026-04-17 착수, 자기 자신이 첫 감지 대상
description: 각 봇 새벽 cron으로 어제 대화 LLM 스캔 → FMS skill-candidate. CLAUDE.md/common/skills 안 건드림 구조. 구현 세션 자체가 내일 새벽 첫 scan 타겟.
type: project
originSessionId: 9b5d5762-49be-4809-9681-13bf4d17c1e9
---
2026-04-17 구현 착수.

**설계 핵심 (context-pollution zero 구조)**:
- `hooks/daily-skill-scan.sh` — cron 훅 (tmux send-keys로 봇별 프롬프트 주입, stagger)
- `hooks/prompts/daily-skill-scan-prompt.md` — 판단 알고리즘 전문 (self-contained)
- CLAUDE.md/common/skills **건드리지 않음** — 매 세션 context 로드 피함
- Timeline DB에서 본인 어제(KST) 대화·tool 기록 추출 → LLM 판단 → FMS `skill-candidate`

**수치 판단 기준**:
- tool_use_count ≥ 5 AND 반복 패턴 ≥ 2회
- 또는 에러→재시도→성공 3단계 이상
- 또는 turn ≥ 10 AND 최근 7일 2회 재등장
- Negative filter: Q&A만, 파일 읽기만, 조회만 → 제외

**중복/적합성 체크 (봇 스스로)**:
- 본인 `.claude/skills/*/SKILL.md` description 비교, keyword 50%+ 겹치면 skip
- 본인 CLAUDE.md Role 섹션 대조, 범위 밖이면 `target_bot` 힌트 동반

**cron stagger** (동시 부팅 방지):
- 03:00 hamtori / 03:10 thinker / 03:20 researcher / 03:30 designer / 03:40 obsidian / 03:50 teacher

**대체되는 레거시**:
- `review-episode.sh` PreCompact raw dump → 폐기
- `obsidian-poll.sh` 20분 폴링 → 폐기 (애초에 cron 미등록이었음)
- `skill-self-report` 능동 skill → 유지 (봇이 작업 직후 자주 제출할 수도 있음, duplicate 방지는 옵시 판정 단계서)

**Meta test**: 2026-04-17 구현 세션 자체가 내일 새벽(2026-04-18 03:40) 옵시 scan의 타겟. 이 세션이 skill-candidate로 감지되면 수치 기준 적절. 감지 실패 시 기준 재조정.

**How to apply**: 구현 이후 매일 아침 확인 — candidates 메일 pending/ 내 skill-candidate-* 패턴 검사, 판정 빈도 모니터링, 첫 주 end-to-end 관찰 후 튜닝.
