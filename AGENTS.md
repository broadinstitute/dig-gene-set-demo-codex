# AGENTS.md

## Purpose

This repository is a demo workspace for Codex users connecting to a remote gene set MCP server.

## Default Workflow

1. Use the `gene-set-provenance` skill for provenance, source, overlap, and graph-neighborhood requests.
2. Prefer MCP tool calls over guessing when the answer depends on server data.
3. Keep tool usage efficient because the remote MCP server is rate-limited.

## MCP Expectations

- Server name: `gene-set-demo`
- Transport: streamable HTTP
- Auth: bearer token from `GENE_SET_MCP_BEARER_TOKEN`
- Data access is read-only

## Response Style

- Be explicit about which MCP tool was used.
- Separate direct MCP results from interpretation.
- If provenance is missing or partial, say that clearly.

## Guardrails

- Do not invent gene set metadata, provenance, or graph relationships.
- Do not suggest write operations; the MCP server is read-only.
- If a request would need many broad searches, narrow the query first.
