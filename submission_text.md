# Assignment 4 제출용 텍스트

## 주제

본 과제에서는 석사 논문 주제인 **해사 규정 준수를 위한 도메인 특화 전문가 혼합 시스템(Maritime MoE)**을 지식그래프로 구성하였다. 논문은 해사 분야의 규정 질의에 대해 범용 LLM이 갖는 전문성 부족과 수치 정밀도 한계를 해결하기 위해, 질의를 전문 영역별 전문가 모델로 라우팅하고 RAG를 통해 규정 문서를 검색하는 구조를 제안한다.

## 지식그래프 구성

지식그래프의 중심 노드는 `Paper`와 `System`이다. `Paper`는 Maritime MoE 논문을 의미하고, `System`은 논문에서 제안한 해사 전문가 혼합 시스템을 의미한다. 논문은 `Maritime MMLU-1K Benchmark`, `Domain Expert Routing Architecture`, `Empirical Validation`, `Fine-tuning Improvement Plan`이라는 네 가지 핵심 기여와 연결된다.

시스템 구조는 `Mixture-of-Experts`, `Retrieval-Augmented Generation`, `Keyword-based Routing`, `Fine-tuning`, `Benchmark Evaluation`과 같은 방법론 노드로 표현하였다. 또한 `MOE Router`는 `Regulation Expert`, `Safety Management and Legal Expert`, `Life-saving and Fire Expert`, `Cargo and Stability Expert`, `Communication Expert`, `Machinery Expert`, `Navigation Expert`, `Environment Expert`의 8개 전문가 노드로 연결된다.

각 전문가는 해사 도메인 노드와 연결된다. 예를 들어 `Life-saving and Fire Expert`는 `SOLAS Life-Saving Appliances`와 `SOLAS Fire Protection` 도메인에 연결되고, 이 도메인들은 다시 `SOLAS`, `LSA Code`, `FSS Code` 규정 노드와 연결된다. 이를 통해 논문의 시스템 아키텍처가 실제 해사 규정 체계와 어떻게 연결되는지 그래프 형태로 설명할 수 있다.

## 논문과 fine-tuning의 연결

논문 실험에서는 Maritime MoE가 GPT-4 Baseline 55.3% 대비 76.4%의 정확도를 달성하여 21.1%p 향상된 것으로 정리하였다. 특히 ISM Code와 COLREGs 영역에서는 큰 성능 향상을 보였지만, `SOLAS Life-Saving Appliances` 영역은 46% 수준으로 낮아 수치 정밀도 문제가 확인되었다.

따라서 지식그래프에는 `Finding`, `FailureMode`, `FineTuningPlan` 노드를 추가하였다. `SOLAS LSA weakness` 발견은 `Numerical Precision Failure`와 연결되고, 이 failure mode는 `LSA and Fire Targeted Fine-tuning` 계획으로 연결된다. 이 계획은 `Targeted Fine-tuning QA` 데이터셋과 연결되며, 최종적으로 `Life-saving and Fire Expert`를 개선하는 구조로 표현하였다.

즉, 본 지식그래프는 논문의 문제 정의, 모델 구조, 평가 결과, 취약점 분석, fine-tuning 개선 방향을 하나의 연결망으로 표현한다.

## Cypher 쿼리 예시

논문 중심 그래프를 확인하기 위한 쿼리는 다음과 같다.

```cypher
MATCH p = (:Paper {node_id:'PAPER_MARITIME_MOE'})-[*1..2]-(n)
RETURN p
LIMIT 80;
```

논문 성능 지표를 확인하기 위한 쿼리는 다음과 같다.

```cypher
MATCH (eval:Evaluation)-[:REPORTS_METRIC]->(metric:Metric)
RETURN eval.name AS evaluation, metric.name AS metric, metric.value_text AS value
ORDER BY metric.value_number DESC;
```

fine-tuning 개선 경로를 확인하기 위한 쿼리는 다음과 같다.

```cypher
MATCH p =
  (:Paper {node_id:'PAPER_MARITIME_MOE'})
  -[:HAS_CONTRIBUTION]->(:ResearchContribution {node_id:'CONTRIB_FINETUNING'})
  -[:INTRODUCES]->(:Dataset {node_id:'DATA_TARGETED_QA'})
  <-[:USES_DATA]-(:FineTuningPlan)
  -[:TARGETS]->(:Domain {node_id:'DOMAIN_SOLAS_LSA'})
RETURN p;
```

이 쿼리는 Maritime MoE 논문의 fine-tuning 기여가 targeted QA 데이터셋을 통해 SOLAS LSA 취약 도메인을 개선하는 경로를 보여준다.
