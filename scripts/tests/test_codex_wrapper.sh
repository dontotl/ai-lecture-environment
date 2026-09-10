#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
scratch_dir=$(mktemp -d)
trap 'rm -rf "$scratch_dir"' EXIT

mkdir -p "$scratch_dir/bin"
cp "$project_root/scripts/tests/fixtures/docker-record-args.sh" "$scratch_dir/bin/docker"
chmod 755 "$scratch_dir/bin/docker"

DOCKER_ARGS_FILE="$scratch_dir/docker-args" \
PATH="$scratch_dir/bin:$PATH" \
"$project_root/scripts/codex.sh" --env-file env/windows-amd64.env login --device-auth

actual=$(tr '\n' ' ' < "$scratch_dir/docker-args")
expected='compose --env-file env/windows-amd64.env exec -it app codex login --device-auth '
test "$actual" = "$expected"
