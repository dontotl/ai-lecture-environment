# 시나리오 01 — 근거를 보여주는 사내 규정 RAG

## 목표와 입력

이 패키지의 `AGENTS.md`와 모든 `guides/`, [체크리스트](../checks/scenario-01-checklist.md)를 읽고 아래 웹 앱을 실제 구현한다. 입력은 `knowledge/`의 교육용 가상 규정 4개이며 정답 근거는 체크리스트에 있다. 새로운 사실이나 회사 규정을 임의로 보태지 않는다.

- slug: `simple-rag`
- 구현 위치: `/labs/demos/simple-rag`
- 외부 웹: `http://localhost:8080/simple-rag/`
- 외부 API: `http://localhost:8080/simple-rag/api/...`
- 저장: 로컬 MD와 Git 제외 `data/index.json`. Oracle은 플랫폼 샘플의 DB로 유지하며 이 시나리오는 사용하지 않는다.

## 필수 구현물

```text
/labs/demos/simple-rag/
├── AGENTS.md, README.md
├── guides/, scenarios/, checks/, knowledge/ # 입력 규칙·지식 복사본
├── backend/                  # FastAPI, 검색, OpenAI 어댑터, 설정
├── static/
│   ├── index.html, styles.css, app.js
│   └── architecture/         # Archify HTML·JSON·PNG 또는 표시된 대체 화면
├── tests/                    # 네트워크 없는 API·검색 검증
├── requirements.txt          # Python 환경과 호환되는 고정 버전
├── .env.example, .gitignore
├── start.sh, stop.sh, reindex.sh
└── docs/verification.md      # 실행 명령·실제 결과·제한
```

`.venv/`, `.env`, `.runtime.env`, `data/`, 로그·PID·캐시는 Git에서 제외한다. 구현 파일과 지식 문서는 독립 Git에 로컬 커밋한다.

## 학습 화면

메인 화면에 한국어 탭 5개를 제공한다.

1. **기술 소개**: RAG의 목적, 청크·임베딩·검색·생성의 역할, 문서에 없는 답변을 만들면 안 되는 이유.
2. **RAG 체험**: 질문 입력, 검색만 실행/답변 요청 버튼, 예제 질문, 검색 결과·출처·답변·실행 모드·검색 방식을 구분해서 표시. 키 없는 상태에서도 동작한다.
3. **기술 샘플**: 실제 구현한 청크 분리, 검색 함수, OpenAI 호출, 브라우저 fetch의 짧은 코드와 설명. 파일 경로를 표시하고 코드와 설명이 일치하도록 작성한다.
4. **데모 구조**: 생성된 디렉터리 트리, 자료/구현 저장소 관계, 시작·중지·재색인 절차, 포트와 영속 데이터 위치.
5. **아키텍처**: 구현과 일치하는 Archify HTML을 iframe으로 포함한다. 설치 누락 및 PNG 대체 동작은 가이드를 따른다.

## 구현·검증 순서

1. 컨테이너 환경과 입력 문서를 읽고 생성 대상의 기존 상태를 확인한다.
2. 가이드와 규정 복사, 독립 Git, 환경 설정, 검색·API·정적 화면을 구현한다.
3. API 키 없는 테스트를 실행하고 화면에서 검색과 근거 없는 질문을 확인한다.
4. OpenAI 어댑터와 모의 테스트를 구현한다. 명시적으로 온라인 모드가 설정됐을 때만 실제 호출한다.
5. 아키텍처·기술 샘플·시연 안내를 실제 구현에 맞춰 생성한다.
6. 시작·중지·재시작을 검증하고 기록한다. 전체 체크리스트의 통과/실패/미검증을 구분한다.
7. 완료 보고와 로컬 커밋을 남긴다. 실패를 숨기기 위해 요구사항을 지우지 않는다.

## 확장 실습

교육비 규정의 가상 금액을 변경하고 `reindex.sh`로 재색인해 검색 결과 변화를 확인한다. 수정 전후를 Git diff로 설명한다. 온라인 모드와 키워드 검색 결과 차이를 비교하되, 점수 척도가 같다고 해석하지 않는다.
