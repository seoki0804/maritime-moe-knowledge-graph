from __future__ import annotations

import math
from pathlib import Path

import matplotlib.pyplot as plt
import networkx as nx
import pandas as pd


ROOT = Path(__file__).resolve().parent
CAPTURE_DIR = ROOT / "captures"
FONT_NAME = "DejaVu Sans"


def save_table(df: pd.DataFrame, title: str, subtitle: str, filename: str) -> Path:
    rows = max(len(df), 1)
    fig_height = 2.2 + rows * 0.62
    fig, ax = plt.subplots(figsize=(13, fig_height))
    ax.axis("off")
    ax.set_title(title, fontsize=16, fontweight="bold", pad=24)
    ax.text(
        0.5,
        0.96,
        subtitle,
        transform=ax.transAxes,
        ha="center",
        va="center",
        fontsize=9,
        color="#334155",
        family=FONT_NAME,
    )

    table = ax.table(
        cellText=df.values,
        colLabels=df.columns,
        loc="center",
        cellLoc="center",
        colLoc="center",
    )
    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(1, 1.55)

    for (row, _), cell in table.get_celld().items():
        cell.set_edgecolor("#CBD5E1")
        if row == 0:
            cell.set_facecolor("#0F766E")
            cell.set_text_props(color="white", weight="bold", family=FONT_NAME)
        else:
            cell.set_facecolor("#F8FAFC" if row % 2 else "#ECFDF5")
            cell.set_text_props(color="#0F172A", family=FONT_NAME)

    fig.tight_layout()
    output = CAPTURE_DIR / filename
    fig.savefig(output, dpi=220, bbox_inches="tight")
    plt.close(fig)
    return output


def node_style(node_type: str) -> tuple[str, int]:
    styles = {
        "Paper": ("#2563EB", 4800),
        "System": ("#0F766E", 4800),
        "Method": ("#7C3AED", 4300),
        "Router": ("#F97316", 4300),
        "Expert": ("#DC2626", 4300),
        "Domain": ("#EA580C", 4300),
        "Regulation": ("#475569", 4100),
        "Dataset": ("#0891B2", 4300),
        "Metric": ("#16A34A", 4100),
        "Finding": ("#BE123C", 4300),
        "Failure": ("#991B1B", 4300),
        "Plan": ("#9333EA", 4500),
    }
    return styles.get(node_type, ("#64748B", 3900))


def draw_graph(
    nodes: list[tuple[str, str, str]],
    edges: list[tuple[str, str, str]],
    title: str,
    filename: str,
    seed: int = 42,
    fixed_pos: dict[str, tuple[float, float]] | None = None,
    xlim: tuple[float, float] | None = None,
    ylim: tuple[float, float] | None = None,
) -> Path:
    graph = nx.DiGraph()
    for node_id, label, node_type in nodes:
        graph.add_node(node_id, label=label, node_type=node_type)
    for source, target, relation in edges:
        graph.add_edge(source, target, relation=relation)

    pos = fixed_pos or nx.spring_layout(
        graph,
        seed=seed,
        k=1.55 / math.sqrt(max(len(graph.nodes), 1)),
        iterations=120,
    )

    fig, ax = plt.subplots(figsize=(16, 10))
    ax.set_title(title, fontsize=18, fontweight="bold", pad=18)
    ax.axis("off")

    for node_type in sorted({data["node_type"] for _, data in graph.nodes(data=True)}):
        nodelist = [
            node for node, data in graph.nodes(data=True) if data["node_type"] == node_type
        ]
        color, size = node_style(node_type)
        nx.draw_networkx_nodes(
            graph,
            pos,
            nodelist=nodelist,
            node_color=color,
            node_size=size,
            alpha=0.95,
            linewidths=1.7,
            edgecolors="white",
            ax=ax,
        )

    nx.draw_networkx_edges(
        graph,
        pos,
        edge_color="#94A3B8",
        width=1.8,
        alpha=0.72,
        arrows=True,
        arrowsize=18,
        arrowstyle="-|>",
        connectionstyle="arc3,rad=0.05",
        ax=ax,
    )

    nx.draw_networkx_labels(
        graph,
        pos,
        labels={node: data["label"] for node, data in graph.nodes(data=True)},
        font_size=9,
        font_weight="bold",
        font_family=FONT_NAME,
        font_color="white",
        ax=ax,
    )

    nx.draw_networkx_edge_labels(
        graph,
        pos,
        edge_labels={(u, v): d["relation"] for u, v, d in graph.edges(data=True)},
        font_size=7,
        font_family=FONT_NAME,
        rotate=False,
        bbox={"alpha": 0.88, "facecolor": "white", "pad": 0.15, "edgecolor": "none"},
        ax=ax,
    )

    if xlim:
        ax.set_xlim(*xlim)
    if ylim:
        ax.set_ylim(*ylim)

    fig.tight_layout()
    output = CAPTURE_DIR / filename
    fig.savefig(output, dpi=220, bbox_inches="tight")
    plt.close(fig)
    return output


