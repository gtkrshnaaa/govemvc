# GOVEMVC.md: Standard Architecture Convention for Vendor-Driven & Standard-Library Golang Applications

This document defines **GOVEMVC** (Go Vendor & Standard MVC), an architectural convention and design pattern for building robust, high-performance web applications using native ecosystems. This convention is built on the core principle that Golang's built-in Standard Library is exceptionally powerful and sufficient for production needs, offering a minimalist, zero-dependency alternative to third-party web frameworks.

---

## 1. Directory Structure Standard (Tree Folder)

Every application adhering to the GOVEMVC convention must implement the semantic folder structure below to strictly separate concerns without altering Go's native package ecosystem. The folder and file hierarchy is structured as follows, utilizing descriptive representative naming for illustration:

```text
/theParentProjectRoot
├── /theCommandEntryPointFolder
│   ├── /theMainApplicationFolder
│   │   └── theMainApplicationExecutableBootstrap.go   # Application entry point (boots server & WS hub)
│   └── /theCommandLineDatabaseToolFolder
│       └── theDatabaseCLICommandTool.go               # Artisan-like DB CLI tool (migrate, seed, reset)
├── /theGlobalDatabaseManagementFolder
│   ├── /theDatabaseMigrationsFolder
│   │   ├── theFirstIncrementalSchemaMigrationUpScript.sql
│   │   ├── theFirstIncrementalSchemaMigrationDownScript.sql
│   │   ├── theSecondIncrementalSchemaMigrationUpScript.sql
│   │   └── theSecondIncrementalSchemaMigrationDownScript.sql
│   └── /theDatabaseDataSeedersFolder
│       └── theInitialDefaultDataSeederScript.go
├── /theGlobalTestingSuitesFolder
│   ├── /theIsolatedUnitTestsFolder
│   │   └── theDataModelsLogicUnitTest.go              # Isolated data model CRUD tests
│   ├── /theHTTPIntegrationTestsFolder
│   │   └── theControllerHTTPResponseIntegrationTest.go # End-to-end controllers & SSR tests
│   └── /theAggregatedTestReportsFolder                # Central repository for test artifacts
│       ├── theAutomatedTestRunnerTerminalOutput.log   # Plaintext verbose execution logs
│       ├── theGoTestCoverageBinaryProfile.out         # Raw binary coverage profile data
│       └── theVisualHTMLCoverageMapReport.html        # Interactive HTML test coverage map
│   └── theCentralTestAutomatorShellScript.sh          # Test runner script (runs tests & compiles reports)
├── /theHTTPInterceptorsMiddlewarePipelineFolder
│   └── theSecurityHeadersAndLoggerMiddleware.go        # Logging and security policies layer
├── /theDataStructuresAndQueriesModelLayerFolder
│   ├── theDatabaseEngineConnectionBootstrap.go         # SQL connection pool manager
│   └── theBusinessEntityDataAccessQueries.go          # Parameterized SQL business queries
├── /theHTTPBusinessLogicControllersLayerFolder
│   └── theBusinessEntityHTTPHandlerControllers.go      # Handlers resolving requests and templates
├── /theRoutingMappingsDefinitionsFolder
│   └── theURLPathWildcardRoutesRegister.go            # Maps wildcard URL routing to controllers
├── /theRealtimeCommunicationWebSocketEngineFolder
│   └── theWebSocketUpgraderAndClientBroadcastHub.go   # Upgrades TCP protocols and manages WS state
├── /theFrontendTemplatesViewsFolder
│   ├── /theMasterLayoutSkeletonsFolder
│   │   └── theBaseHTMLSkeletonLayoutTemplate.html     # Outer master HTML shell
│   ├── /theRenderedPagesSubTemplatesFolder
│   │   └── theSpecificFeatureDashboardViewTemplate.html # Page sub-template containing content
│   └── /theStaticAssetsAndMediaFolder
│       ├── thePremiumGlobalThemeVanillaCSSStyles.css  # Sleek styles (gradients, animations)
│       └── theWebSocketDynamicEventsControllerVanillaJS.js # AJAX fetch and WS auto-reconnect logic
├── theLocalPrivateEnvironmentConfigurations.env        # Local sensitive settings (ignored in Git)
├── thePublicTemplateEnvironmentConfigurations.env.example # Outlines required ENV parameters
├── theMultiStageContainerDeploymentBlueprintDockerfile # Container compiler and minimalistic runner
├── theMultiContainerOrchestrationServiceCompose.yml     # Orchestration definitions (app & volume)
└── theGoModuleDependencySpecification.mod              # Go dependencies file
```

