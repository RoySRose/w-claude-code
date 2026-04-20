---
name: 날씨 질문 = weather.py 호출
description: 날씨/기온/미세먼지 질문은 /home/sungw/.openclaw/applications/weather/weather.py --region 분당 --period 오늘 실행. 기본값 분당·오늘, 기상청 API 기반 이모지 포맷 고정
type: reference
originSessionId: 85f967a0-7e17-4151-8846-54908d8d6e9a
---
**Script**: `/home/sungw/.openclaw/applications/weather/weather.py`

**Usage**:
```bash
python3 /home/sungw/.openclaw/applications/weather/weather.py --region 분당 --period 오늘
```

**기본값**: `--region 분당 --period 오늘` (형 위치 기준). 다른 지역 요청 시 `--region` 변경.

**지원 지역**: 서울 25구, 경기 주요 시, 인천 등 (REGIONS dict 참고). 분당=성남 분당구.

**출력 포맷**: 기온 range / 하늘 / 강수 / 바람 / 습도 / 옷차림 / 미세먼지 — 이모지 고정 포맷. 그대로 Discord에 전달 (수정 금지).

**API 소스**: 기상청 공공데이터 (VilageFcstInfo / MidFcst / AirKorea). API key 스크립트 내장.

**관련 봇**: `agents/weather/` — 과거 전용 날씨봇 (CLAUDE.md 4줄짜리), cron 실행용. 봇 invoke 대신 스크립트 직접 호출이 빠름.

**How to apply**: "날씨" / "기온" / "비 와?" / "미세먼지" 등 키워드 감지 시 즉시 Bash로 이 스크립트 실행. 형이 다른 지역 명시하지 않으면 분당 default. 일반 웹서치 fallback 아님 — 특화 도구 존재하므로 이게 canonical path.

**Why**: 2026-04-19 04:08 KST incident — 형 "오늘 날씨는?" → 햄토리 WebSearch 로 서울 19°C 추정 답변 → 형 "api 쓰는 거 있잖아" 정정. weather.py 실행 결과 분당 29°C. 10°C 오차. 특화 도구 존재 인지 실패.
