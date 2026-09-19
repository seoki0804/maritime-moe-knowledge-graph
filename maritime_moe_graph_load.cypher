// =========================================================
// Assignment 4
// Maritime MoE Thesis Knowledge Graph
// Recommended database: assignment4
// =========================================================
// This script clears the active Neo4j database.
// Run it only in a dedicated assignment database.

MATCH (n) DETACH DELETE n;

CREATE CONSTRAINT kg_node_id_unique IF NOT EXISTS
FOR (n:KGNode) REQUIRE n.node_id IS UNIQUE;

// ---------------------------------------------------------
// Paper and thesis-level entities
// ---------------------------------------------------------

UNWIND [
  {
    node_id:'PAPER_MARITIME_MOE',
    title:'Maritime MoE: Domain-Specific Mixture-of-Experts for Maritime Regulatory Compliance',
    author:'Seoki',
    year:2026,
    source:'maritime_AI/KOREAN_ABSTRACT.md',
    summary:'A maritime domain-specific MoE and RAG system for fast, accurate regulatory question answering.'
  }
] AS row
MERGE (n:KGNode:Paper {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'SYSTEM_MARITIME_MOE', name:'Maritime MoE System', summary:'Routes maritime questions to specialized experts and augments answers with regulatory retrieval.'}
] AS row
MERGE (n:KGNode:System {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'CONTRIB_MMLU', name:'Maritime MMLU-1K Benchmark', summary:'Benchmark for evaluating maritime AI systems across regulatory domains.'},
  {node_id:'CONTRIB_ROUTING', name:'Domain Expert Routing Architecture', summary:'Keyword-based routing to maritime experts for interpretable question handling.'},
  {node_id:'CONTRIB_EVALUATION', name:'Empirical Validation', summary:'Compares baseline LLM, RAG, and routed expert settings.'},
  {node_id:'CONTRIB_FINETUNING', name:'Fine-tuning Improvement Plan', summary:'Targets weak numerical and safety-critical domains with synthetic and targeted maritime QA.'}
] AS row
MERGE (n:KGNode:ResearchContribution {node_id: row.node_id})
SET n += row;

// ---------------------------------------------------------
// Methods, components, and implementation tools
// ---------------------------------------------------------

UNWIND [
  {node_id:'METHOD_MOE', name:'Mixture-of-Experts', category:'Architecture', summary:'Specialized experts are selected based on query domain.'},
  {node_id:'METHOD_RAG', name:'Retrieval-Augmented Generation', category:'Retrieval', summary:'Retrieves regulation chunks before answer generation.'},
  {node_id:'METHOD_KEYWORD_ROUTING', name:'Keyword-based Routing', category:'Routing', summary:'Uses maritime keyword patterns to assign a query to an expert.'},
  {node_id:'METHOD_FINETUNING', name:'Fine-tuning', category:'Training', summary:'Adapts a base model to maritime regulatory QA examples.'},
  {node_id:'METHOD_BENCHMARKING', name:'Benchmark Evaluation', category:'Evaluation', summary:'Measures accuracy and failure modes on Maritime MMLU questions.'}
] AS row
MERGE (n:KGNode:Method {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'ROUTER_KEYWORD', name:'MOE Router', patterns:'100+ maritime keyword patterns', fallback:'general maritime expert'},
  {node_id:'COMP_CHAT_SERVICE', name:'Chat Service', role:'orchestrates retrieval, tools, and model inference'},
  {node_id:'COMP_AGENT_TOOLS', name:'Agent Tools', role:'supports calculation, web search, and impact analysis'},
  {node_id:'COMP_RAG_RETRIEVAL', name:'RAG Retrieval Layer', role:'searches regulation chunks from vector database'},
  {node_id:'COMP_LLM_INFERENCE', name:'LLM Inference Layer', role:'generates final answer with routed prompt and retrieved context'}
] AS row
MERGE (n:KGNode:Component {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'TOOL_CHROMADB', name:'ChromaDB', category:'Vector Store'},
  {node_id:'TOOL_BGE_M3', name:'BGE-M3', category:'Embedding Model'},
  {node_id:'TOOL_OPENAI_API', name:'OpenAI API', category:'Model Platform'},
  {node_id:'TOOL_GPT4O', name:'GPT-4o', category:'LLM'},
  {node_id:'TOOL_GPT4O_MINI', name:'gpt-4o-mini', category:'Fine-tuning Base Model'},
  {node_id:'TOOL_FASTAPI', name:'FastAPI', category:'Backend'},
  {node_id:'TOOL_POSTGRES', name:'PostgreSQL', category:'Persistence'},
  {node_id:'TOOL_REDIS', name:'Redis Cache', category:'Cache'},
  {node_id:'TOOL_NEO4J', name:'Neo4j', category:'Knowledge Graph'}
] AS row
MERGE (n:KGNode:Tool {node_id: row.node_id})
SET n += row;

