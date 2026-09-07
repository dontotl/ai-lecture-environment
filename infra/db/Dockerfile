FROM container-registry.oracle.com/database/free:latest-lite

USER root

RUN set -eux; \
    command -v dnf >/dev/null 2>&1 || { echo "dnf is required" >&2; exit 1; }; \
    if ! command -v yum >/dev/null 2>&1; then \
      ln -s "$(command -v dnf)" /usr/bin/yum; \
    fi; \
    yum --version >/dev/null; \
    dnf --version >/dev/null

USER oracle
