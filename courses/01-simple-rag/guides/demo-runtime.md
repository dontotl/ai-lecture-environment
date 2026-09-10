# 데모 런타임 공통 가이드

자료는 `/labs/materials/`, 구현은 `/labs/demos/simple-rag`에 둔다. Compose의 `/labs`는 호스트 `${LABS_DIR:-./runtime-data}` bind mount다. 배포 Git, 강의 자료, 생성된 구현 Git 저장소는 구분한다. 새 Compose 서비스·외부 포트·Docker 소켓은 필요 없다.

## 현재 플랫폼 인터페이스

app의 `/usr/local/lib/demo-runtime.sh`를 source한다. 구현 시작 전에 실제 파일의 함수를 확인한다.

| 함수 | 호출 인자·역할 |
| --- | --- |
| `demo_prepare` | slug: 런타임 디렉터리 준비 |
| `demo_allocate_port` | 시작 포트, 끝 포트: 사용 가능한 포트 선택 |
| `demo_write_runtime_env` | slug, API 포트, 웹 포트: `.runtime.env` 저장 |
| `demo_write_pid` | slug, 이름, PID: PID 기록 |
| `demo_register_route` | slug, API 포트, 웹 포트: 라우트 생성 및 Nginx reload |
| `demo_enable` | slug: 활성 목록 등록 |
| `demo_stop_pid` | slug, 이름: 해당 PID 종료 |
| `demo_disable` | slug: 라우트·활성 목록 제거 및 reload |

이 데모는 **한 FastAPI 프로세스**를 사용한다. 예를 들어 API 포트를 9000~9499에서 선택하고 `WEB_PORT=$API_PORT`로 저장하며 `demo_register_route simple-rag "$API_PORT" "$API_PORT"`를 호출한다. 기존 Vite용 두 프로세스 템플릿을 그대로 복제하지 않는다.

## 시작·중지·복구

- `start.sh`는 어느 작업 디렉터리에서 호출해도 자신의 디렉터리로 이동한다. 최초에 전용 venv와 의존성을 준비하고 같은 환경을 재사용한다.
- 저장된 포트가 있으면 재사용하되 다른 프로세스가 쓰면 새 포트를 선택해 저장한다. bind 경합으로 기동이 실패하면 실패를 기록하고 한정된 횟수만 재시도한다.
- Uvicorn은 `127.0.0.1`에 실행하고 백그라운드 실제 프로세스 PID 하나를 `simple-rag-api.pid`로 기록한다. health가 준비된 후 라우트를 등록하고 활성 목록에 추가한다.
- 반복 start는 이미 실행 중인 자기 프로세스를 확인해 중복 실행하지 않는다. 실패 시 자신이 새로 만든 프로세스·라우트만 정리하고 다른 데모를 건드리지 않는다.
- `--restore`를 지원한다. 플랫폼 부트 스크립트가 활성 목록의 데모에 이 옵션을 전달한다. 이전 컨테이너의 PID 파일은 신뢰하지 않는다.
- helper의 PID 종료는 숫자만 사용하므로 호출 전 해당 PID가 자기 데모의 Uvicorn인지 명령줄과 작업 디렉터리를 확인한다. 다른 프로세스나 재사용된 PID를 종료하지 않는다.
- `stop.sh`는 자기 프로세스 종료를 확인한 뒤 `demo_disable`을 호출한다. 반복 stop도 안전해야 한다. 소스·Git·키·색인을 지우지 않는다.
- 로그는 `/labs/runtime/logs/simple-rag/`, PID는 `/labs/runtime/pids/`, 라우트는 `/labs/runtime/nginx/simple-rag.conf`에 둔다.
- `reindex.sh`는 같은 venv와 설정을 사용하고 색인을 원자적으로 바꾼다. 실행 앱은 다음 요청에서 변경을 반영하거나 스크립트가 데모를 안전하게 재시작하도록 구현하고 방식을 README에 명시한다.

Nginx가 `/simple-rag/api/`를 내부 `/api/`로, `/simple-rag/`를 내부 `/`로 변환한다. 외부 URL과 내부 API 라우트를 혼동하지 않는다. 테스트 전 `nginx -t`/reload 권한을 확인하고 실패를 보고한다.

Oracle 데이터는 기존 `oracle-data` named volume이다. 이 RAG는 Oracle 계정을 만들지 않는다. 일반 정지는 `docker compose down`이며 `down -v`는 DB named volume을 삭제하므로 정지·검증 절차에 사용하지 않는다.
