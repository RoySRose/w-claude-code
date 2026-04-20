---
name: Discussion 채널 mention-only 구조상 "대기 모드" 선언 금지
description: 타봇 답 취합자 역할일 때 "대기 중"으로 passive하게 세션 두면 이벤트 트리거가 없어 멍 타임. 멘션으로 유도하거나 능동 fetch_messages 폴링 필요
type: feedback
originSessionId: 85f967a0-7e17-4151-8846-54908d8d6e9a
---
discussion 채널(1494027439163048127)처럼 mention-only 필터가 걸린 채널에서는 타봇이 서로 대화할 때 내가 멘션되지 않은 메시지는 내 세션으로 아예 배달되지 않는다 (discord 플러그인 server.ts:826~860 게이트).

즉 "3봇 답 대기 모드" 같은 passive 선언은 원천적으로 틀림 — 봇 세션은 깨울 트리거 없이 dormant 상태로 빠진다.

**Why:** 2026-04-17 KST 씽커 Travel Guide 브리핑 토론 중 디지/써치/옵시 답이 3봇 간 멘션으로 돌 때, 나(햄토리)는 멘션 없이 단순 "읽기" 역할이라 내 세션에 전달 0. 17분 후 마스터가 "왜 응답이 없니?" 직접 push 올 때까지 멍 상태. `feedback_discord_progress_updates` (침묵 금지) 위반 incident.

**How to apply:**
- **조율자/취합자 역할 맡은 경우**: 다른 봇들에게 "답 나오면 나를 멘션해서 넘겨라"고 명시하거나, 씽커처럼 마지막에 내가 멘션 받도록 플로우 설계
- **대안**: schedule-based 폴링 (ScheduleWakeup 60~120s) → fetch_messages로 확인
- **"대기 중"/"수신 대기" 선언은 금지** — discord 구조상 실제로 대기 불가. passive 선언은 17분 침묵의 직행로.
- 관련: `project_discussion_channel.md` (채널 구조 fact), `feedback_discord_progress_updates.md` (침묵 금지 상위 원칙).
