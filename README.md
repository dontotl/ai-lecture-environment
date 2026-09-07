# AI 강의 수강생 저장소

이 저장소는 수강생이 Docker 기반 실습 환경을 실행하고 주제별 실습을 수행하기 위한 공개 배포물이다.

## 빠른 시작

```sh
cp .env.example .env
docker compose --env-file env/macos-arm64.env up --build -d
./scripts/verify-compose.sh env/macos-arm64.env
```

Windows x64에서는 `env/windows-amd64.env`를 사용한다. API는 `http://localhost:8000/api/health`, 화면은 `http://localhost:5173`에서 확인한다.

## 문서

- [환경 실행 안내](강의환경빌드_v2.md)
- [강의 모듈 목록](courses/README.md)
- [환경 구현 명세](docs/강의환경_구현명세_v2.md)
- [교육자 비공개 저장소 운영 안내](docs/교육자_저장소_운영.md)

수강생용 저장소에는 강사 노트, 모범 답안, 교육자 전용 Codex 스킬, 인증 정보가 포함되지 않는다.
