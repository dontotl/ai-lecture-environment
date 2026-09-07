# Codex 프로필 정책

수강생 저장소에는 Codex CLI 실행 환경만 포함한다. 각 사용자는 앱 컨테이너에서 자신의 계정으로 로그인한다.

```sh
docker compose exec -it app codex login
docker compose exec -it app codex
```

프로젝트 루트의 `.codex/`은 개인별 인증, 절대 경로, 로컬 심볼릭 링크를 가질 수 있으므로 Git으로 배포하지 않는다.

교육자 전용 Codex 스킬과 강사 자동화는 비공개 교육자 저장소에서 관리한다. 이 저장소에는 공개 실습에 필요한 Codex CLI 실행 환경만 둔다.
