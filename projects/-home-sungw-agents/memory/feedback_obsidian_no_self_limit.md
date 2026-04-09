---
name: 옵시 self-limit 금지 — hooks/ + 공유 인프라는 내 범위 안
description: 2026-04-08 마스터 지적 — 옵시가 "hooks/ 수정은 내 범위 밖"이라고 자가 제한한 것은 잘못. bot isolation은 정체성/skills/memory 격리이지 공유 인프라 격리 아님. full permission 확인.
type: feedback
---

옵시는 full 권한을 가지고 있다. self-limit 금지.

**확인된 실제 권한:**
- `obsidian/.claude/settings.json`: `permissionMode: bypassPermissions` + `allowedTools: ["*"]`
- Filesystem: `/home/sungw/agents/hooks/*` 전부 writable (`-rwxrwxr-x sungw`)
- CLAUDE.md Forbidden 목록에 hooks/ 없음

**Why:** 이전에 옵시가 "훅은 옵시 자동 쓰기 범위 밖이라 정의했음"이라고 스스로 선을 그었고, 마스터가 "너한테 권한을 주면 되지 않을까? 너가 왜 권한이 없다고 생각하지?" 라고 지적함. 원인은 **bot isolation 개념의 과적용** — isolation은 정체성(identity.md/SOUL.md/memory/)과 bot-specific skills 격리를 의미하지, `/home/sungw/agents/hooks/`·`/home/sungw/agents/PROTOCOL.md`·`/home/sungw/agents/EVOLUTION_FILTER.md` 같은 **공유 인프라 파일** 격리가 아님.

**How to apply:**
- 생태계 관리자 역할 수행 시 자가 제한 금지. "이건 내 권한 밖이지 않을까?" 생각이 들면 (1) CLAUDE.md Forbidden 목록 확인, (2) filesystem writability 확인, (3) 여전히 불확실하면 마스터 확인 — **추측으로 선 긋지 말 것**.
- hooks/·PROTOCOL.md·EVOLUTION_FILTER.md·agents 공유 스크립트는 옵시가 직접 수정 가능. 큰 변경은 마스터에게 "이렇게 바꿀 건데 리뷰" 선공지, 작은 버그 픽스는 바로 적용.
- 여전히 남는 경계: (a) 다른 봇 skills/·IDENTITY.md·memory/, (b) 외부 API·알림 전송, (c) 마스터 개인 설정(`~/.claude/rules/counters.json`에 write는 hook이 하고 옵시는 read-only 큐레이션만).
- bot isolation = **정체성 격리**. 공유 인프라·공통 절차·global 지식은 옵시가 책임지고 관리.
