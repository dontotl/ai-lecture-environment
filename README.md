# Codex 셀프 데모·학습 플랫폼

기존 Docker 환경을 빌드하고, 강의 MD 디렉터리를 내려받아 Codex에 구현을 맡긴 다음, 생성된 웹 화면에서 직접 데모와 학습을 진행하는 플랫폼이다. 현재 GitHub 저장소는 비공개이며 clone하려면 접근 권한이 필요하다.

첫 강의는 [Simple RAG](courses/01-simple-rag/README.md)다. 가상의 사내 규정 4개로 검색·출처·선택적 OpenAI 답변 생성을 구현하고, 기술 소개·코드 샘플·데모 구조·아키텍처를 같은 화면에서 학습한다. 저장소에는 구현 지시 MD를 배포하고, 수강생의 구현물은 `/labs/demos/simple-rag`에 독립 Git으로 생성한다.

## 빠른 시작

호스트에 Docker Compose와 Codex CLI를 준비한다. 호스트에서 `codex login`을 완료해 `${HOME}/.codex/auth.json`이 실제 파일로 존재하는지 확인한다. Compose가 이 파일을 컨테이너에 마운트하므로 이미 인증되어 있으면 컨테이너에서 브라우저 로그인을 반복할 필요가 없다. Codex 인증을 데모의 OpenAI API 키로 사용하지 않는다.

GitHub 접근 권한이 있는 계정으로 인증한 뒤 영문 경로에 clone하는 것을 권장한다. OrbStack/BuildKit의 일부 환경에서는 한글 경로에서 빌드 세션 오류가 발생할 수 있다.

```sh
git clone https://github.com/dontotl/ai-lecture-environment.git
cd ai-lecture-environment
```

```sh
cp .env.example .env
```

`.env`의 예제 DB 비밀번호를 편집기로 변경한다. 이후 실행한다.

```sh
docker compose --env-file env/macos-arm64.env up --build -d
./scripts/verify-compose.sh env/macos-arm64.env
```

Windows x64에서는 `env/windows-amd64.env`를 사용한다. API는 `http://localhost:8080/api/health`, 화면은 `http://localhost:8080`에서 확인한다.

동적 데모와 강의 MD는 `runtime-data/`에 영속되며, 데모 URL과 start/stop 계약은 [동적 데모 런타임 계약](docs/demo-runtime-contract.md)을 따른다.

## MD를 내려받아 셀프 데모 만들기

### 1. 강의 패키지 준비

위에서 저장소를 clone했다면 강의 MD도 이미 내려받은 상태다. 호스트 저장소 루트에서 패키지 전체를 `/labs/materials`로 복사한다. 다음은 해당 목적지가 없는 최초 준비 명령이다. 기존 자료가 있으면 덮어쓰기 전에 수정 여부를 확인한다.

```sh
docker compose --env-file env/macos-arm64.env cp courses/01-simple-rag app:/labs/materials/01-simple-rag
```

Docker 환경을 별도로 준비했고 강의 문서만 받고 싶다면 호스트의 새 디렉터리에서 sparse checkout을 사용할 수 있다. GitHub 인증은 호스트에서 수행하며 인증 토큰을 URL에 넣지 않는다.

```sh
git clone --filter=blob:none --sparse https://github.com/dontotl/ai-lecture-environment.git lecture-materials
git -C lecture-materials sparse-checkout set courses/01-simple-rag
```

그 뒤 Docker 배포 저장소 루트에서 `docker compose ... cp`의 원본 경로를 내려받은 `lecture-materials/courses/01-simple-rag`의 실제 경로로 지정한다. `AGENTS.md`와 시나리오뿐 아니라 가이드·지식·검증 MD까지 디렉터리 전체를 복사한다. 이 방식은 컨테이너 안에 GitHub 인증을 추가하지 않아도 된다.

### 2. Codex에 구현 요청

```sh
./scripts/codex.sh -- -C /labs/materials/01-simple-rag --add-dir /labs/demos --add-dir /labs/runtime --config approvals_reviewer=user
```

Codex에 입력한다.