---

## 2. Tech Stack Specification & Implementation Rules

### A. Backend & Routing (`net/http`)

* **Absolute Convention:** Routing must be handled directly by Go's built-in `http.NewServeMux()` without incorporating external routing packages.
* **Large-Scale Implementation:** Leverage the dynamic wildcard routing features native to modern Go to handle URL path parameters semantically. For example:
  ```go
  mux.HandleFunc("GET /resources/{resourceID}/subresources/{subID}", controllers.GetResourceHandler)
  ```
* **Characteristics:** This approach completely eliminates the memory overhead caused by layers of third-party framework code, ensuring optimal, ultra-fast, and highly efficient HTTP request handling performance.

### B. Data Layer (`database/sql` + Vendor Driver)

* **Absolute Convention:** To demonstrate clean SQL practices and maintain full control over query performance, the application chooses to use the standard `database/sql` package directly instead of relying on external ORMs (Object-Relational Mapping).
* **Large-Scale Implementation:**
  * Database connectivity must be bridged directly by the driver released by the respective database vendor (e.g., `github.com/mattn/go-sqlite3` for SQLite).
  * All data manipulation operations (CRUD) must be executed using raw SQL queries.
  * For heavy data volumes, performance optimization must focus strictly on creating robust database-level indexing directly on relational key columns.

### C. Real-Time Engine (Pure WebSocket via `http.Hijacker`)

* **Absolute Convention:** To demonstrate native protocol engineering, the process of upgrading HTTP connections to WebSockets is executed directly via the standard library's `http.Hijacker` interface, avoiding external WebSocket packages.
* **Large-Scale Implementation:**
  * The real-time endpoint intercepts standard HTTP requests and hijacks the underlying TCP network connection to make it persistent.
  * The WebSocket handshake calculations (computing the `Sec-WebSocket-Accept` key) are processed independently using built-in functions from the `crypto/sha1` and `encoding/base64` packages.
  * Each client connection is represented by a single, highly lightweight Goroutine (~2 KB initial memory allocation). Coordination across connections is managed within the `/websocket` directory using Go's native `Map` and `RWMutex` types to ensure complete thread-safety against race conditions during simultaneous traffic surges.

### D. Frontend Interface (`html/template` & Native CSS)

* **Absolute Convention:** The application UI relies on pure Server-Side Rendering (SSR) via Go's built-in `html/template` package, keeping the deployment architecture simple and lightweight without requiring complex external frontend build tools.
* **Large-Scale Implementation:**
  * The visual layout and structure of web pages are designed using Pure CSS via traditional static `.css` files.
  * Dynamic UI elements (such as user online status indicators or dynamic color theme updates) have their property values injected directly through dynamic Inline CSS parsed from Go structs.
  * Asynchronous client-side interactions and real-time data streaming are powered natively by browser APIs via Vanilla JavaScript using the `new WebSocket()` object, without requiring heavy JavaScript frameworks.

### E. Infrastructure & Configuration (Multi-Stage Docker & Environment)

* **Absolute Convention:** The application must be packaged into containers using a Dockerfile configured with a multi-stage build approach. External libraries for loading environment configurations must be avoided; standard configurations are read directly from environment variables.
* **Large-Scale Implementation:**
  * **Stage 1 (Build):** Utilizes the standard `golang:alpine` image to compile the entire Go source code into a single, self-contained binary file.
  * **Stage 2 (Final):** The compiled binary is moved into a sterile, minimalist image like `scratch` or `alpine`. The final container remains extremely small (< 50 MB), contains no source code dependencies, and runs alongside the database container within an isolated internal network via `docker-compose.yml`. This guarantees high portability, allowing instantaneous deployment onto any VPS server.

### F. Database Administration (Migrations & Seeders)

* **Absolute Convention:** To ensure structural consistency and predictability, database schemas and default datasets are managed via versioned migrations and seeders rather than manual ad-hoc table adjustments in production.
* **Large-Scale Implementation:**
  * **Incremental SQL Migrations:** All schema changes must be saved as versioned, raw SQL scripts separated into UP (creating/altering tables) and DOWN (reverting changes) statements under `/database/migrations`.
  * **Go Native Seeders:** System mock data or initial application datasets must be populated using native Go seeder scripts nested under `/database/seeders`.
  * **Unified CLI DB Tool:** A lightweight DB Command Line Tool (`dbtool`) must be built under the `/database` directory (e.g., `/database/dbtool/main.go`) to parse server commands and easily run migrations, seeders, or database resets during production deployments.

