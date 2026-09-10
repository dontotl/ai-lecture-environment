# Python 백엔드 공통 가이드

FastAPI 하나가 API와 정적 파일을 제공한다. 기존 컨테이너는 `python3.9`를 제공하므로 해당 버전과 호환되는 의존성을 선택·고정한다. 데모 전용 `.venv`를 사용하고 플랫폼의 전역 패키지를 변경하지 않는다.

## API 계약

내부 FastAPI 경로는 `/api/...`다. Nginx가 외부 `/simple-rag/api/...`를 내부 `/api/...`로 전달한다.

| 메서드·경로 | 입력 | 결과 |
| --- | --- | --- |
| `GET /api/health` | 없음 | `status`, `mode`, `retrieval`, `document_count`, `chunk_count` |
| `GET /api/search?q=...` | 질문 | `mode`, `retrieval`, `sources`, `reason` |
| `POST /api/ask` | JSON `{"query":"교육비 지원 한도는?"}` | `mode`, `retrieval`, `answer`, `sources`, `citations`, `reason` |

`mode`는 `offline|openai`, `retrieval`은 `keyword|embedding`이다. `sources`는 `id`, `file`, `section`, `text`, `score`를 가진 배열이다. `citations`는 서버가 검증한 source ID 배열이며 오프라인에는 비운다. `reason`은 정상 시 null이고 대체 동작 시 `missing_api_key|provider_error`로 표시한다. 근거 부족 여부는 답변과 화면에서 설명한다.

질문은 앞뒤 공백을 제거한 1~1000자로 제한하고 잘못된 입력에 422를 반환한다. 빈 색인·검색 결과 없음도 테스트한다. health는 외부 API를 호출하지 않으며 키 값이나 전체 환경 설정을 반환하지 않는다.

## 구현 분리

설정 로더, 청크/색인, 검색, OpenAI 어댑터, API 라우트를 읽기 쉽게 분리한다. 앱 import 시 유료 호출을 하지 않는다. 동기 SDK 호출은 async 이벤트 루프를 막지 않도록 동기 라우트/스레드 처리 또는 async SDK를 사용한다.

정적 파일은 `static/`만 공개한다. 프로젝트 루트·지식 디렉터리·`.env`·Git·색인 파일을 정적 서빙하지 않는다. API 라우트를 먼저 등록하고 정적 HTML을 제공한다. 사용자 입력·검색 결과·LLM 출력은 브라우저에서 텍스트로 표시한다.

## 테스트

pytest와 FastAPI 테스트 클라이언트로 입력 검증, 근거 검색, 키 없는 ask, 빈 결과, 모의 공급자 오류, 잘못된 인용 ID를 검증한다. 기본 테스트는 네트워크와 실제 API 키를 사용하지 않는다. 실제 API 시연 결과는 모의 테스트와 별도로 기록한다.
