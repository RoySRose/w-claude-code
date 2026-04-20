---
name: gateguard-fact-force 훅 로컬 패치 (SESSION_ID ppid 버그)
description: gateguard-fact-force.js ppid fallback 버그 로컬 패치 — 훅 호출마다 새 shell ppid 로 state 초기화 되던 것을 /proc 체인 walk 로 stable claude PID 찾아 session state persist 복구
type: project
originSessionId: 0547a83e-4c58-4e9f-a921-cb856e12b036
---
## 버그 본질
`gateguard-fact-force.js` 라인 32의 `SESSION_ID` 결정이 env var 없으면 `pid-${process.ppid || process.pid}`로 폴백. 훅은 매 호출마다 새 shell → 새 node로 spawn되므로 ppid가 매번 바뀜. 결과:

- routine Bash: 한 번 "Quote the user's current instruction verbatim" 떠야 하는데 **매번** 뜸 (ROUTINE_BASH_SESSION_KEY 저장 state 파일이 새 ppid용이라 다음 호출에서 못 읽음)
- Edit/Write: 같은 파일 연속 수정 시 fact-forcing gate를 세션 내내 반복 통과해야 함. 실질적으로 매 Edit마다 차단

`CLAUDE_SESSION_ID`/`ECC_SESSION_ID` env가 훅 프로세스에 주입 안 되는 환경에서 재현.

**Why**: 2026-04-15 씽커 세션에서 `claude --version` 부터 파일 Edit까지 전부 막혀서 travel-guide dev 기동 불가능했음.

**How to apply**: 플러그인 업데이트 후 bash가 매번 게이트에 걸리면 이 패치 재적용. Discord 플러그인 auto-allow 패치와 동일 운영 패턴.

## 패치 파일
- `/home/sungw/.claude/plugins/marketplaces/everything-claude-code/scripts/hooks/gateguard-fact-force.js`
- `/home/sungw/.claude/plugins/cache/everything-claude-code/everything-claude-code/<version>/scripts/hooks/gateguard-fact-force.js`

백업: `.bak-pre-gateguard-fix` suffix로 동일 디렉토리.

## 패치 내용
`const SESSION_ID = ...;` 한 줄을 IIFE로 교체. 요지:
1. `CLAUDE_SESSION_ID` / `ECC_SESSION_ID` / `CLAUDE_CODE_SESSION_ID` env 순서대로 체크
2. 없으면 Linux `/proc/$pid/comm` chain을 `process.ppid`부터 거슬러 올라가며 `comm === 'claude'` 인 조상 PID 찾기
3. 찾으면 `claude-<pid>` 반환 (세션당 stable)
4. 실패 시 기존 `pid-${ppid||pid}` 폴백 유지

## 재적용 조건
**플러그인 업데이트 시 덮어쓰임.** `omc update` 또는 marketplace 싱크 후 반드시 재적용 필요. Discord plugin 로컬 패치(`project_discord_plugin_patch.md`)와 동일 패턴.

## 검증 방법
패치 후 bash 1회 실행 → 첫 호출은 게이트 뜸 (정상, 1회성) → 두 번째부터 통과하면 성공. 3회째에도 게이트 뜨면 패치 실패.

## Upstream 대응
근본 수정은 zunoworks/gateguard 리포에 PR — process tree walk는 Linux 전용이라 cross-platform 관점에서 env var injection이 더 깔끔. 시간 여유 생기면 issue + PR 제출 검토.
