# GOVEMVC.md: Standard Architecture Convention for Vendor-Driven & Standard-Library Golang Applications 

This document defines **GOVEMVC** (Go Vendor & Standard MVC), an architectural convention and design pattern for building large-scale web applications using native ecosystems. This convention is built on the core principle that Golang's built-in Standard Library is exceptionally powerful for production needs , rendering third-party cosmetic frameworks completely unnecessary.

---

## 1. Directory Structure Standard (Tree Folder)

Every application adhering to the GOVEMVC convention must implement the semantic folder structure below to strictly separate concerns without altering Go's native package ecosystem:

```text
/my-golang-app
├── /cmd
│   └── /app
[cite_start]│       └── main.go           # Application entry point: Configuration, DB init, WebSocket Hub, & Server Boot [cite: 8, 58, 210]
├── /middleware           # HTTP interceptors (Auth, Logging, Security Headers, CORS)
[cite_start]├── /models               # Data structures & raw parameterized SQL queries (database/sql + Vendor Driver) [cite: 9, 69, 210]
[cite_start]├── /controllers          # Business logic (http.HandlerFunc) to process HTTP requests [cite: 11, 69, 210]
[cite_start]├── /routes               # Endpoint registration using native http.NewServeMux() [cite: 60, 69, 210]
[cite_start]├── /websocket            # Real-time engine: Protocol upgrading (http.Hijacker) & Hub broadcasting [cite: 59, 69, 210]
├── /views
[cite_start]│   ├── /layouts              # HTML base templates for the master layout skeleton (header, footer, meta) [cite: 13, 51, 69, 210]
[cite_start]│   ├── /pages                # Specific page templates rendered directly by controllers [cite: 62, 69, 210]
[cite_start]│   └── /static               # Native static assets (Pure CSS, images, Vanilla JS) [cite: 51, 63, 69, 210]
├── .env                  # Local environment configuration file (Ignored from Git)
├── .env.example          # Template file outlining required environment configurations
[cite_start]├── Dockerfile                # Container configuration using a multi-stage build approach [cite: 40, 52, 70, 210]
[cite_start]├── docker-compose.yml        # Multi-container orchestration including the database engine [cite: 70, 210]
[cite_start]└── go.mod                    # Module declaration (Strictly Go version & vendor database drivers) [cite: 70, 210]

```

---

## 2. Tech Stack Specification & Implementation Rules

### A. Backend & Routing (`net/http`)

* 
**Absolute Convention:** Routing must be handled directly by Go's built-in `http.NewServeMux()` without incorporating external routing packages.


* 
**Large-Scale Implementation:** Leverage the dynamic wildcard routing features native to modern Go to handle URL path parameters semantically. For example:


```go
mux.HandleFunc("GET /resources/{resourceID}/subresources/{subID}", controllers.GetResourceHandler)

```


* 
**Characteristics:** This approach completely eliminates the memory overhead caused by layers of third-party framework code, ensuring optimal, ultra-fast, and highly efficient HTTP request handling performance.



### B. Data Layer (`database/sql` + Vendor Driver)

* 
**Absolute Convention:** Data management is strictly prohibited from using community-made ORMs (Object-Relational Mapping). Interfacing with the database must rely entirely on the built-in `database/sql` package.


* **Large-Scale Implementation:**
* Database connectivity must be bridged directly by the driver released by the respective database vendor (e.g., `github.com/lib/pq` for PostgreSQL).


* All data manipulation operations (CRUD) must be executed using raw SQL queries.


* For heavy data volumes, performance optimization must focus strictly on creating robust database-level indexing directly on relational key columns.





### C. Real-Time Engine (Pure WebSocket via `http.Hijacker`)

* 
**Absolute Convention:** Using third-party WebSocket libraries is strictly forbidden. The entire process of upgrading HTTP protocols to WebSocket must be executed manually via the `http.Hijacker` interface provided natively by `net/http`.


* **Large-Scale Implementation:**
* The real-time endpoint intercepts standard HTTP requests and hijacks the underlying TCP network connection to make it persistent.


* The WebSocket handshake calculations (computing the `Sec-WebSocket-Accept` key) are processed independently using built-in functions from the `crypto/sha1` and `encoding/base64` packages.


* Each client connection is represented by a single, highly lightweight Goroutine (~2 KB initial memory allocation). Coordination across connections is managed within the `/websocket` directory using Go's native `Map` and `RWMutex` types to ensure complete thread-safety against race conditions during simultaneous traffic surges.





### D. Frontend Interface (`html/template` & Native CSS)

* 
**Absolute Convention:** The application UI fully adopts pure Server-Side Rendering (SSR) driven by the Go server via the built-in `html/template` package. Complex external frontend build tools are strictly barred from the stack.


* **Large-Scale Implementation:**
* The visual layout and structure of web pages are designed using Pure CSS via traditional static `.css` files.


* Dynamic UI elements (such as user online status indicators or dynamic color theme updates) have their property values injected directly through dynamic Inline CSS parsed from Go structs.


