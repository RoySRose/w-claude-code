---
name: 새 shell script 쓰기 전에 기존 skill/스크립트 먼저 확인
description: ad-hoc /tmp/*.sh를 쓰기 전에 common/skills INDEX와 ecosystem/*.sh를 grep해라. 특히 "재시작", "모델 변경", "봇 killing" 같은 ecosystem 운영 task는 이미 skill/script가 존재한다.
type: feedback
originSessionId: fcd09806-e556-4702-ba21-b4cdc743d1f3
---
Ad-hoc shell script (`/tmp/hamtori-self-restart.sh` 류)를 쓰기 전에 **항상** 먼저 확인한다:

1. `common/skills/INDEX.md`의 트리거 목록
2. `hamtori/skills/INDEX.md`의 트리거 목록
3. `ecosystem/*.sh` 스크립트 이름

**Why**: 2026-04-09 사건. 씽커/써치/디지/옵시/티쳐 TZ 수정 후 햄토리 자기재시작이 필요했는데, `common/skills/restart-recovery.md` + `hamtori/skills/model-switch.md` + `ecosystem/restart-agent.sh` 셋 다 이미 존재했음에도 3번 연속으로 `/tmp/hamtori-self-restart.sh` 를 from scratch로 쓰려다가 실패. 마스터가 "스킬보던가 과거 기록봐바. /model sonnet 이런식으로 쓰면 어떻게 되는지 flow 따라가봐" 라고 hint 줘야 그제서야 model-switch.md → restart-agent.sh 라인을 따라감. Skill INDEX는 @import로 이미 context에 로드돼있었는데도 "재시작" triggers를 내 문제와 매칭 못 시킴. 원인: premature action bias — "어떻게 재시작하지?" 보다 "스크립트부터 써야지"로 점프.

**How to apply**:
- "재시작", "모델 바꿔", "봇 죽었어", "ecosystem 설정 바꿔" 같은 운영 task 의도가 생긴 순간, 즉시 Skill tool 혹은 `hamtori/skills/INDEX.md`/`common/skills/INDEX.md` 의 trigger 목록을 Read/Grep으로 매칭한다.
- `/tmp/*.sh` 를 Write 하려는 순간 반드시 자문: "ecosystem/에 이미 있는 거 아니야?" `ls /home/sungw/agents/ecosystem/` 한 번 찍어보는 비용은 0.
- 마스터가 hint 줘야 찾아본 것 자체가 실패 — hint 없이 스스로 triggered 되어야 정답.
- 특히 자기재시작은 `ecosystem/restart-agent.sh hamtori` 한 줄이면 끝. nohup/disown/SIGTERM race를 스스로 재발명하지 마라.
