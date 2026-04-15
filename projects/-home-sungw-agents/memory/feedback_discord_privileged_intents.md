---
name: Discord 새 봇 Privileged Gateway Intents 필수
description: 새 Discord 봇 추가 시 Developer Portal에서 MESSAGE CONTENT INTENT 등 Privileged Gateway Intents를 반드시 활성화해야 함
type: feedback
originSessionId: 079d6402-47e9-46ab-b368-7f580b0a1cd7
---
새 Discord 봇을 만들 때 Developer Portal → Bot → Privileged Gateway Intents에서 다음을 반드시 켜야 한다:
- PRESENCE INTENT
- SERVER MEMBERS INTENT
- **MESSAGE CONTENT INTENT** (핵심)

**Why:** 초키봇(theo) 첫 세팅 때 이 설정을 빠뜨려서 `discord channel: login failed: Error: Used disallowed intents`로 bun 프로세스가 즉시 exit code 1로 죽었다. Claude Code는 MCP 서버 실패를 "plugin:discord:discord · ✘ failed"로만 표시하고 에러 메시지를 숨기므로, strace로 `write()` syscall을 캡처해서야 원인을 찾았다.

**How to apply:** add-new-bot skill 절차에 Developer Portal intent 설정 단계를 추가. 봇이 Discord에 연결 안 되면 제일 먼저 intent 설정을 의심할 것.
