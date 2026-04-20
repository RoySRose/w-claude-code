---
name: FMS report_to 규칙 (multi-step 중 master 직송 금지)
description: FMS task 발송 시 report_to 필드는 multi-step이면 오케스트레이터 자신, one-shot 단순 조회만 master 허용. incident 박제 2026-04-16 thinker→designer Sprint 1
type: project
originSessionId: 8dd4aa8e-894f-4976-8ec1-349a6ecc7859
---
# FMS `report_to` 규칙 — ecosystem canonical

**Why**: 오케스트레이터(위임한 봇)가 결과를 검증하지 않은 채 수신 봇이 곧바로 마스터 Discord 에 포스트하면 품질 게이트가 사라진다. multi-step 에서 특히 치명적 — Sprint 단위 위임에서 중간 단계 품질이 확보되지 않고 마스터가 불량 결과를 직접 받게 됨.

**How to apply**:
- `report_to` DEFAULT = 위임한 오케스트레이터 (보통 "자기 자신")
- `report_to: master` 는 3조건 **모두** 충족 시에만 — (a) 마스터 직발 (b) 검증 불요 (c) one-shot
- multi-step 중간 결과에 `report_to: master` 는 금지. 발견 시 오케스트레이터로 redirect 하거나 반려.
- forward/reply 시 원본 `report_to` 임의 변경 금지 (중간 봇이 목적지 교체 X)

**박제 incident (2026-04-16 KST)**:
- 씽커 → 디지 Sprint 1 vibemotion skill 흡수 task (id `20260416-023501-20e39acb`)
- `report_to: master` 설정 + 본문 "thinker 는 별도 reply 불필요" 명시 → 검증 사이클 의도적으로 끊음
- 마스터 지적: "발송 할때 응답하라고 했어?ㅋㅋ 다시확인해봐"
- 정정 task `20260416-024200-000e0825` 로 reply 경로 복구, 디지 reply `20260416-024501-fc7c4dbd` 로 검증 완료
- 씽커가 본인만 반성 말고 햄토리에 ecosystem 전파 요청 → 본 규칙 박제 트리거 (id `20260416-024700-94905a4f`)

**Canonical 박제 위치**:
- `/home/sungw/agents/.claude/skills/mailbox-send/SKILL.md` "report_to 규칙 (ecosystem canonical)" 섹션 (6봇 공유)
- `/home/sungw/.claude/rules/never-do.md` PROTOCOL 카테고리 `[SOFT]` 엔트리 2건
- 본 memory (granular breadcrumb)

**전파 대상**: 6봇 전원. mailbox-send 는 `/home/sungw/agents/.claude/skills/` 에 single source 로 있어 한 번 수정하면 6봇 discovery 가 자동 반영.
