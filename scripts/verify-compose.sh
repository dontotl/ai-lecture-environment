#!/bin/sh
set -eu

env_file=${1:-env/macos-arm64.env}

case "$#" in
  0|1) ;;
  *)
    echo "Usage: $0 [env-file]" >&2
    exit 2
    ;;
esac

docker compose --env-file "$env_file" config >/dev/null
docker compose --env-file "$env_file" ps --status running
curl --fail --retry 10 --retry-connrefused http://localhost:8000/api/health
curl --fail http://localhost:5173
docker compose --env-file "$env_file" exec -T app codex --version
docker compose --env-file "$env_file" exec -T app dnf --version
docker compose --env-file "$env_file" exec -T app yum --version
docker compose --env-file "$env_file" exec -T -u root db dnf --version
docker compose --env-file "$env_file" exec -T -u root db yum --version
