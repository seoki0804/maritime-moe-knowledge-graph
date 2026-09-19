// =========================================================
// Assignment 4 Queries
// Maritime MoE Thesis Knowledge Graph
// =========================================================

// 1. Label summary
MATCH (n)
RETURN [label IN labels(n) WHERE label <> 'KGNode'][0] AS label, COUNT(*) AS count
ORDER BY count DESC, label;

// 2. Relationship summary
MATCH ()-[r]->()
RETURN type(r) AS relationship, COUNT(*) AS count
ORDER BY count DESC, relationship;

// 3. Paper-linked knowledge graph view
MATCH p = (:Paper {node_id:'PAPER_MARITIME_MOE'})-[*1..2]-(n)
RETURN p
LIMIT 80;

// 4. Thesis contribution map
MATCH (paper:Paper {node_id:'PAPER_MARITIME_MOE'})-[:HAS_CONTRIBUTION]->(c:ResearchContribution)
OPTIONAL MATCH (c)-[r]->(target)
RETURN
  paper.title AS paper,
  c.name AS contribution,
  type(r) AS linked_relation,
  CASE
    WHEN target IS NULL THEN NULL
    ELSE [label IN labels(target) WHERE label <> 'KGNode'][0]
  END AS target_type,
  coalesce(target.name, target.title) AS target
ORDER BY contribution, target_type, target;

// 5. Maritime MoE architecture path
MATCH p =
  (:Paper {node_id:'PAPER_MARITIME_MOE'})
  -[:PROPOSES]->(:System)
  -[:USES_COMPONENT]->(:Component)
RETURN p;

// 6. Expert router and domain coverage
MATCH (:Router {node_id:'ROUTER_KEYWORD'})-[:ROUTES_TO]->(expert:Expert)
OPTIONAL MATCH (expert)-[:SPECIALIZES_IN]->(domain:Domain)-[:GOVERNED_BY]->(reg:Regulation)
RETURN
  expert.name AS expert,
  expert.scope AS scope,
  COLLECT(DISTINCT domain.name) AS domains,
  COLLECT(DISTINCT reg.name) AS regulations
ORDER BY expert;

// 7. Metric comparison from the thesis abstract
MATCH (eval:Evaluation)-[:REPORTS_METRIC]->(metric:Metric)
WHERE metric.node_id IN [
  'METRIC_BASELINE_ACC',
  'METRIC_MOE_ACC',
  'METRIC_DELTA_ACC',
  'METRIC_ISM_GAIN',
  'METRIC_COLREGS_GAIN',
  'METRIC_SOLAS_LSA_ACC',
  'METRIC_LOOKUP_TIME'
]
RETURN
  eval.name AS evaluation,
  metric.name AS metric,
  metric.value_text AS value,
  metric.unit AS unit
ORDER BY metric.value_number DESC, metric.name;

// 8. Why fine-tuning is needed
MATCH p =
  (:Evaluation {node_id:'EVAL_WEAKNESS'})
  -[:FINDS]->(:Finding)
  -[:IDENTIFIES]->(:FailureMode)
RETURN p;

// 9. Fine-tuning plan for the weak SOLAS LSA domain
MATCH p =
  (:Paper {node_id:'PAPER_MARITIME_MOE'})
  -[:HAS_CONTRIBUTION]->(:ResearchContribution {node_id:'CONTRIB_FINETUNING'})
  -[:INTRODUCES]->(:Dataset {node_id:'DATA_TARGETED_QA'})
  <-[:USES_DATA]-(:FineTuningPlan)
  -[:TARGETS]->(:Domain {node_id:'DOMAIN_SOLAS_LSA'})
RETURN p;

// 10. Shortest path from thesis to OpenAI fine-tuned model activation
MATCH p = shortestPath(
  (:Paper {node_id:'PAPER_MARITIME_MOE'})-[*..8]-(:FineTuningPlan {node_id:'PLAN_OPENAI_FINETUNE'})
)
RETURN p;

// 11. RAG source path from system to maritime regulations
MATCH p =
  (:System {node_id:'SYSTEM_MARITIME_MOE'})
  -[:USES_COMPONENT]->(:Component {node_id:'COMP_RAG_RETRIEVAL'})
  -[:IMPLEMENTED_BY]->(:Tool {node_id:'TOOL_CHROMADB'})
RETURN p;

MATCH p =
  (:Dataset {node_id:'DATA_REGULATION_CHUNKS'})
  -[:COVERS]->(:Regulation)
RETURN p;

// 12. User-facing operational scenarios supported by the thesis system
MATCH (:System {node_id:'SYSTEM_MARITIME_MOE'})-[:SUPPORTS_SCENARIO]->(scenario:UserScenario)
RETURN
  scenario.name AS scenario,
  scenario.user AS target_user
ORDER BY scenario.name;

// 13. One compact graph for assignment screenshot
MATCH p =
  (:Paper {node_id:'PAPER_MARITIME_MOE'})
  -[*1..4]-
  (:FineTuningPlan {node_id:'PLAN_LSA_FIRE_FINETUNE'})
RETURN p
LIMIT 30;
