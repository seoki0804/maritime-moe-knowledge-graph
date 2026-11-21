# Maritime MoE — Knowledge Graph

**Maritime MoE**(해사 규정 준수를 위한 도메인 특화 Mixture-of-Experts 시스템) 연구의 구성요소를 Neo4j 지식그래프로 표현한 프로젝트입니다.

연구의 데이터, 방법론, 평가 결과, fine-tuning 개선 계획이 서로 어떻게 연결되는지를 Cypher로 탐색할 수 있게 했습니다.

## 왜 그래프인가

연구의 구성요소는 표로 정리하면 관계가 사라집니다.

- 하나의 전문가(Expert)는 여러 규정 영역을 담당한다
- 하나의 평가 지표는 특정 failure mode와 연결된다
- 취약점 분석은 개선 계획으로 이어진다

`연구 → 시스템 → 전문가 → 규정 → 취약점 → 개선계획` 경로를 따라가는 것이 핵심이라, 그래프 DB가 적합합니다.

## 그래프 구성

연구, 시스템, 방법론(RAG·라우터), 전문가, 해사 도메인, 규정, 데이터셋, 평가 지표, failure mode, fine-tuning 계획을 노드와 관계로 구성했습니다.

## 주요 결과

| 항목 | 값 |
| --- | --- |
| Baseline 정확도 | 55.3% |
| Maritime MoE 정확도 | 76.4% |
| 개선폭 | +21.1%p |
| 최대 취약 영역 | SOLAS LSA 46% |

SOLAS LSA 영역의 취약점은 targeted fine-tuning 계획으로 연결됩니다. 이 경로가 그래프에서 하나의 path로 조회됩니다.

## 파일

```
maritime_moe_graph_load.cypher      지식그래프 생성
maritime_moe_graph_queries.cypher   탐색 쿼리 모음
generate_captures.py                Neo4j 없이 그래프 도식 생성
captures/                           그래프·쿼리 결과 캡처
submission_text.md                  텍스트형 설명
```

## 실행

Neo4j Browser에서 전용 데이터베이스를 하나 만든 뒤 실행하세요.

```cypher
:use maritimemoe
```

1. `maritime_moe_graph_load.cypher` 전체 실행
2. `maritime_moe_graph_queries.cypher` 에서 필요한 쿼리 실행

`maritime_moe_graph_load.cypher` 는 첫 줄에서 현재 DB의 노드를 삭제합니다. 기존 DB에서 실행하지 마세요.

## 쿼리 예시

- label / relationship summary
- 연구 중심 전체 그래프
- 전문가 라우팅 경로
- 성능 지표 테이블
- 취약점 → fine-tuning 개선 경로

## 기술 스택

Neo4j · Cypher · Python
