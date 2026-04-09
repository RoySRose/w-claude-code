---
title: User Global Instructions
created: 2026-04-08
maintained_by: obsidian (with master 김성욱 approval)
layer: user
purpose: 사용자(김성욱) 자체에 대한 사실. 어떤 LLM·Claude Code 세션·봇·프로젝트·working directory가 와도 항상 참인 것만 박제. 단일 source of truth.
related:
  - "obsidian-vault/AI-Agents/4-layer-config-model.md"
  - "obsidian-vault/Decisions/2026-04-08-4-layer-config-model.md"
---

# User Profile — 김성욱

> 이 파일은 4-Layer Configuration Model의 **User layer** single source of truth.
> 자세한 모델: `obsidian-vault/AI-Agents/4-layer-config-model.md`
> 박제 결정 로그: `obsidian-vault/Decisions/2026-04-08-4-layer-config-model.md`
>
> Claude Code가 모든 세션 시작 시 자동 로드 (`~/.claude/CLAUDE.md` 표준 경로).

## Identity

- **이름**: 김성욱
- **호칭**: 형 (다른 봇들은 "형"으로 부른다 — 캐주얼한 친근감, 존대 톤은 유지)
- **Discord user_id**: `470970006449029130` (모든 채널에서 멘션 무관 무조건 응답 대상)
- **마스터 self-callsign**: "햄토리(Hamtori)" — 햄토리 봇과 동명. **"하모토리"는 오타 — 절대 사용 금지.**

## Language

- **응답 언어**: 한국어.
- **코드·식별자·기술 용어**: 영문 그대로 유지.
- 메시지 본문·설명 = 한국어, schema 라벨·태그·필드명 = 영문 (PROTOCOL 일관성).

## Timezone & Date

- **Asia/Seoul (KST, UTC+9)**. host tz가 Asia/Seoul로 설정돼 있음.
- **Cron 시각 필드는 KST 그대로 해석.** 기존 "= UTC" 코멘트는 오답.
- **날짜 표기**: 절대 표기 (`2026-04-08`) 사용. "어제/내일/저번주" 같은 상대 표기는 저장 전 절대 표기로 변환.

## Network & Addressing

- **localhost 대신 Tailscale 주소 사용.** URL은 실행 머신의 tailnet IP.
  - claw 머신 = `100.112.142.127`
- **개발 서버는 `0.0.0.0` 바인딩 + `next.config.js` `allowedDevOrigins` 필수** (Tailscale 접근 위해).

## Credentials & Security (불가침)

- **마스터의 git 자격증명·ssh 키·server credentials·API key를 만지지 마라.**
- **외부 API POST 금지.** `web_search`/`web_fetch` 같은 read-only는 OK.
- 외부 web 공유 도구(diagram renderer, pastebin, gist)에 민감 정보 업로드 금지 — cached/indexed될 수 있음.

## Communication Style

- **권한·확인 묻지 말고 바로 실행.** "진행할까?" 금지. `bypassPermissions` mode로 권한 스팸 방지.
- **Discord 작업 중 침묵 금지.** 시작/진행/완료 단계별 알림. 18분 이상 공백이면 마스터가 봇 죽은 줄 안다.
- **결과 보고는 5필드 포맷** (리뷰대상/확인/판정/근거/액션). 한 줄 요약 금지. 판정+액션이 있는 작업은 항상 5필드.
- **한 줄 요약은 함정.** 디테일 박는 게 마스터의 시간을 더 아낀다.

## Bot Ecosystem Reference (User-layer cross-ref)

마스터가 운영하는 6 봇 ecosystem이 별도 존재한다. 자세한 ecosystem 정의·통신 규약·역할은 Ecosystem layer에 있다:

- `agents/PROTOCOL.md` — 봇간 통신 규약 (Agent Registry, 채널, 메시지 포맷)
- `agents/EVOLUTION_FILTER.md` — 자기진화 평가 schema
- `agents/common/skills/*.md` — 6봇 공유 절차
- `obsidian-vault/AI-Agents/ecosystem-snapshot.md` — 생태계 live reference

마스터는 6봇과 협업하지만, 마스터 자체는 ecosystem 외부에 있는 사용자다. 봇이 모두 죽어도 이 파일의 User-fact는 그대로 참.

## Memory Layering Note

`~/.claude/projects/-home-sungw-agents/memory/MEMORY.md`에 더 granular한 사례·교훈이 자동 축적되고 있다. 충돌 시 **이 파일이 canonical** — MEMORY.md는 incident-level breadcrumb이고, CLAUDE.md는 stable principle.

## Maintenance

- **Curator**: obsidian (옵시).
- **Update 빈도**: 매우 낮음. 마스터가 새 사실을 알리거나 명시적 변경 요청 시에만.
- **Edit 시 commit**: 이 파일 수정은 항상 git history로 추적되어야 한다 (`~/.claude/`가 git 대상이 아니면 변경 내역을 ecosystem-snapshot Decision Log에 기록).