* Asynchronous client-side interactions and real-time data streaming are powered natively by browser APIs via Vanilla JavaScript using the `new WebSocket()` object, without requiring heavy JavaScript frameworks.





### E. Infrastructure & Configuration (Multi-Stage Docker & Environment)

* 
**Absolute Convention:** The application must be packaged into containers using a Dockerfile configured with a multi-stage build approach. External libraries for loading environment configurations must be avoided; standard configurations are read directly from environment variables.


* **Large-Scale Implementation:**
* 
**Stage 1 (Build):** Utilizes the standard `golang:alpine` image to compile the entire Go source code into a single, self-contained binary file.


* 
**Stage 2 (Final):** The compiled binary is moved into a sterile, minimalist image like `scratch` or `alpine`. The final container remains extremely small (< 50 MB), contains no source code dependencies, and runs alongside the database container within an isolated internal network via `docker-compose.yml`. This guarantees high portability, allowing instantaneous deployment onto any VPS server.





---

## 3. Code Writing Standards

To maintain clean, uniform, and maintainable code across the entire architecture, GOVEMVC enforces strict adherence to native idiomatic Go guidelines:

### A. Formatting and Layout (`gofmt`)

* 
**Rule:** All source files must be formatted using the standard `gofmt` utility prior to compilation or version control check-in. Discussions regarding spacing, brackets, or code layouts are mitigated entirely by the native formatter.



### B. Explicit Error Handling

* **Rule:** Panics are strictly prohibited for flow control or standard execution paths. Errors must be treated as explicit values returned by functions.


* 
**Rule:** Every operation capable of returning an error must have its error evaluated immediately via the explicit `if err != nil` check. Errors must be wrapped elegantly with contextual information using `fmt.Errorf` when propagated upward.



### C. Visibility and Encapsulation

* 
**Rule:** Package scope accessibility relies entirely on capitalization. Access modifier keywords do not exist.


* 
**Rule:** Struct attributes, functions, and variables must begin with an uppercase letter to be exported outside their defining package (Public). They must begin with a lowercase letter if they are strictly internal to the package (Private).



---

## 4. Security Standards & Vulnerability Prevention

GOVEMVC places premium importance on defensive coding. Relying on raw implementations means safety patterns must be applied explicitly at the application layer:

### A. SQL Injection Prevention

* **Rule:** Concatening user-supplied string inputs into raw SQL query statements is strictly banned.
* 
**Rule:** All database actions executed via `database/sql` must employ parameterized placeholder arguments (e.g., `$1`, `$2` in PostgreSQL or `?` in SQLite).


```go
// SECURE IMPLEMENTATION
db.QueryRow("SELECT id, password_hash FROM users WHERE email = $1", email)

```



### B. Cross-Site Scripting (XSS) Mitigation

* **Rule:** Rendering untrusted user input directly onto the document context is forbidden.
* 
**Rule:** Output generation must rely on `html/template`. The built-in template engine automatically enforces context-aware data escaping (HTML, JavaScript, CSS attributes) based on where the variable is positioned inside the template text.


* **Rule:** If raw data output is explicitly demanded, it must pass through rigorous sanitizer functions before validation.

### C. WebSocket Resource Safety & DoS Prevention

* **Rule:** Connections initiated without origin validations must be blocked. The HTTP Handler in charge of protocol upgrading must explicitly evaluate the `Origin` header against an authorized domain whitelist.
* 
**Rule:** To avoid Denial of Service (DoS) attacks and buffer manipulation vulnerabilities, incoming packet sizes must be capped. Network read and write deadlines must be declared dynamically per socket connection using native net.Conn methods (`SetReadDeadline`, `SetWriteDeadline`).


* 
**Rule:** To prevent fatal memory leakage (Goroutine Leaks), connection cancellation signals, connection closed events, or network timeouts must trigger proper return executions that close channels and cleanly destroy old connection loops.



### D. Centralized Middleware Control

* **Rule:** Global protection policies must be isolated inside the `/middleware` pipeline to ensure security policies cannot be bypassed by specific controller routes.
* **Rule:** Fundamental security tasks—such as CORS rules validation, Authorization checks (JWT/Session processing), Logging, Rate Limiting, and injecting essential protection headers (like `X-Frame-Options` and `Content-Security-Policy`)—must be intercepted and processed globally inside sequential HTTP middleware chains before handing execution down to target controllers.

---

## 5. GOVEMVC Architecture Benefits

By consistently applying the GOVEMVC convention, developers gain absolute, long-term stability:

1. 
**Complete Freedom:** The semantic folder structure gives developers total flexibility to map business logic without being constrained by rigid file placement rules imposed by a framework.


2. 
**Resource Efficiency:** Utilizing Goroutines instead of traditional operating system threads drastically reduces server RAM consumption, minimizing the risks of system crashes under high traffic loads.


3. 
**Long Code Lifecycle:** The application remains entirely safe from breaking changes or deprecation issues tied to third-party dependencies that are suddenly abandoned or drastically modified during version updates.
