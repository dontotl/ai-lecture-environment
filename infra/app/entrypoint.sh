#!/bin/bash
set -euo pipefail

rm -rf "$CODEX_HOME"
mkdir -p "$CODEX_HOME"
cp -a /opt/codex-profile/. "$CODEX_HOME/"
chown -R app:app "$CODEX_HOME"

if [ ! -x /workspace/frontend/node_modules/.bin/vite ]; then
  npm --cache /tmp/npm-cache --registry "$NPM_REGISTRY" --prefix /workspace/frontend ci
fi

exec "$@"