// ---------------------------------------------------------
// Maritime experts, domains, and regulations
// ---------------------------------------------------------

UNWIND [
  {node_id:'EXPERT_REGULATION', name:'Regulation Expert', scope:'general maritime regulations'},
  {node_id:'EXPERT_SAFETY_LEGAL', name:'Safety Management and Legal Expert', scope:'ISM, audits, legal and management requirements'},
  {node_id:'EXPERT_LSA_FIRE', name:'Life-saving and Fire Expert', scope:'SOLAS LSA and fire safety'},
  {node_id:'EXPERT_CARGO_STABILITY', name:'Cargo and Stability Expert', scope:'cargo, stability, load line, dangerous goods'},
  {node_id:'EXPERT_COMMUNICATION', name:'Communication Expert', scope:'GMDSS, DSC, EPIRB, SART'},
  {node_id:'EXPERT_MACHINERY', name:'Machinery Expert', scope:'engine, electrical, maintenance'},
  {node_id:'EXPERT_NAVIGATION', name:'Navigation Expert', scope:'COLREGs, bridge procedure, navigation safety'},
  {node_id:'EXPERT_ENVIRONMENT', name:'Environment Expert', scope:'MARPOL and pollution prevention'}
] AS row
MERGE (n:KGNode:Expert {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'DOMAIN_SOLAS_LSA', name:'SOLAS Life-Saving Appliances', category:'Safety-critical'},
  {node_id:'DOMAIN_SOLAS_FIRE', name:'SOLAS Fire Protection', category:'Safety-critical'},
  {node_id:'DOMAIN_ISM', name:'ISM Code Safety Management', category:'Management'},
  {node_id:'DOMAIN_COLREGS', name:'COLREGs Steering and Sailing Rules', category:'Navigation'},
  {node_id:'DOMAIN_MARPOL', name:'MARPOL Environmental Protection', category:'Environment'},
  {node_id:'DOMAIN_STCW', name:'STCW Training and Certification', category:'Crew'},
  {node_id:'DOMAIN_CARGO_STABILITY', name:'Cargo and Stability', category:'Operations'},
  {node_id:'DOMAIN_GMDSS', name:'GMDSS Communication', category:'Communication'},
  {node_id:'DOMAIN_MACHINERY', name:'Machinery and Electrical Systems', category:'Engineering'},
  {node_id:'DOMAIN_DANGEROUS_GOODS', name:'Dangerous Goods', category:'Cargo'}
] AS row
MERGE (n:KGNode:Domain {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'REG_SOLAS', name:'SOLAS', full_name:'International Convention for the Safety of Life at Sea'},
  {node_id:'REG_MARPOL', name:'MARPOL', full_name:'International Convention for the Prevention of Pollution from Ships'},
  {node_id:'REG_COLREGS', name:'COLREGs', full_name:'International Regulations for Preventing Collisions at Sea'},
  {node_id:'REG_STCW', name:'STCW', full_name:'Standards of Training, Certification and Watchkeeping'},
  {node_id:'REG_ISM', name:'ISM Code', full_name:'International Safety Management Code'},
  {node_id:'REG_LSA', name:'LSA Code', full_name:'International Life-Saving Appliance Code'},
  {node_id:'REG_FSS', name:'FSS Code', full_name:'International Code for Fire Safety Systems'},
  {node_id:'REG_IMDG', name:'IMDG Code', full_name:'International Maritime Dangerous Goods Code'},
  {node_id:'REG_IMSBC', name:'IMSBC Code', full_name:'International Maritime Solid Bulk Cargoes Code'}
] AS row
MERGE (n:KGNode:Regulation {node_id: row.node_id})
SET n += row;

