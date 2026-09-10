# Archify 아키텍처 공통 가이드

아키텍처는 웹 데모 안의 학습 모듈이다. 실제 구현을 읽고 생성하며 미구현 기능을 그리지 않는다.

## 표현할 관계

브라우저 → Nginx 8080 → FastAPI → 로컬 규정/색인 → 검색 근거 → 답변·출처 흐름을 그린다. OpenAI 임베딩/생성 호출은 온라인 모드에서만 연결되는 외부 경계로 표현한다. Codex는 개발 도구이며 런타임 질의 경로에 넣지 않는다.

호스트 `/labs` bind mount의 자료·구현·색인 영속성과 app 내부 프로세스를 구분한다. Oracle은 기존 샘플 전용으로 표시하거나 생략하되 RAG가 Oracle을 사용한다고 표현하지 않는다.

## Archify가 있는 경우

1. 실행 환경에서 Archify의 실제 `SKILL.md`와 CLI 경로를 확인하고 전체 지침을 읽는다. 이 강의 MD 자체가 스킬 설치를 대신하지 않는다.
2. 설치된 스키마와 예제에 맞춰 `static/architecture/architecture.json`을 작성한다. 임의 스키마를 만들지 않는다.
3. `meta.quality_profile`을 `showcase`로 지정하고 설치된 CLI의 `validate`, `deliver` 절차를 따른다. HTML은 `static/architecture/index.html`에 생성한다.
4. 스킬의 브라우저 검증·시각 검토·PNG 내보내기를 수행한다. `static/architecture/architecture.png`와 검증 결과를 보관한다. HTML 검증과 실제 브라우저 검증 결과를 구분한다.
5. 한국어 내용으로 작성한다. 설치 버전이 한국어 Viewer UI를 지원하지 않으면 Viewer 기본 UI가 영어임을 안내한다.

CLI 인자는 설치된 스킬 지침을 따른다. 전체 패키지를 제공할 때 스키마·렌더러·자산·라이선스도 필요하다. `SKILL.md` 한 파일만 복사하지 않는다. 호스트 개인 경로를 생성 문서에 하드코딩하지 않는다.

## 화면 포함과 대체 동작

메인 화면의 아키텍처 탭에 제목을 가진 iframe으로 `./architecture/index.html`을 표시하고 “새 창에서 보기” 링크를 제공한다. HTML 표시가 실패하면 존재하는 PNG를 표시한다. PNG가 없으면 명확한 안내를 제공한다.

Archify가 설치되지 않았다면 학습을 계속할 수 있도록 동일 관계의 자체 작성 정적 HTML/inline SVG를 만들고 “기본 아키텍처 — Archify 미적용”으로 표시한다. 이 파일을 Archify 산출물이나 검증 통과로 보고하지 않는다. README와 검증 기록에 Archify 설치 후 교체 절차를 남긴다. Archify 완료 항목은 미검증/미완료로 유지한다.
