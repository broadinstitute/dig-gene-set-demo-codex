# gene-set-provenance

Use this skill when the user asks about gene set provenance, source datasets, gene membership, overlap, graph neighborhoods, or evidence behind a gene set.

## Goals

- Ground answers in MCP data instead of assumptions.
- Keep tool calls compact because the remote server is rate-limited.
- Return provenance in a form that is easy to inspect and cite.

## Recommended Tool Order

1. `search_gene_sets`
   Use when the user gives a free-text or partial gene set name.
2. `get_gene_set`
   Use after identifying the target gene set.
3. `get_provenance`
   Use for provenance graph and source metadata.
4. `find_gene_sets_by_gene`
   Use when the user starts from genes instead of a gene set.
5. `get_graph_neighborhood`
   Use for adjacent entities and relationship summaries.

## Workflow

1. Resolve the exact gene set identifier or standard name.
2. Fetch the gene set itself before discussing provenance.
3. Fetch provenance separately and distinguish:
   - core gene set fields
   - provenance graph
   - provenance metadata
4. If the user asks for overlap or neighborhood context, run the smallest relevant follow-up query.

## Output Pattern

- `Gene set`: standard name, identifier, organism, library if present
- `Provenance`: source dataset, method, contrast, tissue, pipeline, or other linked entities if returned
- `Evidence`: direct fields returned by the server
- `Interpretation`: concise explanation of what the provenance implies

## Guardrails

- Do not infer causal biology from provenance alone.
- Do not claim fields exist if the tool response omits them.
- If multiple gene sets match, present candidates before continuing.
- If the tool output is truncated, say so and avoid overclaiming.
