---
name: gene-set-provenance
description: Use this skill for gene set provenance, source datasets, gene membership, overlap searches, Pigean phenotype associations, graph neighborhoods, and evidence-backed interpretation from the gene set MCP server.
---

# gene-set-provenance

Use this skill when the user asks about gene set provenance, source datasets, gene membership, overlap, Pigean phenotype associations, graph neighborhoods, or evidence behind a gene set or gene.

## Goals

- Ground answers in MCP data instead of assumptions.
- Keep tool calls compact because the remote server is rate-limited.
- Return provenance in a form that is easy to inspect and cite.

## Recommended Tool Order

1. `search_gene_sets`
   Use when the user gives a free-text or partial gene set name.
2. `get_gene_set`
   Use after identifying the target gene set.
3. `get_pigean_gene_set`
   Use after identifying a gene set when the user wants phenotype associations for that gene set.
4. `get_provenance`
   Use for provenance graph and source metadata.
5. `find_gene_sets_by_gene`
   Use when the user starts from genes instead of a gene set.
6. `get_pigean_gene`
   Use when the user starts from a gene and wants phenotype associations for that gene.
7. `get_graph_neighborhood`
   Use for adjacent entities and relationship summaries.

## Workflow

1. Resolve the exact gene set identifier or standard name.
2. Fetch the gene set itself before discussing provenance.
3. If phenotype-association context is relevant, fetch Pigean associations for the resolved gene set.
4. Fetch provenance separately and distinguish:
   - core gene set fields
   - Pigean phenotype associations
   - provenance graph
   - provenance metadata
5. If the user starts from genes, use `find_gene_sets_by_gene` before broader neighborhood exploration.
6. If the user asks for gene-level phenotype associations, use `get_pigean_gene`.
7. If the user asks for overlap or neighborhood context, run the smallest relevant follow-up query.

## Output Pattern

- `Gene set`: standard name, identifier, organism, library if present
- `Pigean gene set associations`: phenotype, beta, beta_uncorrected, rs_score if returned
- `Provenance`: source dataset, method, contrast, tissue, pipeline, or other linked entities if returned
- `Pigean gene associations`: phenotype, phenotype_name, combined, label if returned
- `Evidence`: direct fields returned by the server
- `Interpretation`: concise explanation of what the provenance implies

## Guardrails

- Do not infer causal biology from provenance alone.
- Do not infer causality or disease relevance from Pigean scores alone.
- Do not claim fields exist if the tool response omits them.
- If multiple gene sets match, present candidates before continuing.
- If the tool output is truncated, say so and avoid overclaiming.