def export_paper_graph() -> Path:
    nodes = [
        ("paper", "Paper", "Paper"),
        ("system", "System", "System"),
        ("mmlu", "MMLU-1K", "Dataset"),
        ("chunks", "203\nChunks", "Dataset"),
        ("rag", "RAG", "Method"),
        ("router", "Router", "Router"),
        ("lsa", "LSA\nExpert", "Expert"),
        ("nav", "Nav\nExpert", "Expert"),
        ("env", "Env\nExpert", "Expert"),
        ("solas", "SOLAS\nLSA", "Regulation"),
        ("colregs", "COLREGs", "Regulation"),
        ("marpol", "MARPOL", "Regulation"),
        ("metric", "76.4%\n+21.1pp", "Metric"),
        ("plan", "Fine-\ntuning", "Plan"),
    ]
    edges = [
        ("paper", "system", "PROPOSES"),
        ("paper", "mmlu", "INTRODUCES"),
        ("paper", "metric", "CLAIMS"),
        ("system", "rag", "USES_METHOD"),
        ("rag", "chunks", "RETRIEVES"),
        ("system", "router", "USES_COMPONENT"),
        ("router", "lsa", "ROUTES_TO"),
        ("router", "nav", "ROUTES_TO"),
        ("router", "env", "ROUTES_TO"),
        ("lsa", "solas", "GOVERNED_BY"),
        ("nav", "colregs", "GOVERNED_BY"),
        ("env", "marpol", "GOVERNED_BY"),
        ("paper", "plan", "HAS_CONTRIBUTION"),
        ("plan", "lsa", "IMPROVES"),
    ]
    return draw_graph(
        nodes,
        edges,
        "Assignment 4 Capture 01: Paper-linked Maritime MoE Knowledge Graph",
        "capture_01_paper_linked_kg.png",
        fixed_pos={
            "paper": (0.0, 0.0),
            "system": (1.8, 0.0),
            "router": (3.6, -0.25),
            "rag": (3.2, 1.25),
            "chunks": (4.7, 1.6),
            "mmlu": (0.0, 1.35),
            "metric": (0.0, -1.25),
            "plan": (1.8, -1.25),
            "lsa": (5.5, 0.55),
            "nav": (5.5, -0.45),
            "env": (5.5, -1.45),
            "solas": (7.1, 0.55),
            "colregs": (7.1, -0.45),
            "marpol": (7.1, -1.45),
        },
        xlim=(-0.7, 7.8),
        ylim=(-2.05, 2.0),
    )


def export_metric_table() -> Path:
    rows = [
        {
            "Evaluation": "GPT-4 Baseline Evaluation",
            "Metric": "Baseline Accuracy",
            "Value": "55.3%",
            "Graph Meaning": "General LLM reference point",
        },
        {
            "Evaluation": "Maritime MoE + RAG Evaluation",
            "Metric": "Maritime MoE Accuracy",
            "Value": "76.4%",
            "Graph Meaning": "Domain-routed system result",
        },
        {
            "Evaluation": "Maritime MoE + RAG Evaluation",
            "Metric": "Accuracy Improvement",
            "Value": "+21.1pp",
            "Graph Meaning": "Gain over baseline",
        },
        {
            "Evaluation": "Weakness and Error Analysis",
            "Metric": "SOLAS LSA Accuracy",
            "Value": "46%",
            "Graph Meaning": "Fine-tuning target domain",
        },
        {
            "Evaluation": "System Practical Result",
            "Metric": "Regulation Lookup Time",
            "Value": "about 1 minute",
            "Graph Meaning": "Operational impact",
        },
    ]
    query = (
        "Cypher: MATCH (eval:Evaluation)-[:REPORTS_METRIC]->(metric:Metric) "
        "RETURN eval.name, metric.name, metric.value_text"
    )
    return save_table(
        pd.DataFrame(rows),
        "Assignment 4 Capture 02: Cypher Result - Thesis Metrics",
        query,
        "capture_02_cypher_metric_table.png",
    )


def export_finetuning_path() -> Path:
    nodes = [
        ("paper", "Paper", "Paper"),
        ("eval", "Weakness\nAnalysis", "Finding"),
        ("finding", "LSA\nWeakness", "Finding"),
        ("failure", "Numeric\nFailure", "Failure"),
        ("plan", "LSA Fire\nFine-tune", "Plan"),
        ("data", "Targeted QA\n1,803", "Dataset"),
        ("instruct", "Instruction\n120", "Dataset"),
        ("expert", "LSA\nExpert", "Expert"),
        ("domain", "SOLAS\nLSA", "Domain"),
        ("reg", "SOLAS III\nLSA Code", "Regulation"),
    ]
    edges = [
        ("paper", "eval", "EVALUATES"),
        ("eval", "finding", "FINDS"),
        ("finding", "failure", "IDENTIFIES"),
        ("finding", "domain", "LOCATED_IN"),
        ("domain", "reg", "GOVERNED_BY"),
        ("plan", "failure", "TARGETS"),
        ("plan", "domain", "TARGETS"),
        ("plan", "data", "USES_DATA"),
        ("plan", "instruct", "USES_DATA"),
        ("plan", "expert", "IMPROVES"),
        ("expert", "domain", "SPECIALIZES_IN"),
        ("paper", "plan", "HAS_CONTRIBUTION"),
    ]
    return draw_graph(
        nodes,
        edges,
        "Assignment 4 Capture 03: Weakness Analysis to Fine-tuning Path",
        "capture_03_finetuning_path.png",
        seed=19,
        fixed_pos={
            "paper": (0.0, 0.0),
            "eval": (1.4, 0.0),
            "finding": (2.8, 0.65),
            "failure": (4.2, 0.65),
            "plan": (5.6, 0.0),
            "data": (7.2, 0.85),
            "instruct": (7.2, -0.85),
            "expert": (4.2, -1.0),
            "domain": (2.8, -1.0),
            "reg": (1.4, -1.0),
        },
        xlim=(-0.7, 7.9),
        ylim=(-1.65, 1.35),
    )


def main() -> None:
    CAPTURE_DIR.mkdir(parents=True, exist_ok=True)
    outputs = [
        export_paper_graph(),
        export_metric_table(),
        export_finetuning_path(),
    ]
    print("Generated captures:")
    for output in outputs:
        print(f"- {output}")


if __name__ == "__main__":
    main()
