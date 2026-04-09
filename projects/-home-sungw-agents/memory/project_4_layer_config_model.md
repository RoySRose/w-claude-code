---
name: 4-Layer Configuration Model 채택 (User/Ecosystem/Bot/Project)
description: 2026-04-08 마스터와 합의한 ecosystem 설정 layer 분류 + decision rubric. 새 artifact 위치 결정 시 항상 이 모델을 따른다.
type: project
---

# 4-Layer Configuration Model

2026-04-08 마스터(김성욱)와 obsidian이 합의한 ecosystem 설정 분류 모델.

## The 4 Layers
1. **User** — 사용자 자체 사실 (호칭/한국어/KST/자격증명). 모든 LLM·봇·프로젝트가 와도 참.
2. **Ecosystem** — 6 봇이 공유하는 절차·schema·금지룰 (PROTOCOL, EVOLUTION_FILTER, common/skills, hooks, never-do).
3. **Bot** — 특정 봇 정체성·역할·채널 (IDENTITY/SOUL, 채널 ID, bot-specific skills).
4. **Project** — 특정 작업 도메인 (obsidian-vault, OpenClaw, AClassI 등). 봇과 무관, 다른 LLM이 와도 동일.

## Decision Rubric (4단 분기)
1. 새 봇 추가/삭제해도 X가 그대로 의미 있는가? → No=**Bot**, Yes=다음
2. 특정 working dir 안에서만 의미 있는가? → Yes=**Project**, No=다음
3. 6 봇 중 2개+ 독립 도출 또는 명백히 generic? → Yes=**Ecosystem**, No=Bot 회귀
4. 봇 이전에 사용자 사실? 다른 LLM도 봐도 참? → Yes=**User**

## 핵심 원칙
**"바뀌면 누가 영향받나?"가 유일한 기준.** "어디 두면 편한가"는 함정.

## Layer ≠ Location
물리 위치와 의미 layer가 어긋날 수 있음. 그럴 때 frontmatter `layer:` 필드로 명시.

**Why:** 2026-04-08 G2 (global skill tier 부재) 해결 후 마스터가 layer 분류 기준을 물어옴. 이전까진 ad-hoc 결정이라 같은 갈등 반복. 4-layer 박제하면 새 artifact 위치 결정 시 grep 한 번으로 끝.

**How to apply:** 새 skill/rule/문서/cron task 만들 때 무조건 4단 rubric 거치고, 결과를 frontmatter `layer:` 필드로 명시. 위치가 의미와 어긋나면 그 어긋남도 명시. 본문 [[4-layer-config-model]] (vault) 와 [[2026-04-08-4-layer-config-model]] (decision log) 참조.