// ---------------------------------------------------------
// Data, evaluation, metrics, findings, and fine-tuning plans
// ---------------------------------------------------------

UNWIND [
  {node_id:'DATA_MMLU_1K', name:'Maritime MMLU-1K', item_count:1045, unit:'multiple-choice questions', source:'KOREAN_ABSTRACT.md'},
  {node_id:'DATA_CLEAN_MMLU_LOCAL', name:'Local Clean Maritime MMLU Artifact', item_count:1038, unit:'clean questions', source:'ml/benchmark/data/maritime_mmlu_1k_clean.json'},
  {node_id:'DATA_REGULATION_CHUNKS', name:'Regulation Document Chunks', item_count:203, unit:'chunks', source:'KOREAN_ABSTRACT.md'},
  {node_id:'DATA_TARGETED_QA', name:'Targeted Fine-tuning QA', item_count:1803, unit:'synthetic QA pairs', source:'ml/data/training/synthetic/targeted'},
  {node_id:'DATA_INSTRUCT_JSONL', name:'maritime_instruct.jsonl', item_count:120, unit:'instruction examples', source:'ml/data/training/final/instruction_format/maritime_instruct.jsonl'}
] AS row
MERGE (n:KGNode:Dataset {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'ARTIFACT_KOREAN_ABSTRACT', name:'Korean Thesis Abstract', path:'maritime_AI/KOREAN_ABSTRACT.md'},
  {node_id:'ARTIFACT_FINETUNE_WORKFLOW', name:'Fine-tuned Maritime LLM Workflow', path:'maritime_AI/FINE_TUNED_MARITIME_LLM.md'},
  {node_id:'ARTIFACT_ARCHITECTURE', name:'System Architecture Diagram', path:'paper/artifacts/system_architecture_diagram.md'},
  {node_id:'ARTIFACT_FAILURE_TAXONOMY', name:'Failure Taxonomy', path:'paper/artifacts/failure_taxonomy.json'},
  {node_id:'ARTIFACT_BIBLIOGRAPHY', name:'Paper Bibliography', path:'paper/references/bibliography.bib'}
] AS row
MERGE (n:KGNode:DataArtifact {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'EVAL_BASELINE', name:'GPT-4 Baseline Evaluation', mode:'baseline'},
  {node_id:'EVAL_MOE_RAG', name:'Maritime MoE + RAG Evaluation', mode:'routed_moe_rag'},
  {node_id:'EVAL_WEAKNESS', name:'Weakness and Error Analysis', mode:'failure_analysis'},
  {node_id:'EVAL_FINETUNE_READINESS', name:'Fine-tuning Readiness Check', mode:'training_data_review'}
] AS row
MERGE (n:KGNode:Evaluation {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'METRIC_BASELINE_ACC', name:'Baseline Accuracy', value_number:55.3, value_text:'55.3%', unit:'percent'},
  {node_id:'METRIC_MOE_ACC', name:'Maritime MoE Accuracy', value_number:76.4, value_text:'76.4%', unit:'percent'},
  {node_id:'METRIC_DELTA_ACC', name:'Accuracy Improvement', value_number:21.1, value_text:'+21.1 percentage points', unit:'percentage points'},
  {node_id:'METRIC_ISM_GAIN', name:'ISM Code Improvement', value_number:46.0, value_text:'+46 percentage points', unit:'percentage points'},
  {node_id:'METRIC_COLREGS_GAIN', name:'COLREGs Steering Improvement', value_number:40.0, value_text:'+40 percentage points', unit:'percentage points'},
  {node_id:'METRIC_SOLAS_LSA_ACC', name:'SOLAS LSA Accuracy', value_number:46.0, value_text:'46%', unit:'percent'},
  {node_id:'METRIC_LOOKUP_TIME', name:'Regulation Lookup Time', value_number:1.0, value_text:'about 1 minute', unit:'minute'}
] AS row
MERGE (n:KGNode:Metric {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'FINDING_RAG_TEXT', name:'RAG helps textual interpretation', summary:'Retrieval is useful for regulatory explanation and citation context.'},
  {node_id:'FINDING_NUMERIC_LIMIT', name:'RAG is limited for numerical calculation', summary:'Numerical requirements need structured extraction or fine-tuning.'},
  {node_id:'FINDING_ROUTING_INTERPRETABLE', name:'Keyword routing is interpretable', summary:'Domain routing can be inspected and debugged in operational settings.'},
  {node_id:'FINDING_SAMPLE_BIAS', name:'Small sample evaluation bias', summary:'Small samples can differ strongly from full-domain evaluation.'},
  {node_id:'FINDING_LSA_WEAKNESS', name:'SOLAS LSA weakness', summary:'Life-saving appliance questions expose numerical precision weakness.'}
] AS row
MERGE (n:KGNode:Finding {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'FAIL_NUMERIC_PRECISION', name:'Numerical Precision Failure', summary:'Wrong exact number, interval, capacity, or calculation.'},
  {node_id:'FAIL_RETRIEVAL_MISS', name:'Retrieval Miss', summary:'Relevant regulation chunk is not retrieved.'},
  {node_id:'FAIL_ROUTING', name:'Routing Failure', summary:'Query is assigned to the wrong maritime expert.'},
  {node_id:'FAIL_REASONING', name:'Reasoning Failure', summary:'Model retrieves context but selects or derives the wrong answer.'},
  {node_id:'FAIL_PARSER', name:'Parser Failure', summary:'Answer parsing or option extraction fails during evaluation.'}
] AS row
MERGE (n:KGNode:FailureMode {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'PLAN_LSA_FIRE_FINETUNE', name:'LSA and Fire Targeted Fine-tuning', priority:'P0', summary:'Generate hard numerical QA for SOLAS Ch.III, LSA Code, SOLAS Ch.II-2, and FSS Code.'},
  {node_id:'PLAN_STABILITY_FINETUNE', name:'Stability and Cargo Fine-tuning', priority:'P1', summary:'Train on stability, load line, grain code, and cargo calculation questions.'},
  {node_id:'PLAN_DG_FINETUNE', name:'Dangerous Goods Fine-tuning', priority:'P1', summary:'Train on IMDG, IMSBC, segregation, EmS, TML, and FMP cases.'},
  {node_id:'PLAN_COMM_FINETUNE', name:'GMDSS Communication Fine-tuning', priority:'P2', summary:'Train on DSC, EPIRB, SART, and sea area equipment requirements.'},
  {node_id:'PLAN_OPENAI_FINETUNE', name:'OpenAI Fine-tuned Maritime LLM', priority:'Implementation', summary:'Create a fine-tuning job from maritime_instruct.jsonl using gpt-4o-mini.'}
] AS row
MERGE (n:KGNode:FineTuningPlan {node_id: row.node_id})
SET n += row;

