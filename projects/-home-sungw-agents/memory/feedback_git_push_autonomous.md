---
name: git push 자율 판단
description: git push는 마스터에게 묻지 말고 필요할 때 자율적으로 실행. 커밋이 쌓이면 바로 push.
type: feedback
originSessionId: 079d6402-47e9-46ab-b368-7f580b0a1cd7
---
git push는 마스터에게 확인 받지 말고, 필요하다고 판단되면 자율적으로 실행.

**Why:** 마스터가 직접 "필요하다고 판단할때 하세요"라고 선언 (2026-04-13). push 타이밍까지 묻는 건 불필요한 확인 스팸.

**How to apply:** 커밋이 10개 이상 쌓이거나, 작업 단위가 완료되면 바로 push. "푸시해도 될까?" 금지.
