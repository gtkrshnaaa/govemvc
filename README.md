# GOVEMVC

GOVEMVC (Go Vendor & Standard MVC) is a lightweight, high-performance architectural convention designed to build robust web applications using Golang's native Standard Library paired with official database drivers. It offers a clean, transparent, and secure alternative for developers who prioritize control, performance, and zero third-party dependency bloat.

## Why GOVEMVC?

Many modern web developers rely heavily on heavy frameworks and ORMs. While full-featured community web frameworks (such as Gin, Echo, and Fiber) and advanced database toolchains (such as GORM and Ent) are excellent, highly refined engineering solutions that serve many large-scale projects incredibly well, GOVEMVC offers a different philosophy.

By building on top of the native Standard Library (`net/http`) and official database drivers, GOVEMVC ensures:
* **Near-Zero Overhead:** Blazing fast execution times and minimal memory footprint by bypassing massive middleware stacks and reflection-heavy abstractions.
* **Long-Term Maintainability:** Free from third-party deprecation cycles, security vulnerabilities, or major library updates.
* **Ultimate Transparency:** Every single line of routing, middleware, database mapping, and real-time communication is completely transparent, readable, and under your absolute control.

## Reference Implementation: Real-Time Todo Manager

To make starting with GOVEMVC as simple as possible, this repository contains a fully working, highly optimized reference implementation: a real-time, responsive Todo application.

This reference implementation demonstrates:
* **Native Path Routing:** Utilizing `http.NewServeMux` for robust, high-performance endpoint mapping.
* **Official Vendor Integration:** Parameterized raw SQL queries using the official SQLite driver.
* **Low-Level WebSocket Upgrader:** Upgrading HTTP connections to real-time TCP sockets purely through standard library features.
* **Sleek Server-Side Rendering (SSR):** Beautiful glassmorphic UI utilizing the native `html/template` engine and vanilla CSS.

## Getting Started (Docker-First Workflow)

By default, GOVEMVC is designed to run entirely on top of Docker. This ensures 100% environmental consistency and eliminates any need to install Go, GCC, or SQLite tools locally on your host machine.

### 1. Configure the Environment
```bash
cp .env.example .env
```

### 2. Administer Database Migrations & Seeds on Docker
Run database schema migrations and seed default mock records inside an isolated, lightweight Go Docker container:
```bash
# Run incremental SQL migrations
docker run --rm -v $(pwd):/app -w /app golang:1.22-alpine go run database/dbtool/main.go migrate

# Populate database seeders
docker run --rm -v $(pwd):/app -w /app golang:1.22-alpine go run database/dbtool/main.go seed
```

### 3. Launch the Web Application
Launch the complete container orchestration (application and persistent volumes) in detached background mode:
```bash
docker-compose up --build -d
```
Visit **`http://localhost:8080`** in your web browser to access the live web application!

---

## Automated Testing & Validation on Docker

GOVEMVC prioritizes rigorous reliability. Execute the entire testing pipeline (both isolated Unit and Integration test suites) inside a pristine, containerized environment to view interactive HTML code coverage maps:

```bash
docker run --rm -v $(pwd):/app -w /app golang:1.22-alpine sh -c "apk add --no-cache bash gcc musl-dev && bash tests/runTests.sh"
```
After the runner completes, open `tests/results/coverage.html` in any web browser to view the interactive visual map highlighting exact code lines evaluated during test coverage!

---

## Architectural Conventions

For a detailed breakdown of GOVEMVC's engineering rules, security headers, database transaction layers, and code layout guidelines, please consult:
* **[GOVEMVC Architectural Convention (GOVEMVC.md)](file:///home/user/space/project/web/govemvc/GOVEMVC.md)**
