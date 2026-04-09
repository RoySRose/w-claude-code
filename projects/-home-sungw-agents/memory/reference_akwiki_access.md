---
name: 에이전트코리아 지식위키(akwiki.org) 접근 방법
description: akwiki.org/wiki 는 Next.js SPA + 일일 4자리 비밀번호 게이트. POST /api/auth 로 JSON 인증 후 24h 쿠키 사용.
type: reference
originSessionId: 495405cb-e087-4fc8-a7f3-5d99146f26b0
---
**URL**: `https://akwiki.org/wiki`

**성격**: 에이전트코리아 커뮤니티 운영 지식위키 (2026-04 기준 238+편). Claude Code/Codex/Gemini CLI 실전 패턴, Hue meta-agent, Building Effective Agents 7 패턴, Skills 2.0, Hermes Agent, 자기진화 하네스 등 한국어 1차 자료로서 가치가 높음.

**인증 방식**:
1. Next.js SPA 라 `WebFetch` 로는 로그인 페이지만 반환됨 (client-side rendering). 반드시 `Bash curl` 로 REST 직접 호출.
2. 매일 4자리 비밀번호가 발급됨 — 마스터가 세션 시작 시 알려줌 ("오늘 비밀번호는 XXXX 야"). 저장 금지(일회성).
3. POST `/api/auth` with header `Content-Type: application/json`, body `{"password":"XXXX"}` — **필드명은 `password` (not `code`, `pin`, `wikiPassword`)**.
4. 성공 시 200 OK + `Set-Cookie: ak-wiki-auth=<token>; Max-Age=86400; HttpOnly`. 이 쿠키를 24h 재사용 가능.
5. 이후 모든 `/wiki`, `/wiki/<slug>` 요청에 `-b "ak-wiki-auth=<token>"` 로 쿠키 붙여서 curl.

**실전 recipe** (2026-04-09 검증):
```bash
# 1. 인증
TOKEN=$(curl -s -i -X POST https://akwiki.org/api/auth \
  -H 'Content-Type: application/json' \
  -d '{"password":"1784"}' \
  | grep -i 'set-cookie' | sed -E 's/.*ak-wiki-auth=([^;]+).*/\1/')

# 2. 인덱스 페이지
curl -s -b "ak-wiki-auth=$TOKEN" https://akwiki.org/wiki > /tmp/akwiki.html

# 3. 상세 페이지 (slug는 index HTML의 a[href] 파싱)
curl -s -b "ak-wiki-auth=$TOKEN" https://akwiki.org/wiki/<slug> > /tmp/akwiki-<slug>.html
```

**Content 추출**: 페이지 당 ~880KB HTML (Next.js hydration payload 포함). article 본문은 1-5KB. Python `re.sub` 로 `<script>`/`<style>`/기타 태그 제거하면 본문 추출 가능. `<article>` 태그 또는 `main[role=main]` selector 있음.

**Why:** 2026-04-09 1차 리서치에서 akwiki 접근 실패(WebFetch SPA 한계)로 건너뛰었다가, 마스터가 "이거 너가 접근해서 찾아봐" 재지시. `/api/auth` 엔드포인트 존재를 GET 405 응답으로 확인 → JSON POST 성공. 공식 Claude Code Channels MCP 패턴을 여기서 처음 발견 (우리 Discord plugin과 구조 일치 혁신 insight).

**How to apply:**
- 마스터가 "akwiki" / "에이전트코리아" / "akwiki.org" 언급하거나 Claude Code 관련 한국어 자료 조사 필요 시
- 일일 비밀번호는 매 세션 새로 받아야 함 — 전날 비밀번호 재사용 금지
- WebFetch 는 무조건 실패 → 처음부터 `Bash curl` 로 가기
- 인증 토큰은 메모리·vault 에 저장 금지 (24h 만료 일회성, 저장하면 dead token이 됨)
- 대량 크롤 시 rate limit 주의 — 커뮤니티 사이트라 일일 8-10편 이하로 제한
