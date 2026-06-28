#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MCP_NAME="${MCP_NAME:-gene-set-demo}"
GENE_SET_MCP_URL="${GENE_SET_MCP_URL:-https://translator.broadinstitute.org/genetics_provider/mcp_geneset/mcp?stream=1}"
GENE_SET_MCP_BEARER_TOKEN="${GENE_SET_MCP_BEARER_TOKEN:-change-me}"
TOKEN_ENV_VAR="GENE_SET_MCP_BEARER_TOKEN"
CODEX_HOME_DIR="${CODEX_HOME:-$HOME/.codex}"
SKIP_INSTALL=0

for arg in "$@"; do
  case "$arg" in
    --skip-install)
      SKIP_INSTALL=1
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      exit 1
      ;;
  esac
done

log() {
  printf '[setup-demo] %s\n' "$1"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

append_token_export() {
  local shell_rc
  shell_rc="$HOME/.bashrc"

  if [ -n "${ZSH_VERSION:-}" ] || [ "${SHELL:-}" = "/bin/zsh" ] || [ "${SHELL:-}" = "/usr/bin/zsh" ]; then
    shell_rc="$HOME/.zshrc"
  fi

  if ! mkdir -p "$(dirname "$shell_rc")" 2>/dev/null; then
    log "Skipping shell profile update; cannot create $(dirname "$shell_rc")"
    return
  fi

  if ! touch "$shell_rc" 2>/dev/null; then
    log "Skipping shell profile update; cannot write ${shell_rc}"
    return
  fi

  if ! grep -Fq "export ${TOKEN_ENV_VAR}=" "$shell_rc"; then
    {
      printf '\n'
      printf '# Gene Set Codex Demo MCP token\n'
      printf 'export %s="%s"\n' "$TOKEN_ENV_VAR" "$GENE_SET_MCP_BEARER_TOKEN"
    } >>"$shell_rc"
    log "Added ${TOKEN_ENV_VAR} to ${shell_rc}"
  else
    log "${TOKEN_ENV_VAR} already present in ${shell_rc}"
  fi
}

ensure_codex() {
  if need_cmd codex; then
    log "Found codex: $(codex --version 2>/dev/null || echo unknown)"
    return
  fi

  if [ "$SKIP_INSTALL" -eq 1 ]; then
    echo "codex is not installed and --skip-install was provided." >&2
    exit 1
  fi

  if ! need_cmd npm; then
    echo "npm is required to install codex automatically." >&2
    exit 1
  fi

  log "Installing @openai/codex globally with npm"
  npm install -g @openai/codex
}

configure_mcp() {
  export "${TOKEN_ENV_VAR}=${GENE_SET_MCP_BEARER_TOKEN}"
  mkdir -p "${CODEX_HOME_DIR}"

  if codex mcp get "$MCP_NAME" >/dev/null 2>&1; then
    log "Refreshing MCP server '${MCP_NAME}'"
    codex mcp remove "$MCP_NAME" >/dev/null
  else
    log "Registering MCP server '${MCP_NAME}'"
  fi

  codex mcp add "$MCP_NAME" \
    --url "$GENE_SET_MCP_URL" \
    --bearer-token-env-var "$TOKEN_ENV_VAR" >/dev/null
}

main() {
  log "Preparing demo workspace in ${ROOT_DIR}"
  ensure_codex
  append_token_export
  configure_mcp

  log "Configured MCP server '${MCP_NAME}'"
  log "Endpoint: ${GENE_SET_MCP_URL}"
  log "Codex home: ${CODEX_HOME_DIR}"
  log "Next: source your shell profile or export ${TOKEN_ENV_VAR}, then run ./scripts/test-mcp.sh"
  log "Then launch Codex with: codex"
}

main "$@"
