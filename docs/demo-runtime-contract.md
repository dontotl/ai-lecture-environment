# 동적 데모 런타임 계약

강의 MD가 생성하는 데모는 `/labs/demos/<slug>`에 독립 Git 저장소로 만든다.
`slug`는 영문 소문자, 숫자, 하이픈만 쓰며 `/`, 공백, 대문자는 사용할 수 없다.

각 데모는 `start.sh`, `stop.sh`, `.gitignore`를 포함한다. `.gitignore`에는 최소한
`.env`, `.runtime.env`, 로그·PID 파일을 넣는다. start는 `/usr/local/lib/demo-runtime.sh`를
source해 API와 웹 프로세스를 `127.0.0.1`의 서로 다른 포트에 기동하고 `demo_register_route`,
`demo_enable`을 호출한다. stop은 `demo_stop_pid` 후 `demo_disable`을 호출한다.

외부 주소는 다음으로 고정한다.

- 웹: `http://localhost:8080/<slug>/`
- API: `http://localhost:8080/<slug>/api/...`

Vite는 `base: '/<slug>/'`를 사용하고, 브라우저 API 요청은 절대 호스트가 아닌
`/<slug>/api/...` 상대 경로를 사용한다. start/stop 예시는
`docs/demo-start.sh.template`, `docs/demo-stop.sh.template`에 있다.

데모별 Oracle 사용자는 해당 스키마 객체 권한만 갖게 한다. 비밀번호는 Git에 넣지 않는
데모 `.env`에만 저장한다. stop은 소스, Git 이력, `.env`, Oracle 데이터를 삭제하지 않는다.
