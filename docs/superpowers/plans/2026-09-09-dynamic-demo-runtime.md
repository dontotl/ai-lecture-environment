# Dynamic Demo Runtime Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Preserve the sample application while letting Codex-created demos persist under `/labs` and share one Nginx entry point on port 8080.

**Architecture:** Compose bind-mounts `LABS_DIR` into app. Supervisor retains the sample API/Vite processes and adds Nginx plus boot recovery. Shell utilities own dynamic port allocation, PID/log lifecycle, enabled-state tracking, and atomic Nginx fragment generation.

**Tech Stack:** Docker Compose, Oracle Linux 8, Nginx, Supervisor, FastAPI, Vite, POSIX shell, Oracle Free.

**Spec:** `docs/superpowers/specs/2026-09-09-dynamic-demo-runtime.md`

## Global Constraints

- Keep `oracle-data` as a named volume; do not use object storage or Docker socket access.
- Expose only `8080:8080` from app; demo processes bind loopback-only ports.
- Keep `runtime-data/`, demo `.env`, `.runtime.env`, logs, and PID files out of Git.
- Retain the sample app as the default `/` and `/api/` route.

---

### Task 1: Persistent labs and sample reverse proxy

**Files:**
- Modify: `compose.yaml`, `.gitignore`, `infra/app/Dockerfile`, `infra/app/supervisord.conf`, `infra/app/entrypoint.sh`, `scripts/verify-compose.sh`
- Create: `infra/nginx/nginx.conf`, `infra/nginx/conf.d/sample.conf`, `scripts/tests/test_dynamic_runtime_compose.sh`

- [ ] Write shell assertions that require `LABS_DIR:-./runtime-data`, the `/labs` mount, only port 8080, Nginx installation/configuration, and the retained sample upstream processes.
- [ ] Run the new test and confirm it fails before configuration changes.
- [ ] Add the bind mount, Git ignore rule, Nginx package/config, 8080 listener, and Supervisor Nginx program. Route sample `/` to Vite and `/api/` to FastAPI.
- [ ] Update verification requests from 8000/5173 to 8080 and rerun the test.

### Task 2: Runtime lifecycle library and boot recovery

**Files:**
- Create: `infra/app/demo-runtime.sh`, `infra/app/boot-enabled-demos.sh`, `scripts/tests/test_demo_runtime.sh`
- Modify: `infra/app/entrypoint.sh`, `infra/app/supervisord.conf`

- [ ] Write fixture-based tests for safe slug validation, loopback port allocation, enabled-list add/remove, generated Nginx fragments, and recovery that starts only enabled demos.
- [ ] Run the tests and confirm each fails because the runtime library is absent.
- [ ] Implement POSIX-shell helpers that use `/labs/runtime/{nginx,logs,pids}` and lock per slug; reject unsafe slugs and never remove demo source directories.
- [ ] Add boot recovery to Supervisor after Nginx starts, then rerun lifecycle tests.

### Task 3: Codex-facing demo contract and documentation

**Files:**
- Create: `docs/demo-runtime-contract.md`, `docs/demo-start.sh.template`, `docs/demo-stop.sh.template`
- Modify: `README.md`, `강의환경빌드_v2.md`, `courses/_template/lab/README.md`

- [ ] Write tests that assert templates create loopback-only processes, `.runtime.env`, slug routes, PID files, logs, and enabled state without committing secrets.
- [ ] Run the test and confirm missing templates fail.
- [ ] Document the required MD instructions, URL contract, Oracle least-privilege contract, and recovery semantics; add start/stop templates using the lifecycle library.
- [ ] Run all shell tests and verify the documentation examples match Compose.

### Task 4: End-to-end multi-demo validation

**Files:**
- Create: `scripts/tests/test_dynamic_runtime_e2e.sh`, `scripts/tests/fixtures/demo-template/`
- Modify: `scripts/verify-compose.sh`

- [ ] Create two minimal fixture demos that serve separate web/API responses through generated Nginx fragments.
- [ ] Verify two routes work concurrently, stopping one preserves the other, and restart restores only enabled fixtures.
- [ ] Verify sample `/api/health` remains available at 8080.
- [ ] Run the complete test suite, `docker compose config`, `docker compose up --build`, and the end-to-end checks; record any Docker Desktop infrastructure failure separately from repository failures.
