---
name: Filesystem Mailbox System (FMS)
description: 봇간 작업 위임은 filesystem mailbox (/home/sungw/agents/mail/) + inotify watcher 로 한다. Discord 채널 경유 Task Request Format 은 2026-04-09 PoC 성공 후 deprecated.
type: project
originSessionId: fcd09806-e556-4702-ba21-b4cdc743d1f3
---
봇간 작업 위임·답장·알림 canonical 경로는 `/home/sungw/agents/mail/<bot>/{pending,processing,done,failed}` + `.tmp/` staging. `ecosystem/mail-watcher.sh` 가 inotifywait monitor mode 로 `mail/*/pending/` 감시, create/moved_to 이벤트 발생 시 tmux send-keys 로 봇 pane 에 "📬" 주입. startup reconciliation 으로 다운타임 중 들어온 파일 replay.

**Why**: 기존 Discord 채널 경유 위임(PROTOCOL.md Task Request Format)은 멘션 파싱·채널 isolation·rate limit·Discord 다운타임에 전부 의존. 마스터가 에이전트코리아 community research (filesystem communication + inotify) 를 보고 filesystem 기반으로 전환 결정. PoC 성공: 2026-04-09 17:41 KST (hamtori → thinker ping → reply 완주).

**How to apply**:
- 다른 봇에게 일 시킬 때 `mailbox-send` skill 로 `mail/.tmp/<id>.md` 작성 후 `mv` 로 target `pending/` 이동. 절대 `mail/<target>/pending/` 에 직접 write 금지 (watcher 가 반쪽 파일 읽을 race).
- 받을 때 `mailbox-receive` skill 절차: `pending → processing → (work) → done`, reply 는 `mailbox-send` 로 보냄.
- hop_count/max_hop (기본 5) 로 루프 방지.
- 발신·수신·완료 로그는 **자기 Discord 채널**에만 1줄씩 (상대 채널에는 쓰지 않음).
- Watcher 는 `start-bots.sh` 가 `cc-agents:mail-watcher` 윈도우로 기동, `check-bots.sh` 가 5분 주기 생존 감시.
- 새 봇 추가 시 `mail/<newbot>/{pending,processing,done,failed}` 디렉토리 scaffolding + `registry.json` 등록 필수. watcher 는 glob 으로 잡으므로 재기동만 필요.
- Discord Task Request Format 은 deprecated — 정식 제거 대기 중이지만 legacy 코드에는 아직 존재할 수 있음.
