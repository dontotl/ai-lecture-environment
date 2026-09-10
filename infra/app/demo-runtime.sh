#!/bin/sh
set -eu

LABS_ROOT=${LABS_ROOT:-/labs}
NGINX_BIN=${NGINX_BIN:-nginx}

demo_validate_slug() {
  printf '%s\n' "$1" | grep -Eq '^[a-z0-9][a-z0-9-]{0,62}$'
}

demo_root() {
  demo_validate_slug "$1" || {
    echo "Invalid demo slug: $1" >&2
    return 2
  }
  printf '%s/demos/%s\n' "$LABS_ROOT" "$1"
}

demo_prepare() {
  demo_dir=$(demo_root "$1")
  mkdir -p "$demo_dir" "$LABS_ROOT/runtime/nginx" "$LABS_ROOT/runtime/logs/$1" "$LABS_ROOT/runtime/pids"
}

demo_port_available() {
  python3.9 - "$1" <<'PY'
import socket
import sys

port = int(sys.argv[1])
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
    sock.bind(("127.0.0.1", port))
except OSError:
    sys.exit(1)
finally:
    sock.close()
PY
}

demo_allocate_port() {
  start=$1
  end=$2
  port=$start
  while [ "$port" -le "$end" ]; do
    if demo_port_available "$port"; then
      printf '%s\n' "$port"
      return 0
    fi
    port=$((port + 1))
  done
  echo "No available loopback port in $start-$end" >&2
  return 1
}

demo_write_runtime_env() {
  slug=$1
  api_port=$2
  web_port=$3
  demo_prepare "$slug"
  demo_dir=$(demo_root "$slug")
  temp_file="$demo_dir/.runtime.env.tmp"
  umask 077
  {
    printf 'DEMO_SLUG=%s\n' "$slug"
    printf 'API_PORT=%s\n' "$api_port"
    printf 'WEB_PORT=%s\n' "$web_port"
  } > "$temp_file"
  mv "$temp_file" "$demo_dir/.runtime.env"
}

demo_register_route() {
  slug=$1
  api_port=$2
  web_port=$3
  demo_prepare "$slug"
  fragment="$LABS_ROOT/runtime/nginx/$slug.conf"
  temp_file="$fragment.tmp"
  cat > "$temp_file" <<EOF
location = /$slug { return 301 /$slug/; }

location /$slug/api/ {
  proxy_pass http://127.0.0.1:$api_port/api/;
  proxy_set_header Host \$host;
  proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto \$scheme;
}

location /$slug/ {
  proxy_pass http://127.0.0.1:$web_port/;
  proxy_http_version 1.1;
  proxy_set_header Host \$host;
  proxy_set_header Upgrade \$http_upgrade;
  proxy_set_header Connection \$connection_upgrade;
}
EOF
  mv "$temp_file" "$fragment"
  "$NGINX_BIN" -t && "$NGINX_BIN" -s reload
}

demo_enable() {
  slug=$1
  demo_validate_slug "$slug" || return 2
  mkdir -p "$LABS_ROOT/runtime"
  enabled="$LABS_ROOT/runtime/enabled-demos"
  touch "$enabled"
  if ! grep -Fx "$slug" "$enabled" >/dev/null 2>&1; then
    printf '%s\n' "$slug" >> "$enabled"
  fi
}

demo_disable() {
  slug=$1
  demo_validate_slug "$slug" || return 2
  enabled="$LABS_ROOT/runtime/enabled-demos"
  fragment="$LABS_ROOT/runtime/nginx/$slug.conf"
  temp_file="$enabled.tmp"
  if [ -f "$enabled" ]; then
    grep -Fvx "$slug" "$enabled" > "$temp_file" || true
    mv "$temp_file" "$enabled"
  fi
  rm -f "$fragment"
  "$NGINX_BIN" -t && "$NGINX_BIN" -s reload
}

demo_write_pid() {
  slug=$1
  name=$2
  pid=$3
  demo_prepare "$slug"
  printf '%s\n' "$pid" > "$LABS_ROOT/runtime/pids/$slug-$name.pid"
}

demo_stop_pid() {
  slug=$1
  name=$2
  pid_file="$LABS_ROOT/runtime/pids/$slug-$name.pid"
  if [ -f "$pid_file" ]; then
    pid=$(cat "$pid_file")
    kill "$pid" 2>/dev/null || true
    rm -f "$pid_file"
  fi
}
