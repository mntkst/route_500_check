# Route500Check

Route500Check is a lightweight checker focused on **HTTP 500 errors** in Rails applications.
It does not depend on Rails internals and checks pages via real HTTP requests, just like end users.

* Focused on HTTP 500 detection
* Safe for large-scale sites (anti-runaway design)
* Suitable for CI / cron jobs

Route500Check is designed as a **safety-focused operational tool**, not a crawler or scanner.

---

## Installation

```ruby
gem "route_500_check"
```

```bash
bundle install
bundle exec rails generate route500_check:install
```

---

## Basic Usage

### config/route_500_check.rb

```ruby
base_url "http://localhost:3000"
default_limit 100

route "/"

route "/foo/:id" do
  id 1000..9999
  sample 10
end
```

### Run

```bash
bundle exec route500check
```

### Production (recommended)

```bash
ROUTE500CHECK_BASE_URL=https://example.com ONLY=public bundle exec route500check
```

---

## base_url Priority

```
ENV["ROUTE500CHECK_BASE_URL"]
↓
DSL base_url
↓
error
```

In production environments, it is recommended to use environment variables
instead of modifying the DSL configuration.

---

## ONLY=public

```bash
ONLY=public bundle exec route500check
```

Runs checks only for public-facing pages.

Default excluded prefixes:

```
/admin
/api
/internal
/rails
/assets
/health
```

Custom prefixes:

```ruby
only_public do
  exclude_prefix "/admin"
  exclude_prefix "/api"
end
```

---

## Safety Guards

Route500Check includes multiple safety mechanisms to prevent accidental overload
or misuse.

### default_limit (global hard limit)

```ruby
default_limit 100
```

Absolute upper bound for the total number of expanded routes.

If the expanded route count exceeds this limit, execution stops **before any HTTP
requests are sent**.

### route limit

```ruby
limit 20
```

Effective rule:

```
min(route_limit, default_limit)
```

---

## sample

```ruby
sample 10
```

* Random selection per route
* No duplicate URLs within the same route
* Applied before global limits

---

## ignore_status

```ruby
ignore_status [502, 503]
```

Affects exit code determination only.
Statuses are still logged and written to JSON output.

---

## Output

### STDOUT

Human-readable logs intended for operators.

### JSON (always generated)

File: `route_500_check_result.json`
Location: current working directory

Includes:

* Summary (status counts, latency)
* Detailed per-route results

---

## Exit Codes

Route500Check separates exit codes by intent, making it safe for automation.

| Exit code | Meaning                                                        |
| --------- | -------------------------------------------------------------- |
| `0`       | No HTTP 500 errors detected                                    |
| `1`       | Configuration or safety limit triggered (no requests executed) |
| `2`       | Runtime error or HTTP 500 detected                             |

### Exit code `1` (Configuration / Safety)

Exit code `1` indicates that Route500Check stopped **before sending any HTTP
requests**, for example:

* Expanded route count exceeds `default_limit`
* Route sampling or limit configuration prevents safe execution

Example output:

```text
[route_500_check][CONFIG] Route expansion exceeded safety limit.
- expanded routes: 122
- default_limit:   10

This is NOT a runtime error.
Adjust default_limit or route sample/limit settings.
```

This exit code does **not** indicate HTTP 500 errors.

---

## Security Considerations

Route500Check is intended for **site owners and operators** to monitor their own
applications.

### Controlled Request Expansion

To prevent accidental overload or abuse:

* All routes must be explicitly defined
* Total request count is validated **before execution**
* Execution stops immediately if safety limits are exceeded
* No HTTP requests are sent when validation fails

### Not a Scanning Tool

Route500Check intentionally avoids features common in scanning or crawling tools:

* No automatic discovery
* No recursive crawling
* No parallel request amplification
* No authentication or authorization bypass

### Clear Failure Semantics

Configuration and safety stops are clearly distinguished from runtime failures:

* Configuration / safety violations return exit code `1`
* Runtime errors and HTTP 500 detection return exit code `2`

This separation reduces the risk of misinterpretation in CI, cron jobs, and
monitoring systems.

### Intended Usage

Route500Check is suitable for:

* Verifying critical user-facing routes
* Detecting HTTP 500 regressions
* Safe execution in production cron jobs and CI pipelines

It is **not intended for penetration testing, stress testing, or content
discovery**.

---

## License

MIT
© mntkst
