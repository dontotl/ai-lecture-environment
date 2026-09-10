# Codex 프로필 정책

수강생 저장소에는 Codex CLI 실행 환경만 포함한다. 각 사용자는 앱 컨테이너에서 자신의 계정으로 로그인한다.

Docker Compose는 호스트의 `${HOME}/.codex/auth.json`을 앱 컨테이너의
`/tmp/codex-home/auth.json`에 마운트한다. Codex는
`CODEX_HOME=/tmp/codex-home`에서 이 인증 파일과 `config.toml`을 자동으로
읽는다. 따라서 호스트에서 Codex에 로그인한 상태라면 컨테이너에서도
별도 로그인 없이 사용할 수 있다.

```sh
./scripts/codex.sh login
./scripts/codex.sh
```

Windows x64에서는 `./scripts/codex.sh --env-file env/windows-amd64.env`를 사용한다.

인증 마운트 또는 `infra/app/entrypoint.sh`를 변경한 뒤에는 앱 이미지를
재생성한다.

```sh
docker compose --env-file env/macos-arm64.env up -d --build app
```

`auth.json`은 이미지에 `COPY`하지 않는다. 이미지 레이어에 인증 토큰이
남을 수 있기 때문이다. 호스트 파일은 Git에서도 제외한다. 컨테이너에서
`codex login`을 수행하면 이 파일에 인증 정보가 저장되고 갱신된다.

프로젝트 루트의 `.codex/`은 개인별 인증, 절대 경로, 로컬 심볼릭 링크를 가질 수 있으므로 Git으로 배포하지 않는다.

교육자 전용 Codex 스킬과 강사 자동화는 비공개 교육자 저장소에서 관리한다. 이 저장소에는 공개 실습에 필요한 Codex CLI 실행 환경만 둔다.
