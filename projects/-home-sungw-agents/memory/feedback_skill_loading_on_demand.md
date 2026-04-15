---
name: 봇 skill은 Claude Code native discovery 기반 (.claude/skills/<name>/SKILL.md)
description: 2026-04-11 마이그레이션 완료. .claude/skills/*/SKILL.md 디렉토리 구조 + description-only context loading. 이전 INDEX.md 방식 deprecated. PROTOCOL.md §Skill Format이 canonical reference
type: feedback
originSessionId: c4b77216-718c-4631-b9fb-ec2f0d79a2d4
---
**현재 구조 (2026-04-11~):** Claude Code native skill discovery.

각 봇의 `.claude/skills/<name>/SKILL.md` — Claude Code가 시작 시 자동 스캔, `description` frontmatter만 context에 로드 (~250자/skill). 유저 요청 매칭 시 Skill tool로 본문 on-demand 로드. Body 전체가 매 세션에 주입되지 않으므로 attention dilution 없음.

**Why (2026-04-09 원칙 + 2026-04-11 진화):**
1. 원래 원칙 "희석 방지 + on-demand 로드"는 그대로 유지
2. Claude Code가 `.claude/skills/*/SKILL.md`를 native로 자동 발견 — 수동 INDEX.md 관리 불필요
3. description이 trigger 역할 — 별도 `triggers` 필드 불필요
4. 글로벌 표준(oh-my-claudecode, superpower-agents 등 주요 OSS)이 이 구조 사용

**How to apply:**
1. **새 skill 생성**: `agents/<bot>/.claude/skills/<kebab-name>/SKILL.md` (frontmatter: name + description in English)
2. **공유 skill**: `agents/common/.claude/skills/<name>/SKILL.md` 원본 + 6봇 symlink
3. **description은 영문** — LLM 매칭 품질이 곧 skill 활용도
4. **PROTOCOL.md §Skill Format**이 canonical reference — 모든 봇이 @import하므로 자동 전파
5. **이전 방식 deprecated**: `agents/<bot>/skills/*.md` + `skills/INDEX.md` + CLAUDE.md `@import` — safety net으로 잔류, 새 생성 금지

**이전 INDEX.md 방식 (deprecated, 기록용):**
- CLAUDE.md에서 `@import skills/INDEX.md`로 메타만 로드 → LLM이 Read tool로 본문 lazy load
- 수동 INDEX 관리 부담 + Claude Code native 기능 미활용이 문제

**연결:**
- PROTOCOL.md §Skill Format (canonical)
- skill-self-report SKILL.md (후보 포맷)
- skill-promotion SKILL.md (승격 절차)
