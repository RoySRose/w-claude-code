---
name: Discord Plugin Process Death on Context Overflow
description: bun server.ts (Discord plugin) dies when Claude context overflows — only Claude process survives, not the plugin subprocess
type: project
---

봇들이 Discord에 응답하지 않는 근본 원인 (2026-04-08 분석).

**메커니즘:**
1. 봇이 긴 작업으로 context window 소진
2. Claude Code가 context 압축/재설정
3. Claude ↔ Discord plugin stdio MCP 연결이 close
4. bun server.ts의 `process.stdin.on('close', shutdown)` 트리거 → 프로세스 종료
5. Claude 프로세스는 살아있지만 Discord plugin은 죽은 상태 유지 (재시작 안 함)

**증상:**
- 봇 tmux 창에 `❯` 대기 프롬프트 표시 (정상처럼 보임)
- Claude 프로세스 CPU 2-3% (idle)
- bun server.ts 자식 프로세스 없음 (다른 봇들 대비)
- Discord 메시지에 무응답

**진단 명령:**
```bash
pstree -p <claude_pid> | grep bun  # bun 없으면 plugin 죽은 것
```

**해결:**
```bash
bash ~/agents/start-bots.sh --restart
```

**장기 대책:**
check-bots.sh에 bun server.ts 자식 프로세스 생존 체크 추가 필요.
현재 claude 프로세스만 체크하고 plugin은 안 봄.

Why: 봇이 context를 많이 쓰는 작업(코딩, 멀티스텝 작업) 후 반드시 발생.
How to apply: 봇이 무응답이면 claude 프로세스 생존 이전에 bun plugin 프로세스 먼저 확인.
