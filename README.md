# GOVEMVC: Reference Implementation (Todo Application)

Welcome to the official reference implementation of the **GOVEMVC** (Go Vendor & Standard MVC) architectural convention. This project showcases a fully functional, production-ready real-time Todo application built entirely on top of Golang's built-in **Standard Library** and official vendor drivers—achieving high performance, extreme stability, and **relying purely on standard and vendor-official packages for a lightweight, zero-dependency footprint**.

---

## Key Features

* **Zero-Framework Routing:** Utilizes Go's native, highly optimized `http.NewServeMux()` with advanced wildcard path routing features.
* **Vendor-Driven Data Layer:** Strict implementation of standard `database/sql` with raw parameterized SQL queries using the official SQLite driver (`github.com/mattn/go-sqlite3`).
* **Pure Real-Time Engine:** Real-time updates powered by upgrading HTTP connections to persistent TCP sockets via Go's native `http.Hijacker` interface (No third-party WebSocket packages).
* **Elegant Server-Side Rendering (SSR):** Generates modern, fully responsive visual components using the built-in `html/template` package paired with premium Vanilla CSS styling (incorporating glassmorphism, responsive grid, and keyframe micro-animations).
* **CLI Database Administrator:** A native Artisan-like database tool (`dbtool`) managing incremental SQL migrations (`UP`/`DOWN`) and seeders directly from the command line.
* **Pristine Mock Testing Pipeline:** Completely isolated Unit and Integration tests using standard Go tools combined with official vendor-provided in-memory databases (`:memory:`), keeping the disk storage clean.
* **Test Automation & HTML Reports:** Includes an automated runner script compiling execution logs and rendering detailed, interactive visual HTML code coverage map reports.
* **Sterile Deployment Blueprint:** Features a lightweight multi-stage Dockerfile and Docker Compose definitions (< 50 MB final container size).

---

## Real Directory Structure

Below is the directory hierarchy implemented in this reference Todo application:

```text
/govemvc (Project Root)
├── /cmd                      # Application entry points
│   └── /app
│       └── main.go           # Main web server bootstrap (Configuration, DB init, & WS Hub)
├── /database                 # Database schema and mock data administration
│   ├── /dbtool
│   │   └── main.go           # CLI database tool (migrate, seed, rollback, reset)
│   ├── /migrations           # Versioned incremental raw SQL schema alterations
│   │   ├── 0001-create-todos-table.down.sql   # Rollback database schema script
│   │   └── 0001-create-todos-table.up.sql     # Create database schema script (Official Schema)
│   └── /seeders              # Native Go scripts for populating default records
│       └── todoseeder.go
├── /tests                    # Structured automated testing pipeline
│   ├── /unit
│   │   └── todomodel_test.go         # Model logic & SQL query operations unit tests
│   ├── /integration
│   │   └── todocontroller_test.go    # HTTP Handlers, Routing, & SSR rendering integration tests
│   ├── /results                       # Center of compiled test artifacts (Git tracked)
│   │   ├── coverage.html              # Interactive HTML code coverage visual map
│   │   ├── coverage.out               # Go test coverage profile
│   │   └── test-report.log            # Verbose test runner terminal execution logs
│   └── run_tests.sh                   # Automator script executing tests and compiling reports
├── /middleware               # Global HTTP pipeline interceptors (Logging, Security protection headers)
│   └── middleware.go
├── /models                   # Data definitions, structures, and raw SQL queries
│   ├── db.go                 # Shared database engine bootstrap
│   └── todo.go               # Todo model database operations (CRUD)
├── /controllers              # HTTP business request handlers (controllers)
│   └── todo.go
├── /routes                   # Endpoint registers using standard ServeMux
│   └── routes.go
├── /websocket                # Real-time state hub & connection protocol upgraders
│   └── hub.go
├── /views                    # Frontend interface templates & assets
│   ├── /layouts
│   │   └── base.html         # Base master skeleton template (glassmorphic layout)
│   ├── /pages
│   │   └── index.html        # Main landing page rendering Todo blocks and websocket bindings
│   └── /static               # Dynamic assets
│       ├── app.js            # Vanilla JS websocket client & auto-reconnect logic
│       └── style.css         # Premium custom styling variables, gradients, and micro-animations
├── .env.example              # Outlines required environment setups
├── Dockerfile                # Sterile Docker multi-stage configuration
├── docker-compose.yml        # Multi-container service definitions
├── go.mod                    # Go dependencies definition file
└── GOVEMVC.md                # GOVEMVC Architectural Convention Documentation
```

---

## Getting Started

### Prerequisites

Ensure you have [Go](https://go.dev/doc/install) (version 1.22 or newer) installed on your system.

### 1. Set Up Environment Configuration
Clone the template configuration file to activate local development variables:
```bash
cp .env.example .env
```
*(By default, `.env` is configured to run the web server on port `8080` with a local SQLite database named `database/govemvc.db`).*

### 2. Administer Database Migrations & Seeds
Run database migrations and populate the SQLite database with initial sample mock tasks using the unified CLI tool:
```bash
# Apply incremental migrations (creates todos table)
go run database/dbtool/main.go migrate

# Populate sample data seeder
go run database/dbtool/main.go seed
```

### 3. Launch the Web Application
Start the native GOVEMVC web application:
```bash
go run cmd/app/main.go
```
The server will boot instantly:
```text
[GOVEMVC] Server is running on port 8080
[GOVEMVC] Real-time websocket hub started
```
Open your browser and navigate to **`http://localhost:8080`** to experience the premium glassmorphic Todo application featuring real-time collaborative tasks!

---

## Database CLI Tool (`dbtool`) Reference

A lightweight command-line database manager is located at `/database/dbtool`. It supports the following management commands:

| Command | Action |
| :--- | :--- |
| `go run database/dbtool/main.go migrate` | Applies all outstanding SQL migrations up. |
| `go run database/dbtool/main.go rollback` | Reverts the last database migrations down. |
| `go run database/dbtool/main.go seed` | Runs the Go data seeders to populate mock data. |
| `go run database/dbtool/main.go reset` | Wipes the entire database schema and applies fresh migrations/seeders. |

---

## Automated Testing & Interactive Reports

All tests run in completely isolated environments using offical SQLite in-memory `:memory:` databases as mock engines, keeping the filesystem pristine.

### Execute Automated Tests
To run all unit and integration test suites, and immediately generate visual report maps, run the central script:
```bash
bash tests/run_tests.sh
```

### Read Generated Reports
After the runner completes, review the gathered artifacts under `tests/results/`:
* **`tests/results/test-report.log`**: Plaintext terminal output detailing successful assertion results.
* **`tests/results/coverage.html`**: Open this file in any web browser to view an interactive visual map highlighting exact code lines evaluated during test coverage!

---

## Docker Deployment

The application features an ultra-small deployment blueprint utilizing a multi-stage Docker build to keep images lightweight and sterile.

Launch the complete container orchestration (application and persistent volumes) in detached background mode:
```bash
docker-compose up --build -d
```
*(Access the containerized web app seamlessly on port `8080`)*.

---

## Architectural Convention Specification

To read the absolute rules, defensive programming guidelines, WebSocket upgrading, and security standards mandated by this architectural design, consult the official convention document:
**[GOVEMVC Architectural Convention (GOVEMVC.md)](file:///home/user/space/project/web/govemvc/GOVEMVC.md)**