### G. Automated Testing Pipeline (Unit, Integration & Reports)

* **Absolute Convention:** Codebases must be covered by structured test suites split by scope, using native test execution environments and vendor-provided in-memory databases to act as mock engines.
* **Large-Scale Implementation:**
  * **Unit Tests:** Organized under `/tests/unit`, verifying isolated models, structural algorithms, and data logic using sterile, extremely fast in-memory databases (e.g., SQLite `:memory:`).
  * **Integration Tests:** Organized under `/tests/integration`, verifying HTTP endpoints, routing configurations, logger pipelines, security headers, and SSR page parsing using Go's native `net/http/httptest`.
  * **Results Aggregation:** All output verbose test logs, binary profiles, and HTML visual reports must be compiled under `/tests/results/` (e.g., `testReport.log`, `coverage.out`, `coverage.html`).
  * **Automated Runner Script:** A shell script `runTests.sh` must be configured at the tests root to wipe old data, execute Go tests with accurate `-coverpkg` references, and auto-generate premium interactive HTML visual coverage maps.

---

## 3. Code Writing Standards

To maintain clean, uniform, and maintainable code across the entire architecture, GOVEMVC enforces strict adherence to native idiomatic Go guidelines:

### A. Formatting and Layout (`gofmt`)

* **Rule:** All source files must be formatted using the standard `gofmt` utility prior to compilation or version control check-in. Discussions regarding spacing, brackets, or code layouts are mitigated entirely by the native formatter.

### B. Explicit Error Handling

* **Rule:** Panics must not be used for normal flow control or standard execution paths; Go's native error return pattern must be explicitly followed.
* **Rule:** Every operation capable of returning an error must have its error evaluated immediately via the explicit `if err != nil` check. Errors must be wrapped elegantly with contextual information using `fmt.Errorf` when propagated upward.

### C. Visibility and Encapsulation

* **Rule:** Package scope accessibility relies entirely on capitalization. Access modifier keywords do not exist.
* **Rule:** Struct attributes, functions, and variables must begin with an uppercase letter to be exported outside their defining package (Public). They must begin with a lowercase letter if they are strictly internal to the package (Private).

---

## 4. Security Standards & Vulnerability Prevention

GOVEMVC places premium importance on defensive coding. When building applications without heavy external frameworks, security controls must be explicitly implemented at the application layer using only Go's robust **Standard Library** and official Go-vetted sub-repositories (such as `golang.org/x/crypto`).

### A. SQL Injection Prevention

* **Rule:** To prevent SQL injection, user-supplied inputs or request parameters must never be concatenated directly into raw SQL queries.
* **Rule:** All database actions executed via standard `database/sql` must employ parameterized placeholder arguments (e.g., `?` in SQLite/MySQL, or `$1`, `$2` in PostgreSQL).
* **Rule:** Direct execution of raw dynamic queries is only permitted for compile-time constants. Any execution involving runtime inputs must use prepared statements or placeholder parameters.
  ```go
  // SECURE IMPLEMENTATION (SQLite)
  db.QueryRow("SELECT id, title, completed FROM todos WHERE id = ? AND user_id = ?", todoID, userID)
  ```

### B. Cross-Site Scripting (XSS) Mitigation

* **Rule:** Untrusted user input must never be rendered directly onto the document context without proper dynamic escaping or sanitization.
* **Rule:** Output generation must rely entirely on Go's native `html/template` package. The built-in template engine automatically enforces context-aware data escaping (HTML, JavaScript, CSS attributes, and URIs) based on the variable's position inside the template text.
* **Rule:** Strict browser protection must be enforced by injecting a comprehensive **Content-Security-Policy (CSP)** header globally via middleware (e.g., restricting script execution to `'self'`, disabling `'unsafe-inline'` where possible, or employing cryptographically secure nonces).

### C. Cross-Site Request Forgery (CSRF) Prevention

* **Rule:** State-changing requests (POST, PUT, DELETE, PATCH) must be protected against CSRF attacks.
* **Rule:** The application must enforce a **Double-Submit Cookie Pattern** or secure token validation. Every dynamic form rendering must inject a unique, high-entropy CSRF token generated using cryptographically secure random numbers from the `crypto/rand` package (never use `math/rand`).
* **Rule:** Every mutating HTTP request must validate that the incoming token in the request header or form parameter matches the token stored inside a secure CSRF cookie.
* **Rule:** CSRF cookies must strictly declare the `HttpOnly` (preventing JS access), `Secure` (restricting transmission to HTTPS), and `SameSite=Strict` (barring cross-site requests) attributes.

