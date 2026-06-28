# Gene Set Codex Demo

This repository is a self-contained demo workspace for using Codex with a remote gene set MCP server.

The demo targets this streamable HTTP MCP endpoint:

- `https://translator.broadinstitute.org/genetics_provider/mcp_geneset`

Server assumptions baked into this repo:

- Read-only MCP tools
- Bearer token auth
- Default demo token: `change-me`
- Remote rate limits

## Quick Start

```bash
git clone https://github.com/YOUR-ORG/gene-set-codex-demo.git
cd gene-set-codex-demo
./setup-demo.sh
codex
```

`./setup-demo.sh` will:

- check for `codex`
- install it with `npm` if needed
- register the remote MCP server with `codex mcp add`
- set the bearer token env var in your shell profile if missing
- print a verification command

If Codex itself is not authenticated yet, run:

```bash
codex login
```

## What Users Get

- `AGENTS.md` with repo-specific guidance for Codex
- `.agents/skills/gene-set-provenance/SKILL.md` for provenance-oriented workflows
- `.codex/config.toml.example` showing the MCP config shape
- `examples/prompts.md` and `examples/expected-results.md`
- `.devcontainer/` for GitHub Codespaces and local dev containers

## MCP Configuration

The bootstrap script registers this MCP server name:

- `gene-set-demo`

It maps to the following Codex config shape:

```toml
[mcp_servers.gene-set-demo]
url = "https://translator.broadinstitute.org/genetics_provider/mcp_geneset"
bearer_token_env_var = "GENE_SET_MCP_BEARER_TOKEN"
```

The repo includes that snippet in [.codex/config.toml.example](/Users/mduby/Code/DccWorkspace/CodexGeneSetExtractorDemo/.codex/config.toml.example).

## Environment Variables

- `GENE_SET_MCP_URL`
  Default: `https://translator.broadinstitute.org/genetics_provider/mcp_geneset`
- `GENE_SET_MCP_BEARER_TOKEN`
  Default demo value: `change-me`

You can override either before running setup:

```bash
export GENE_SET_MCP_BEARER_TOKEN="change-me"
export GENE_SET_MCP_URL="https://translator.broadinstitute.org/genetics_provider/mcp_geneset"
./setup-demo.sh
```

## Test The Remote Server

Run:

```bash
./scripts/test-mcp.sh
```

That script performs:

- a lightweight `GET` reachability check
- an authenticated JSON-RPC `tools/list` request

## GitHub Codespaces

Open the repo in Codespaces and the devcontainer will:

- install Node.js, `npm`, `jq`, `curl`, and `git`
- install `@openai/codex`
- run the bootstrap script automatically

After the Codespace is ready:

```bash
codex login
codex
```

If you need to re-run setup inside Codespaces:

```bash
./setup-demo.sh
```

## Notes

- The remote service is rate-limited. Keep prompts focused and avoid unnecessary repeated tool calls.
- This repo assumes the `genetics_provider/mcp_geneset` URL is the active endpoint. If your environment uses a different host path, set `GENE_SET_MCP_URL` before bootstrap.
