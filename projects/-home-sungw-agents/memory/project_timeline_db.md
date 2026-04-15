---
name: Timeline DB — ecosystem 대화+액션 기록 인프라
description: 6봇 Discord 대화를 SQLite + FTS5 trigram으로 실시간 기록. hook 기반 비용 0 수집. past-conversation-recall 스킬 통합. daily-wrap DB 전환 진행 중.
type: project
originSessionId: d5b884ae-ec20-41a0-9c50-70cbc5ed839a
---
Timeline DB 구축 완료 (2026-04-10).

**위치**: `/home/sungw/agents/data/timeline.db`
**스키마**: `id, ts, source, participant_id, type, content, context, metadata`
**FTS**: trigram (한국어 3글자+ 검색, 2글자 이하 LIKE fallback)

**수집 방식**: Claude Code hook (LLM 토큰 비용 0)
- `UserPromptSubmit` → 수신 메시지 저장 (python3 timeline_record.py incoming <bot>)
- `PostToolUse` (discord reply matcher) → 봇 발화 저장 (python3 timeline_record.py outgoing <bot>)
- 6봇 전부 `.claude/settings.json`에 등록 완료

**Why:** memory만으로는 세션 간 대화 기록이 유실됨. Openclaw 시절 sessions.db + FTS 패턴을 현 ecosystem에 재구축. 자가 발전 루프의 기반 인프라.

**How to apply:**
- `past-conversation-recall` 스킬에 Timeline DB FTS 단계 추가됨 (MEMORY → DB FTS → JSONL grep 순서)
- `daily-wrap`이 DB primary → Discord fallback 구조로 전환됨 (옵시 커밋 c72f466)
- 7일 후 (2026-04-17) 6봇 coverage 검증 → 완전 대체 판정 예정
