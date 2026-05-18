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

## Getting Started

Building on top of GOVEMVC is extremely straightforward.

### 1. Configure the Environment
```bash
cp .env.example .env
```

### 2. Administer Database Migrations
Create and seed the database using the lightweight CLI dbtool included under `/database/dbtool`:
```bash
go run database/dbtool/main.go migrate
go run database/dbtool/main.go seed
```

### 3. Launch the Server
```bash
go run cmd/app/main.go
```
Visit `http://localhost:8080` to see the application in action.

## Automated Testing & Validation

GOVEMVC prioritizes rigorous reliability. Execute the custom automated runner script to run the isolated unit and integration tests and view interactive HTML code coverage maps:
```bash
bash tests/runTests.sh
```

## Architectural Conventions

For a detailed breakdown of GOVEMVC's engineering rules, security headers, database transaction layers, and code layout guidelines, please consult:
* **[GOVEMVC Architectural Convention (GOVEMVC.md)](file:///home/user/space/project/web/govemvc/GOVEMVC.md)**
