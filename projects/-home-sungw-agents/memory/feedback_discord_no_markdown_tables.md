---
name: Discord 봇 메시지에 markdown table 금지 — 볼드-불릿 또는 코드블록 사용
description: 2026-04-20 마스터 지적 — Discord 가 markdown table rendering 을 지원 안 하므로 파이프 문자(|)가 그대로 박제돼서 보기 너무 불편함. 봇→마스터 Discord 메시지에서 `| 항목 | 값 |` 형식 전면 금지. default = 볼드 라벨 불릿, 숫자/컬럼 정렬 필수일 때만 코드블록 ASCII 테이블.
type: feedback
originSessionId: 9b5d5762-49be-4809-9681-13bf4d17c1e9
---
# Discord 봇 메시지에 markdown table 금지

봇→마스터 Discord 메시지에서 `| 헤더 | 헤더 | ... |\n|---|---|` 형식의 markdown table 전면 금지. Discord 클라이언트(웹·데스크톱·모바일 전부)가 markdown table syntax rendering 을 지원하지 않아서 파이프 문자·대시가 그대로 표시됨. 마스터는 table 내용을 literal 파이프 dump 로 보게 됨.

## Why

**2026-04-20 01:54 KST 마스터 원문 지적**:
> "너희들이 아래 처럼 주면. 나는 정말 그냥 저대로 보여.... 디스코드에서 테이블로 보이지가 않아서 보기가 너무 불편해. 이거 해소할 방법 업성?"

원문 예시: `| 항목 | 현재 | 영향 |\n|---|---|---|\n| git 지시문 + status snapshot | 주입 중 (default) | 매 세션 ...` — 마스터는 이 5줄 전부를 파이프 섞인 plain text 로 봤음.

Discord 는 GitHub flavored markdown 의 부분집합만 지원: bold/italic/strike/code/blockquote/headers(일부)/lists. **Tables 제외** (공식 미지원, 2026년 현재까지 변동 없음).

## How to apply (ecosystem-wide)

### 기본값 (모든 봇): 볼드 라벨 불릿
- `- **항목 A** — 현재 값. 영향 설명 한 줄`
- 모바일·데스크톱 둘 다 잘 렌더링
- portable, universally readable
- 항목수 5~10 개까지 적합

### 컬럼 정렬이 진짜 필요한 경우: 코드블록 ASCII 테이블
triple-backtick fenced code block 안에 공백 정렬한 ASCII table. 주의: 너비 넓으면 모바일 줄바꿈 발생. 컬럼 3개 이내 + 각 값 ~15자 이내 권장. 수치 표·diff 표시·시간별 요약 등 **정렬이 의미 전달에 필수일 때만**.

### 아주 짧은 항목: `필드: 값` 라인
- `git 지시문: 주입 중 / status 수십 줄 누적 큼`
- `CLAUDE.md: 합성 중 / @import 체인 풀로딩`
- 한 줄당 완결. 2~3 항목이면 이 형식이 가장 compact.

## 적용 범위

- 모든 봇 (obsidian/hamtori/thinker/researcher/designer/teacher/chokie) → 마스터 Discord reply
- `mcp__plugin_discord_discord__reply` / `edit_message` 본문
- 5필드 보고 포맷(`리뷰대상/확인/판정/근거/액션`) 내부 서브 표시에도 적용

## 예외 (markdown table 사용 OK)

- vault 내부 `obsidian-vault/**/*.md` 파일 — Obsidian 은 markdown table 잘 렌더링
- FMS mail body (`mail/**/*.md`) — table 로 정보 조밀도 올리는 경우 많고 LLM 읽기 용도
- git commit message / README — GitHub 렌더링 OK
- 오직 **Discord chat message 본문만** 금지

## 관련 박제

- ecosystem 전파: `agents/PROTOCOL.md` Reporting Conventions 섹션에 한 줄 박제 (모든 봇 참조)
- 개별 봇 CLAUDE.md 에 재박제 불필요 — PROTOCOL.md @import 체인으로 자동 전파
