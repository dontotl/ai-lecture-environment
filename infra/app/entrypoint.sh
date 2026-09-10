#!/bin/bash
set -euo pipefail

mkdir -p "$CODEX_HOME"
find "$CODEX_HOME" -mindepth 1 -maxdepth 1 ! -name auth.json -exec rm -rf {} +
cp -a /opt/codex-profile/. "$CODEX_HOME/"
chown -R app:app "$CODEX_HOME"/config.toml

mkdir -p /labs/materials /labs/demos /labs/runtime/nginx /labs/runtime/logs /labs/runtime/pids
chown -R app:app /labs

mkdir -p /tmp/nginx
chown app:app /tmp/nginx

if [ ! -x /workspace/frontend/node_modules/.bin/vite ]; then
  npm --cache /tmp/npm-cache --registry "$NPM_REGISTRY" --prefix /workspace/frontend ci
fi

exec "$@"
