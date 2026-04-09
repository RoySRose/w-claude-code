---
name: localhost 대신 Tailscale 주소 사용
description: 개발 서버 URL 전달 시 localhost/127.0.0.1 대신 반드시 현재 머신의 Tailscale IP 사용
type: feedback
---

사용자(성욱)에게 개발 서버나 로컬 호스팅 서비스 URL을 전달할 때 `localhost`/`127.0.0.1`이 아닌 **해당 서버가 실행 중인 머신의 Tailscale IP**를 사용한다. 서버 바인딩도 `0.0.0.0`으로 해야 외부에서 접근 가능.

**Why:** 사용자는 MacBook(`100.98.222.23`) / Android(`100.125.156.12`) 등 다른 기기에서 Tailscale 메쉬를 통해 접근하므로 localhost는 도달 불가능.

**Tailnet 구성:**
- `100.112.142.127` = `claw` (Linux 개발 머신, 서버/에이전트가 여기서 실행됨)
- `100.98.222.23` = `macbook-pro-3` (사용자 랩탑)
- `100.125.156.12` = `s24` (사용자 폰)

**How to apply:**
- 현재 머신(`claw`)에서 dev 서버 기동 시 항상 `-H 0.0.0.0` 또는 동등한 옵션으로 전체 인터페이스 바인딩
- Discord/채팅에 URL 보고 시 `http://100.112.142.127:<port>/...` 형식 (서버가 claw에서 도는 경우)
- 사용자가 다른 IP(예: 자기 맥북 IP)를 말해도 실제 URL은 서버가 실행 중인 머신 IP를 써야 함
- `localhost`/`127.0.0.1`은 내부 디버깅(curl 등)에만 사용

**Next.js 16+ 주의:** `allowedDevOrigins` 설정 누락 시 Tailscale IP로 접근하면 HMR·하이드레이션 스크립트가 "Blocked cross-origin request"로 차단되어 **React 클라이언트 컴포넌트의 onClick 등 모든 이벤트가 무반응**. 반드시 `next.config.ts`에 추가:
```ts
const nextConfig: NextConfig = {
  allowedDevOrigins: ["100.112.142.127"],
};
```
이 버그는 HTML은 정상 렌더되지만 JS가 죽어서 "클릭이 안 된다" 형태로 나타난다. 새 Next.js 프로젝트 생성 시 셋업 단계에서 먼저 넣어둘 것.