```text
AGENTS.md와 scenarios/scenario-01.md 및 참조된 가이드·체크리스트를 모두 읽고
/labs/demos/simple-rag에 독립 Git 저장소로 구현해줘.
API 키 없는 검색 모드부터 테스트하고 start.sh로 기동해줘.
기술 소개·RAG 체험·기술 샘플·데모 구조·아키텍처 탭을 완성하고
검증 결과와 미완료 사항, 접속 URL을 알려줘.
```

Windows x64의 Bash/WSL에서는 모든 Compose 명령의 환경 파일을 `env/windows-amd64.env`로 바꾸고, Codex 래퍼에는 `--env-file env/windows-amd64.env`를 `--` 앞에 추가한다. 최초 의존성 설치에는 네트워크가 필요하다.

### 3. 데모와 학습

Codex가 구현·기동한 뒤 `http://localhost:8080/simple-rag/`를 연다. [5분 시연 체크리스트](courses/01-simple-rag/checks/scenario-01-checklist.md)를 따라 질문·출처·샘플 코드·아키텍처를 확인한다. API 키가 없어도 검색을 체험할 수 있다. 온라인 생성은 데모 `.env`의 별도 API 키와 `RAG_MODE=openai` 설정이 필요하며 API 비용이 발생한다.

Archify 전체 스킬 패키지는 이 저장소에 포함되지 않는다. 제공된 환경에서는 Archify 기반 화면을 생성하고, 없는 환경에서는 “Archify 미적용”으로 표시된 기본 아키텍처를 생성한다. [설치 전제와 검증 기준](courses/01-simple-rag/guides/architecture.md)을 참고한다.

## 강의 패키지 표준

```text
courses/01-simple-rag/
├── AGENTS.md                 # 에이전트 실행 순서와 공통 규칙
├── README.md                 # 수강생 시작 안내
├── scenarios/scenario-01.md  # 자동 구현할 기능·산출물
├── guides/                   # 아키텍처·LLM/임베딩·프론트·백엔드·런타임
├── knowledge/                # 교육용 가상 규정 MD 4개
├── checks/                   # 정답 근거·검증·셀프 시연
└── assets/README.md          # 선택적 이미지 자산 안내
```

새 강의는 이 디렉터리를 복제하고 slug, 시나리오, 지식 문서, 검증 기준을 함께 바꾼다. Codex를 강의 루트에서 시작해 `AGENTS.md`를 읽게 한다. 구현 시 규칙도 생성 저장소로 복사하므로 후속 학습을 이어갈 수 있다.

## 데이터·포트·정지

| 대상 | 위치·역할 |
| --- | --- |
| 샘플 웹/API | 호스트 `8080/`, `8080/api/health` |
| RAG 웹/API | 호스트 `8080/simple-rag/`, `8080/simple-rag/api/...` |
| 자료·구현·런타임 | 호스트 `${LABS_DIR:-./runtime-data}` → app `/labs` |
| RAG 프로세스 | app 내부 FastAPI 하나, 루프백 포트를 API·웹에 함께 사용 |
| Oracle | Compose `db:1521/FREEPDB1`, 기존 샘플용, 호스트 포트 미공개 |
| Oracle 데이터 | `oracle-data` named volume, RAG는 로컬 색인 사용 |

`LABS_DIR`는 Compose용 환경 파일(예: `env/macos-arm64.env`)에 설정해 자료·구현의 호스트 위치를 바꿀 수 있다. 강의는 `/labs/materials`, 구현은 `/labs/demos`, 로그·라우트·활성 목록은 `/labs/runtime`에 저장한다.

데모만 중지할 때는 생성된 `stop.sh`를 사용한다. 전체 환경의 일반 중지는 `docker compose --env-file env/macos-arm64.env down`이다. `down -v`는 Oracle named volume까지 삭제하므로 일반 정지에 사용하지 않는다. 활성 데모는 app 재시작 때 복구되고, 중지한 데모는 복구되지 않도록 구현한다.

## Codex CLI

app 컨테이너에서 Codex를 실행하려면 다음 래퍼를 사용한다. 호스트 인증 파일을 재사용하며 인증 상태를 먼저 확인한다. 재인증이 필요할 때 `login` 인자를 사용한다.

```sh
./scripts/codex.sh login status
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

수강생용 배포물에는 강사 노트, 구현 모범 답안, 교육자 전용 Codex 스킬, 인증 정보가 포함되지 않는다. 강의 MD와 교육용 가상 데이터, 검증 기대값을 제공한다.
