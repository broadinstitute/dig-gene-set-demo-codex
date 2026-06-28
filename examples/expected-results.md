# Expected Results

## Tool Listing

Users should be able to confirm that Codex can reach a remote MCP server named `gene-set-demo` and enumerate read-only tools such as:

- `search_gene_sets`
- `get_gene_set`
- `get_provenance`
- `find_gene_sets_by_gene`
- `get_graph_neighborhood`

## Provenance Questions

A good answer should:

- identify the resolved gene set clearly
- show provenance fields returned by the MCP server
- distinguish raw MCP output from interpretation
- avoid inventing missing metadata

## Gene-Based Search

A good answer should:

- explain which genes were used as input
- name the matching gene sets returned by the server
- describe overlap or relevance using only returned evidence

## Graph Neighborhood

A good answer should:

- identify the focal node
- summarize nearby nodes and edges compactly
- mention truncation or result limits if the server returns partial neighborhoods
