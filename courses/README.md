# 강의 모듈

각 강의는 `courses/<순번>-<주제>/`에 독립적으로 배치된다. Docker 환경을 빌드한 다음 강의 디렉터리 전체를 `/labs/materials/`에 준비하고 Codex로 구현·검증한다. 생성 결과는 `/labs/demos/<slug>/`의 독립 Git 저장소이며 웹에서 셀프 데모와 학습을 진행한다.

| 순번 | 주제 | 상태 |
| --- | --- | --- |
| 01 | [Simple RAG](01-simple-rag/README.md) | 구현 지시 MD·가상 규정 4개·검증 기준 제공 |

## Codex 구현형 패키지

`01-simple-rag/`를 예시로 복제한다. `AGENTS.md`는 읽기 순서와 작업 규칙, `scenarios/`는 기능과 산출물, `guides/`는 기술 규약, `knowledge/`는 RAG 입력, `checks/`는 검증과 시연, `assets/`는 선택 자산을 소유한다. 각 패키지는 외부 공용 MD 없이 읽을 수 있도록 구성한다. Docker 런타임과 선택적 Archify 스킬은 실행 환경의 전제 조건이다.

새 모듈을 만들 때 디렉터리명뿐 아니라 문서 전체의 slug·URL·구현 경로·질문·기대 근거를 함께 수정한다. 강의 저장소에 수강생 구현물이나 비밀 정보를 커밋하지 않는다.

## 기존 수동 실습 템플릿

`courses/_template/`과 아래 명령은 `lab/` 중심의 기존 수동 실습 틀이다. 새 Codex 구현형 패키지 전체를 생성하는 명령은 아니다.

```sh
./scripts/new-course.sh --id 02 --slug oracle-basics --title "Oracle 기초"
```