### D. Cryptographic and Password Hashing Standards

* **Rule:** Passwords must never be stored as plaintext, MD5, SHA-1, or plain SHA-256 digests.
* **Rule:** Password hashing must rely exclusively on the official Go vendor cryptography package: **`golang.org/x/crypto/bcrypt`**.
* **Rule:** The work factor (Cost parameter) for Bcrypt must be explicitly configured to a minimum of **12** (or higher depending on server hardware) to defend against GPU-accelerated offline brute-force attacks.
* **Rule:** Symmetric data encryption must use **AES-GCM** (Galois/Counter Mode) via `crypto/aes` and `crypto/cipher` standard library packages, utilizing a unique 12-byte initialization vector (IV) generated via `crypto/rand` for every single encryption cycle.
* **Rule:** Legacy cryptographic hashes like MD5 or SHA-1 must not be used for sensitive data hashing, integrity checks, or user passwords due to known collision vulnerabilities (SHA-1 is only accepted during the native WebSocket upgrade handshake as mandated by RFC 6455).

### E. Secure Session Management

* **Rule:** Session identifiers (Session IDs) must be generated using cryptographically secure random bytes from `crypto/rand` with at least **32 bytes** (256 bits) of entropy, encoded using standard `encoding/hex` or `encoding/base64`.
* **Rule:** Session cookies must always have the `HttpOnly`, `Secure` (in production), and `SameSite=Lax` or `SameSite=Strict` attributes declared.
* **Rule:** Session tokens must be validated against a server-side storage map or database record during every request. Sessions must have a clear expiration limit (Session Timeout) and must be completely destroyed from server memory and database storage upon explicit user logout.

### F. WebSocket Resource Safety & DoS Prevention

* **Rule:** WebSocket upgrades must be authenticated beforehand. The HTTP handler upgrading the protocol must verify the active session cookie or auth token present in the initial HTTP upgrade request before invoking the `http.Hijacker` interface.
* **Rule:** Handlers must explicitly evaluate the `Origin` header of the incoming upgrade request against an authorized domain whitelist to prevent Cross-Site WebSocket Hijacking (CSWSH) attacks.
* **Rule:** To prevent Denial of Service (DoS) and memory exhaustion, incoming packet sizes must be strictly capped (e.g., maximum read limit of 1024 to 4096 bytes).
* **Rule:** Network read and write deadlines must be declared dynamically per connection using the underlying net.Conn methods (`SetReadDeadline`, `SetWriteDeadline`) to automatically sever hung or slow-loris connections.
* **Rule:** Goroutine Leaks must be strictly prevented. When a connection severs, is closed by the client, or hits a deadline timeout, the WebSocket hub must cleanly close channels, remove the client from active mappings, and terminate the connection's background Goroutine loops.

### G. Centralized Middleware Control & Rate Limiting

* **Rule:** Global security policies must be isolated inside the `/middleware` pipeline to guarantee that individual controller handlers cannot accidentally bypass security controls.
* **Rule:** Core security headers must be injected into every HTTP response:
  * `X-Frame-Options: DENY` (prevents clickjacking).
  * `X-Content-Type-Options: nosniff` (prevents MIME-sniffing).
  * `Referrer-Policy: strict-origin-when-cross-origin` (protects referrer data).
  * `Content-Security-Policy` (mitigates XSS).
* **Rule:** To prevent brute-force attacks and application-layer DoS, active **Rate Limiting** must be enforced globally or on sensitive routes (e.g., login, password reset). Rate limiting must be implemented natively using Go standard library primitives—such as a thread-safe `sync.Map` tracking client IPs and custom token-bucket or sliding-window algorithms driven by standard `time.Ticker` clocks.

---


## 5. GOVEMVC Architecture Benefits

By consistently applying the GOVEMVC convention, developers gain absolute, long-term stability:

1. **Complete Freedom:** The semantic folder structure gives developers total flexibility to map business logic without being constrained by rigid file placement rules imposed by a framework.
2. **Resource Efficiency:** Utilizing Goroutines instead of traditional operating system threads drastically reduces server RAM consumption, minimizing the risks of system crashes under high traffic loads.
3. **Long Code Lifecycle:** The application remains entirely safe from breaking changes or deprecation issues tied to third-party dependencies that are suddenly abandoned or drastically modified during version updates.
