# Codex 주도 동적 데모 런타임

## 목표

강의 MD를 바탕으로 Codex가 `/labs/demos/<slug>`에 독립 Git 데모를 만들고,
단일 app 컨테이너에서 여러 데모를 동시에 실행한다. 기존 FastAPI/Vite 샘플은
환경 정상성 확인용으로 유지한다.

## 영속 상태

- `LABS_DIR`의 기본값은 `./runtime-data`이며 app 컨테이너의 `/labs`에 bind mount한다.
- `/labs/materials`에는 강의 MD Git clone/pull 결과를 보관한다.
- `/labs/demos/<slug>`에는 데모 소스와 독립 Git 이력을 보관한다.
- `/labs/runtime/nginx`, `logs`, `pids`, `enabled-demos`에는 동적 라우팅과 실행 상태를 보관한다.
- `runtime-data/`는 Git에서 제외한다. Oracle 데이터는 성능을 위해 기존 `oracle-data` named volume을 유지한다.

## HTTP와 프로세스

- app 이미지에 Nginx를 설치하고 Supervisor가 Nginx, 샘플 API, 샘플 Vite를 실행한다.
- 호스트에는 `8080:8080`만 공개한다. Nginx는 `/`과 `/api/`를 샘플에, `/<slug>/` 및 `/<slug>/api/`를 해당 데모의 루프백 포트에 프록시한다.
- 데모의 `start.sh`는 미사용 루프백 포트를 찾아 `.runtime.env`에 저장하고, API/Vite를 시작한 뒤 Nginx fragment와 enabled 목록을 갱신·reload한다.
- `stop.sh`는 자기 PID, 로그, Nginx fragment, enabled 항목만 정리한다. 소스·Git 이력·Oracle 데이터는 삭제하지 않는다.
- `boot-enabled-demos.sh`는 컨테이너 시작 시 enabled 목록만 읽어 복구한다.

## 데이터베이스와 보안

- 데모는 slug별 Oracle 사용자·스키마와 전용 비밀번호를 사용한다.
- 자격 증명은 데모별 `.env`에만 저장하고 Git에서 제외한다.
- app에는 Docker 소켓을 제공하지 않으며 데모별 Compose 서비스·포트·볼륨을 만들지 않는다.

## 검증 기준

- `docker compose up` 후 샘플 웹과 `/api/health`가 8080에서 응답한다.
- `/labs`의 materials, demo Git 이력, 런타임 상태가 app 재생성 후에도 보존된다.
- 복수 데모의 웹/API 라우트가 동시에 동작하며, 하나를 중지해도 다른 데모는 유지된다.
- app 재시작 시 enabled 데모만 복구된다.
- 데모별 Oracle 계정은 다른 데모 스키마에 접근하지 못한다.
