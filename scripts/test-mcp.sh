#!/usr/bin/env bash
set -euo pipefail

GENE_SET_MCP_URL="${GENE_SET_MCP_URL:-https://translator.broadinstitute.org/genetics_provider/mcp_geneset}"
GENE_SET_MCP_BEARER_TOKEN="${GENE_SET_MCP_BEARER_TOKEN:-change-me}"

echo "[test-mcp] GET ${GENE_SET_MCP_URL}"
curl --silent --show-error --location \
  --output /tmp/gene-set-mcp-get.out \
  --write-out "[test-mcp] HTTP %{http_code}\n" \
  "$GENE_SET_MCP_URL"

echo "[test-mcp] POST tools/list"
curl --silent --show-error --location \
  -H "Authorization: Bearer ${GENE_SET_MCP_BEARER_TOKEN}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -d '{"jsonrpc":"2.0","id":"tools-list","method":"tools/list","params":{}}' \
  "$GENE_SET_MCP_URL"

printf '\n'
