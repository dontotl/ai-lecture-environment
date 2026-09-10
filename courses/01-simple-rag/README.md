# 01. Simple RAG 셀프 데모·학습

가상의 사내 규정 MD 4개를 읽고 근거를 검색하는 웹 데모를 Codex로 만든다. 검색 → 근거 확인 → 답변 생성의 차이를 직접 확인하고, 같은 화면에서 기술 소개·코드·데모 구조·아키텍처를 학습한다. 예상 시간은 환경 준비 후 45~60분이다.

## 준비

- 기존 강의 Docker 환경이 실행 중이고 `http://localhost:8080/api/health`가 정상이어야 한다.
- app 컨테이너에서 Codex 인증과 `/labs` 쓰기가 가능해야 한다. Codex 로그인은 코딩 에이전트용이며, 데모의 OpenAI API 사용은 별도의 `OPENAI_API_KEY`가 필요하다.
- API 키가 없어도 검색·출처 확인·화면 학습을 할 수 있다. 의존성 최초 설치에는 네트워크가 필요하다. 여기서 오프라인은 실행 중 OpenAI 호출을 하지 않는다는 뜻이다.
- Archify 전체 스킬 패키지는 기본 배포물에 포함되지 않는다. 사용할 경우 실행 중인 Codex가 접근할 수 있는 위치에 별도로 준비한다. 미설치 시 [아키텍처 가이드](guides/architecture.md)의 표시된 대체 모드로 학습한다.

## 문서 구조

```text
01-simple-rag/
├── AGENTS.md                 # Codex 실행 순서·작업 규칙
├── README.md                 # 수강생 시작 안내
├── scenarios/scenario-01.md  # 만들 데모의 요구사항
├── guides/                   # architecture, rag-llm, backend,
│                             # frontend, demo-runtime 규약
├── knowledge/                # 휴가·재택근무·출장비·교육비 MD
├── checks/                   # 기대 근거·검증·시연 기준
└── assets/README.md          # 선택적 이미지 자산 안내
```

이 디렉터리 전체가 한 강의 패키지다. 시나리오 파일 하나만 다운로드하면 가이드와 지식 문서가 누락된다. [AGENTS.md](AGENTS.md)와 [시나리오](scenarios/scenario-01.md), 그 안의 링크를 함께 전달한다.

## Codex로 구현

호스트의 배포 저장소 루트에서 실행한다. 이 예시는 패키지를 `/labs/materials/01-simple-rag`에 내려받거나 복사한 경우다. 다운로드 방법은 저장소 루트 README의 셀프 학습 절차를 따른다.

```sh
./scripts/codex.sh -- -C /labs/materials/01-simple-rag --add-dir /labs/demos --add-dir /labs/runtime --config approvals_reviewer=user
```

Codex에 다음을 입력한다.

```text
AGENTS.md와 scenarios/scenario-01.md, 참조된 모든 가이드와 검증 문서를 읽어라.
/labs/demos/simple-rag에 독립 Git 저장소로 데모를 구현하라.
API 키 없는 모드부터 실행·검증하고 체크리스트 결과를 기록하라.
http://localhost:8080/simple-rag/에서 셀프 데모와 학습을 할 수 있게 시작하라.
Archify와 온라인 API 검증 여부를 정확히 구분해서 보고하라.
```

Windows x64의 Bash/WSL에서는 래퍼에 `--env-file env/windows-amd64.env`를 `--` 앞에 추가한다. `--add-dir`는 파일 작업 범위이며 프로세스 시작·Nginx reload의 실행 승인을 대신하지 않는다.

## 실행과 시연

구현 완료 후 호스트에서 실행한다. 생성되기 전에는 아래 스크립트가 없다.

```sh
docker compose --env-file env/macos-arm64.env exec app /labs/demos/simple-rag/start.sh
curl http://localhost:8080/simple-rag/api/health
docker compose --env-file env/macos-arm64.env exec app /labs/demos/simple-rag/stop.sh
```

브라우저에서 `/simple-rag/`를 열어 기술 소개를 읽고 RAG 체험의 예제 질문을 실행한다. [검증·시연 순서](checks/scenario-01-checklist.md)로 검색 근거와 답변을 비교한다. 생성된 README에는 `.env` 설정·재색인·재시작 방법도 포함되어야 한다.

온라인 모드를 사용하려면 생성된 데모의 `.env.example`을 `.env`로 복사해 자신의 API 키를 편집기로 입력한다. 채팅이나 Git에 키를 붙이지 않는다. `RAG_MODE=openai`로 바꾼 뒤 데모를 중지·시작한다. 이때 임베딩·질문 요청에 API 비용이 발생한다.

## 학습 결과

- 지식 문서의 어느 조항이 답변을 뒷받침하는지 설명할 수 있다.
- 키워드 검색, 벡터 검색, LLM 생성을 구분할 수 있다.
- 자료와 구현 Git 저장소, 호스트 영속 디렉터리, 컨테이너 프로세스의 관계를 이해한다.
- 생성한 코드와 테스트를 읽고 지식 문서를 수정·재색인해 결과 변화를 확인한다.
