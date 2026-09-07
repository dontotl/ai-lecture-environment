# Codex 프로필 정책

수강생 저장소에는 Codex CLI 실행 환경만 포함한다. 각 사용자는 앱 컨테이너에서 자신의 계정으로 로그인한다.

```sh
docker compose exec -it app codex login
docker compose exec -it app codex
```

프로젝트 루트의 `.codex/`은 개인별 인증, 절대 경로, 로컬 심볼릭 링크를 가질 수 있으므로 Git으로 배포하지 않는다.

`infra/codex-profile/skill-manifest.txt`는 교육자가 로컬에서 사용할 선택 스킬의 목록일 뿐이며, 실제 스킬 파일은 제3자 라이선스 조건 때문에 수강생 저장소에 포함하지 않는다. 적법하게 설치된 스킬이 있는 교육자 로컬 환경에서만 다음 명령으로 컨테이너 빌드용 사본을 준비한다.

```sh
./scripts/sync-codex-skills.sh
./scripts/verify-compose.sh env/macos-arm64.env --require-skills
```
