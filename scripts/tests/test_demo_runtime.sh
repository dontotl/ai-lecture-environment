#!/bin/sh
set -eu

project_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
scratch_dir=$(mktemp -d)
trap 'rm -rf "$scratch_dir"' EXIT

LABS_ROOT="$scratch_dir/labs"
NGINX_BIN=true
export LABS_ROOT NGINX_BIN
. "$project_root/infra/app/demo-runtime.sh"

! demo_validate_slug 'bad/slug'
demo_validate_slug 'inventory-demo-2'
demo_prepare 'inventory-demo-2'
test -d "$LABS_ROOT/demos/inventory-demo-2"

api_port=$(demo_allocate_port 19000 19100)
web_port=$(demo_allocate_port 19101 19200)
test "$api_port" -ge 19000
test "$web_port" -ge 19101
test "$api_port" != "$web_port"

demo_write_runtime_env inventory-demo-2 "$api_port" "$web_port"
demo_register_route inventory-demo-2 "$api_port" "$web_port"
demo_enable inventory-demo-2
test -f "$LABS_ROOT/runtime/nginx/inventory-demo-2.conf"
grep -F "127.0.0.1:$api_port" "$LABS_ROOT/runtime/nginx/inventory-demo-2.conf" >/dev/null
grep -Fx 'inventory-demo-2' "$LABS_ROOT/runtime/enabled-demos" >/dev/null

mkdir -p "$LABS_ROOT/demos/restart-me"
cat > "$LABS_ROOT/demos/restart-me/start.sh" <<'EOF'
#!/bin/sh
printf '%s\n' "$1" >> "$LABS_ROOT/restarts"
EOF
chmod 755 "$LABS_ROOT/demos/restart-me/start.sh"
demo_enable restart-me
LABS_ROOT="$LABS_ROOT" "$project_root/infra/app/boot-enabled-demos.sh"
grep -Fx -- '--restore' "$LABS_ROOT/restarts" >/dev/null

demo_disable inventory-demo-2
! test -e "$LABS_ROOT/runtime/nginx/inventory-demo-2.conf"
! grep -Fx 'inventory-demo-2' "$LABS_ROOT/runtime/enabled-demos"
