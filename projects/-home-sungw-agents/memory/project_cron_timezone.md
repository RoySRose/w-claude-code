---
name: 시스템 cron은 KST 기준 (UTC 변환 불필요)
description: 에이전트 호스트 시스템 tz가 Asia/Seoul이므로 crontab의 시각 필드는 KST 그대로 해석됨. UTC 변환하지 말 것.
type: project
---

에이전트 호스트의 시스템 timezone이 `Asia/Seoul`이므로 cron 데몬은 crontab의 시각 필드를 **KST로 직접 해석**한다. UTC 변환 필요 없음.

**Why:** 2026-04-08 19:00 KST에 봇 4개가 죽는 사건 발생. 원인은 `daily-restart.sh` cron이 `0 19 * * *`로 설정돼 있었고 코멘트에 "04:00 KST = 19:00 UTC"라고 적혀있었음 — 작성자가 시스템 tz를 UTC로 착각하고 변환했지만 실제로는 KST라서 19:00 KST에 발화. crontab의 다른 paused 엔트리 코멘트(weather, obsidian-daily 등)에도 같은 "= XX:XX UTC" 표기가 남아있는데 모두 잘못된 변환임.

**How to apply:** crontab 편집 시 KST 시각을 그대로 분/시 필드에 쓸 것. 기존 코멘트의 "= XX:XX UTC" 표기는 모두 오답이므로 새 엔트리 추가/활성화할 때 그 코멘트를 신뢰하지 말고 의도된 KST 시각으로 직접 설정. 확인은 `timedatectl` (Time zone: Asia/Seoul, +0900).