UNWIND [
  {node_id:'SCENARIO_REG_QA', name:'Regulatory Q&A', user:'ship officer'},
  {node_id:'SCENARIO_PSC_CHECKLIST', name:'PSC Inspection Checklist', user:'ship manager'},
  {node_id:'SCENARIO_CERT_ALERT', name:'Certificate Expiry Alert', user:'fleet operator'},
  {node_id:'SCENARIO_INCIDENT_REPORT', name:'Incident Report Drafting', user:'maritime operator'},
  {node_id:'SCENARIO_SHIP_PROFILE', name:'Ship Profile Context Injection', user:'vessel superintendent'}
] AS row
MERGE (n:KGNode:UserScenario {node_id: row.node_id})
SET n += row;

// ---------------------------------------------------------
// Relationships
// ---------------------------------------------------------

UNWIND [
  {from:'PAPER_MARITIME_MOE', to:'SYSTEM_MARITIME_MOE', reason:'The thesis proposes the Maritime MoE system.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:PROPOSES]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PAPER_MARITIME_MOE', to:'CONTRIB_MMLU', reason:'Benchmark construction is a main contribution.'},
  {from:'PAPER_MARITIME_MOE', to:'CONTRIB_ROUTING', reason:'Expert routing is a core architecture contribution.'},
  {from:'PAPER_MARITIME_MOE', to:'CONTRIB_EVALUATION', reason:'The paper validates system performance empirically.'},
  {from:'PAPER_MARITIME_MOE', to:'CONTRIB_FINETUNING', reason:'Fine-tuning is proposed to improve weak numerical domains.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:HAS_CONTRIBUTION]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PAPER_MARITIME_MOE', to:'DATA_MMLU_1K', reason:'The paper introduces Maritime MMLU-1K.'},
  {from:'PAPER_MARITIME_MOE', to:'DATA_REGULATION_CHUNKS', reason:'The RAG system uses 203 regulation chunks.'},
  {from:'CONTRIB_FINETUNING', to:'DATA_TARGETED_QA', reason:'Targeted QA is used for fine-tuning weak experts.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'DATA_INSTRUCT_JSONL', reason:'OpenAI fine-tuning workflow uses maritime_instruct.jsonl.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:INTRODUCES]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PAPER_MARITIME_MOE', to:'METHOD_MOE', reason:'The system is based on an expert mixture.'},
  {from:'PAPER_MARITIME_MOE', to:'METHOD_RAG', reason:'The system integrates retrieval-augmented generation.'},
  {from:'PAPER_MARITIME_MOE', to:'METHOD_KEYWORD_ROUTING', reason:'The router uses interpretable maritime keyword patterns.'},
  {from:'PAPER_MARITIME_MOE', to:'METHOD_BENCHMARKING', reason:'The research evaluates model performance on a benchmark.'},
  {from:'CONTRIB_FINETUNING', to:'METHOD_FINETUNING', reason:'Fine-tuning is the improvement direction for weak domains.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:USES_METHOD]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'SYSTEM_MARITIME_MOE', to:'ROUTER_KEYWORD', reason:'The system first routes each user query.'},
  {from:'SYSTEM_MARITIME_MOE', to:'COMP_CHAT_SERVICE', reason:'The chat service orchestrates the response.'},
  {from:'SYSTEM_MARITIME_MOE', to:'COMP_RAG_RETRIEVAL', reason:'Retrieved regulation evidence supports answers.'},
  {from:'SYSTEM_MARITIME_MOE', to:'COMP_AGENT_TOOLS', reason:'Tools support calculations and operational analysis.'},
  {from:'SYSTEM_MARITIME_MOE', to:'COMP_LLM_INFERENCE', reason:'The routed prompt is sent to model inference.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:USES_COMPONENT]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'COMP_RAG_RETRIEVAL', to:'TOOL_CHROMADB', reason:'Regulation chunks are stored in a vector database.'},
  {from:'COMP_RAG_RETRIEVAL', to:'TOOL_BGE_M3', reason:'BGE-M3 creates embeddings for retrieval.'},
  {from:'COMP_LLM_INFERENCE', to:'TOOL_GPT4O', reason:'GPT-4o is used as a routed generation model.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'TOOL_GPT4O_MINI', reason:'gpt-4o-mini is the fine-tuning base model in the workflow.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'TOOL_OPENAI_API', reason:'The job is created through the OpenAI API.'},
  {from:'SYSTEM_MARITIME_MOE', to:'TOOL_FASTAPI', reason:'FastAPI exposes the production API layer.'},
  {from:'SYSTEM_MARITIME_MOE', to:'TOOL_POSTGRES', reason:'PostgreSQL stores application data.'},
  {from:'SYSTEM_MARITIME_MOE', to:'TOOL_REDIS', reason:'Redis caches repeated interaction data.'},
  {from:'PAPER_MARITIME_MOE', to:'TOOL_NEO4J', reason:'This assignment maps the thesis as a knowledge graph.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:IMPLEMENTED_BY]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'ROUTER_KEYWORD', to:'EXPERT_REGULATION', reason:'General regulation questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_SAFETY_LEGAL', reason:'ISM, audit, and compliance management questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_LSA_FIRE', reason:'Life-saving and fire safety questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_CARGO_STABILITY', reason:'Cargo, stability, and dangerous goods questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_COMMUNICATION', reason:'GMDSS and radio communication questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_MACHINERY', reason:'Engine and electrical questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_NAVIGATION', reason:'COLREGs and navigation questions.'},
  {from:'ROUTER_KEYWORD', to:'EXPERT_ENVIRONMENT', reason:'MARPOL and pollution questions.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:ROUTES_TO]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'EXPERT_REGULATION', to:'DOMAIN_STCW', reason:'General regulation coverage.'},
  {from:'EXPERT_SAFETY_LEGAL', to:'DOMAIN_ISM', reason:'Safety management system questions.'},
  {from:'EXPERT_LSA_FIRE', to:'DOMAIN_SOLAS_LSA', reason:'LSA questions require safety equipment expertise.'},
  {from:'EXPERT_LSA_FIRE', to:'DOMAIN_SOLAS_FIRE', reason:'Fire protection questions require SOLAS II-2 and FSS knowledge.'},
  {from:'EXPERT_CARGO_STABILITY', to:'DOMAIN_CARGO_STABILITY', reason:'Cargo and stability calculations.'},
  {from:'EXPERT_CARGO_STABILITY', to:'DOMAIN_DANGEROUS_GOODS', reason:'Dangerous goods handling and segregation.'},
  {from:'EXPERT_COMMUNICATION', to:'DOMAIN_GMDSS', reason:'GMDSS equipment and distress communication.'},
  {from:'EXPERT_MACHINERY', to:'DOMAIN_MACHINERY', reason:'Machinery and electrical system expertise.'},
  {from:'EXPERT_NAVIGATION', to:'DOMAIN_COLREGS', reason:'Navigation rules and collision prevention.'},
  {from:'EXPERT_ENVIRONMENT', to:'DOMAIN_MARPOL', reason:'Pollution prevention and environmental rules.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:SPECIALIZES_IN]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'DOMAIN_SOLAS_LSA', to:'REG_SOLAS', reason:'SOLAS Chapter III governs life-saving appliances.'},
  {from:'DOMAIN_SOLAS_LSA', to:'REG_LSA', reason:'LSA Code defines appliance specifications.'},
  {from:'DOMAIN_SOLAS_FIRE', to:'REG_SOLAS', reason:'SOLAS Chapter II-2 governs fire protection.'},
  {from:'DOMAIN_SOLAS_FIRE', to:'REG_FSS', reason:'FSS Code defines fire safety systems.'},
  {from:'DOMAIN_ISM', to:'REG_ISM', reason:'ISM Code governs safety management.'},
  {from:'DOMAIN_COLREGS', to:'REG_COLREGS', reason:'COLREGs define steering and sailing rules.'},
  {from:'DOMAIN_MARPOL', to:'REG_MARPOL', reason:'MARPOL governs marine pollution prevention.'},
  {from:'DOMAIN_STCW', to:'REG_STCW', reason:'STCW governs crew training and certification.'},
  {from:'DOMAIN_DANGEROUS_GOODS', to:'REG_IMDG', reason:'IMDG Code governs dangerous goods by sea.'},
  {from:'DOMAIN_DANGEROUS_GOODS', to:'REG_IMSBC', reason:'IMSBC Code governs solid bulk cargoes.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:GOVERNED_BY]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'DATA_MMLU_1K', to:'DOMAIN_SOLAS_LSA', reason:'Benchmark includes SOLAS LSA questions.'},
  {from:'DATA_MMLU_1K', to:'DOMAIN_SOLAS_FIRE', reason:'Benchmark includes fire protection questions.'},
  {from:'DATA_MMLU_1K', to:'DOMAIN_ISM', reason:'Benchmark includes ISM Code questions.'},
  {from:'DATA_MMLU_1K', to:'DOMAIN_COLREGS', reason:'Benchmark includes COLREGs questions.'},
  {from:'DATA_MMLU_1K', to:'DOMAIN_MARPOL', reason:'Benchmark includes MARPOL questions.'},
  {from:'DATA_MMLU_1K', to:'DOMAIN_STCW', reason:'Benchmark includes STCW questions.'},
  {from:'DATA_REGULATION_CHUNKS', to:'REG_SOLAS', reason:'Regulation chunks include SOLAS material.'},
  {from:'DATA_REGULATION_CHUNKS', to:'REG_MARPOL', reason:'Regulation chunks include MARPOL material.'},
  {from:'DATA_REGULATION_CHUNKS', to:'REG_COLREGS', reason:'Regulation chunks include COLREGs material.'},
  {from:'DATA_REGULATION_CHUNKS', to:'REG_ISM', reason:'Regulation chunks include ISM material.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:COVERS]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'DATA_MMLU_1K', to:'EVAL_BASELINE', reason:'Baseline is evaluated on Maritime MMLU-1K.'},
  {from:'DATA_MMLU_1K', to:'EVAL_MOE_RAG', reason:'Routed MoE + RAG is evaluated on Maritime MMLU-1K.'},
  {from:'DATA_MMLU_1K', to:'EVAL_WEAKNESS', reason:'Weakness analysis identifies domain-level gaps.'},
  {from:'DATA_TARGETED_QA', to:'EVAL_FINETUNE_READINESS', reason:'Training data is reviewed before fine-tuning.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:EVALUATES]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'EVAL_BASELINE', to:'METRIC_BASELINE_ACC', reason:'Baseline accuracy reported in thesis abstract.'},
  {from:'EVAL_MOE_RAG', to:'METRIC_MOE_ACC', reason:'Maritime MoE accuracy reported in thesis abstract.'},
  {from:'EVAL_MOE_RAG', to:'METRIC_DELTA_ACC', reason:'Accuracy improvement over baseline.'},
  {from:'EVAL_MOE_RAG', to:'METRIC_ISM_GAIN', reason:'Domain gain on ISM Code.'},
  {from:'EVAL_MOE_RAG', to:'METRIC_COLREGS_GAIN', reason:'Domain gain on COLREGs steering rules.'},
  {from:'EVAL_WEAKNESS', to:'METRIC_SOLAS_LSA_ACC', reason:'Weak domain metric for SOLAS LSA.'},
  {from:'SYSTEM_MARITIME_MOE', to:'METRIC_LOOKUP_TIME', reason:'Expected practical lookup time reduction.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:REPORTS_METRIC]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'EVAL_WEAKNESS', to:'FINDING_RAG_TEXT', reason:'RAG supports regulatory text interpretation.'},
  {from:'EVAL_WEAKNESS', to:'FINDING_NUMERIC_LIMIT', reason:'Numerical questions remain difficult.'},
  {from:'EVAL_WEAKNESS', to:'FINDING_ROUTING_INTERPRETABLE', reason:'Router decisions can be inspected.'},
  {from:'EVAL_WEAKNESS', to:'FINDING_SAMPLE_BIAS', reason:'Small samples can mislead evaluation.'},
  {from:'EVAL_WEAKNESS', to:'FINDING_LSA_WEAKNESS', reason:'SOLAS LSA is the key weak area.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:FINDS]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'FINDING_NUMERIC_LIMIT', to:'FAIL_NUMERIC_PRECISION', reason:'Exact regulatory numbers are the main weakness.'},
  {from:'FINDING_LSA_WEAKNESS', to:'FAIL_NUMERIC_PRECISION', reason:'LSA questions often need exact capacity and interval values.'},
  {from:'FINDING_LSA_WEAKNESS', to:'DOMAIN_SOLAS_LSA', reason:'Weakness is located in the SOLAS LSA domain.'},
  {from:'FINDING_RAG_TEXT', to:'FAIL_RETRIEVAL_MISS', reason:'RAG still fails when evidence is not retrieved.'},
  {from:'FINDING_ROUTING_INTERPRETABLE', to:'FAIL_ROUTING', reason:'Routing can be audited and improved.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:IDENTIFIES]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PLAN_LSA_FIRE_FINETUNE', to:'DOMAIN_SOLAS_LSA', reason:'The top fine-tuning target is SOLAS LSA.'},
  {from:'PLAN_LSA_FIRE_FINETUNE', to:'DOMAIN_SOLAS_FIRE', reason:'Fire protection is paired with LSA in targeted data.'},
  {from:'PLAN_STABILITY_FINETUNE', to:'DOMAIN_CARGO_STABILITY', reason:'Stability questions need numerical training.'},
  {from:'PLAN_DG_FINETUNE', to:'DOMAIN_DANGEROUS_GOODS', reason:'Dangerous goods questions need domain-specific cases.'},
  {from:'PLAN_COMM_FINETUNE', to:'DOMAIN_GMDSS', reason:'Communication questions need exact equipment requirements.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'FAIL_NUMERIC_PRECISION', reason:'Fine-tuning targets exact-value QA weaknesses.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'FAIL_REASONING', reason:'Instruction examples improve answer selection and reasoning.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:TARGETS]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PLAN_LSA_FIRE_FINETUNE', to:'DATA_TARGETED_QA', reason:'Uses generated hard QA for LSA and fire.'},
  {from:'PLAN_STABILITY_FINETUNE', to:'DATA_TARGETED_QA', reason:'Uses generated hard QA for stability.'},
  {from:'PLAN_DG_FINETUNE', to:'DATA_TARGETED_QA', reason:'Uses generated hard QA for dangerous goods.'},
  {from:'PLAN_COMM_FINETUNE', to:'DATA_TARGETED_QA', reason:'Uses generated hard QA for GMDSS.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'DATA_INSTRUCT_JSONL', reason:'Uses instruction-format data for the fine-tune job.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:USES_DATA]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PLAN_LSA_FIRE_FINETUNE', to:'EXPERT_LSA_FIRE', reason:'Improves the LSA and fire expert.'},
  {from:'PLAN_STABILITY_FINETUNE', to:'EXPERT_CARGO_STABILITY', reason:'Improves the cargo and stability expert.'},
  {from:'PLAN_DG_FINETUNE', to:'EXPERT_CARGO_STABILITY', reason:'Dangerous goods belongs to the cargo expert.'},
  {from:'PLAN_COMM_FINETUNE', to:'EXPERT_COMMUNICATION', reason:'Improves the communication expert.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'SYSTEM_MARITIME_MOE', reason:'Fine-tuned model can be activated in the backend.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:IMPROVES]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'SYSTEM_MARITIME_MOE', to:'SCENARIO_REG_QA', reason:'Primary thesis use case.'},
  {from:'SYSTEM_MARITIME_MOE', to:'SCENARIO_PSC_CHECKLIST', reason:'Practical operations extension.'},
  {from:'SYSTEM_MARITIME_MOE', to:'SCENARIO_CERT_ALERT', reason:'Phase 4 operations extension.'},
  {from:'SYSTEM_MARITIME_MOE', to:'SCENARIO_INCIDENT_REPORT', reason:'Report drafting extension.'},
  {from:'SYSTEM_MARITIME_MOE', to:'SCENARIO_SHIP_PROFILE', reason:'Ship context improves answer specificity.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:SUPPORTS_SCENARIO]->(b)
SET r.reason = row.reason;

UNWIND [
  {from:'PAPER_MARITIME_MOE', to:'ARTIFACT_KOREAN_ABSTRACT', reason:'Abstract summarizes the thesis.'},
  {from:'PLAN_OPENAI_FINETUNE', to:'ARTIFACT_FINETUNE_WORKFLOW', reason:'Workflow documents fine-tune job creation.'},
  {from:'SYSTEM_MARITIME_MOE', to:'ARTIFACT_ARCHITECTURE', reason:'Architecture artifact describes production flow.'},
  {from:'EVAL_WEAKNESS', to:'ARTIFACT_FAILURE_TAXONOMY', reason:'Failure taxonomy supports error analysis.'},
  {from:'PAPER_MARITIME_MOE', to:'ARTIFACT_BIBLIOGRAPHY', reason:'Bibliography links related work and regulations.'}
] AS row
MATCH (a:KGNode {node_id: row.from}), (b:KGNode {node_id: row.to})
MERGE (a)-[r:SUPPORTED_BY_ARTIFACT]->(b)
SET r.reason = row.reason;
