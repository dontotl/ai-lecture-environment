# AI 강의 수강생 저장소

이 저장소는 수강생이 Docker 기반 실습 환경을 실행하고 주제별 실습을 수행하기 위한 공개 배포물이다.

## 빠른 시작

```sh
cp .env.example .env
docker compose --env-file env/macos-arm64.env up --build -d
./scripts/verify-compose.sh env/macos-arm64.env
```

Windows x64에서는 `env/windows-amd64.env`를 사용한다. API는 `http://localhost:8080/api/health`, 화면은 `http://localhost:8080`에서 확인한다.

동적 데모와 강의 MD는 `runtime-data/`에 영속되며, 데모 URL과 start/stop 계약은 [동적 데모 런타임 계약](docs/demo-runtime-contract.md)을 따른다.

## Codex CLI

app 컨테이너에서 Codex를 실행하려면 다음 래퍼를 사용한다. 첫 로그인은 `login` 인자를 붙인다.

```sh
./scripts/codex.sh login
./scripts/codex.sh
```

Windows x64에서는 환경 파일을 지정한다.

```sh
./scripts/codex.sh --env-file env/windows-amd64.env login
./scripts/codex.sh --env-file env/windows-amd64.env
```

## 문서

- [환경 실행 안내](강의환경빌드_v2.md)
- [강의 모듈 목록](courses/README.md)
- [Codex CLI 사용 정책](docs/codex-minimal-profile.md)

수강생용 저장소에는 강사 노트, 모범 답안, 교육자 전용 Codex 스킬, 인증 정보가 포함되지 않는다. 해당 자료는 별도 비공개 교육자 저장소에서 관리한다.
