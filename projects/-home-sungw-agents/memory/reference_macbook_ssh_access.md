---
name: MacBook SSH 접근 정보
description: claw → MacBook SSH 접속 방법. 유저네임 RoyKim, Tailscale IP 100.98.222.23, id_rsa 키 사용.
type: reference
originSessionId: 079d6402-47e9-46ab-b368-7f580b0a1cd7
---
claw → MacBook SSH 접속:
```bash
ssh -i ~/.ssh/id_rsa RoyKim@100.98.222.23
```

- Tailscale IP: `100.98.222.23` (macbook-pro-3)
- 유저네임: `RoyKim` (매번 까먹지 말 것!)
- 키: `~/.ssh/id_rsa`
- macOS 홈: `/Users/RoyKim/`
- agents repo: `/Users/RoyKim/agents/`
- .claude: `/Users/RoyKim/.claude/`
