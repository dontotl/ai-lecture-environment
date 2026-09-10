FROM container-registry.oracle.com/os/oraclelinux:8

RUN dnf -y module enable nodejs:20 \
    && dnf -y install nodejs python39 python39-pip git gzip tar xz shadow-utils nginx \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN useradd --create-home --shell /bin/bash app

COPY backend/requirements-dev.txt /tmp/requirements-dev.txt
COPY frontend/package.json frontend/package-lock.json /workspace/frontend/
ARG NPM_REGISTRY=https://registry.npmmirror.com
RUN python3.9 -m pip install --no-cache-dir --upgrade pip \
    && python3.9 -m pip install --no-cache-dir -r /tmp/requirements-dev.txt supervisor \
    && npm --registry="$NPM_REGISTRY" install --global @openai/codex \
    && npm --registry="$NPM_REGISTRY" --prefix /workspace/frontend ci

COPY infra/codex-profile /opt/codex-profile
COPY infra/nginx/nginx.conf /etc/nginx/nginx.conf
COPY infra/nginx/conf.d/sample.conf /etc/nginx/conf.d/sample.conf
COPY infra/app/entrypoint.sh /usr/local/bin/entrypoint
COPY infra/app/demo-runtime.sh /usr/local/lib/demo-runtime.sh
COPY infra/app/boot-enabled-demos.sh /usr/local/bin/boot-enabled-demos
COPY infra/app/supervisord.conf /etc/supervisord.conf

RUN chmod 755 /usr/local/bin/entrypoint /usr/local/bin/boot-enabled-demos /usr/local/lib/demo-runtime.sh \
    && chown -R app:app /workspace /opt/codex-profile 2>/dev/null || true

WORKDIR /workspace
ENV CODEX_HOME=/tmp/codex-home
ENV NPM_REGISTRY=https://registry.npmmirror.com
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
