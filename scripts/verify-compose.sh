#!/bin/sh
set -eu

env_file=${1:-env/macos-arm64.env}
require_skills=${2:-}
skills_dir=${SKILLS_DIR:-infra/codex-profile/skills}

case "$require_skills" in
  ""|--require-skills) ;;
  *)
    echo "Usage: $0 [env-file] [--require-skills]" >&2
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
skill_count=$(find "$skills_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
if [ "$require_skills" = "--require-skills" ]; then
  test "$skill_count" = "27"
else
  echo "Optional local Codex skill bundle: $skill_count directories"
fi
