# Security Policy

## Purpose

Route500Check is designed as a **safety-focused operational tool** for site owners and operators.
Its primary purpose is to detect HTTP 500 errors on explicitly defined routes using real HTTP requests,
while preventing accidental overload or misuse.

This document explains the security-related design principles and intended usage of Route500Check.

---

## Intended Usage

Route500Check is intended for:

* Monitoring critical user-facing routes
* Detecting HTTP 500 regressions in Rails applications
* Safe execution in production cron jobs and CI pipelines

It is **not intended** for:

* Penetration testing
* Stress testing or load testing
* Crawling or content discovery
* Scanning systems you do not own or operate

---

## Controlled Request Execution

Route500Check includes multiple safeguards to ensure controlled execution:

* All routes must be explicitly defined by the user
* No automatic discovery or recursive crawling is performed
* Route expansion is deterministic and predictable
* Total request count is validated **before execution**

If safety validation fails, execution stops immediately and **no HTTP requests are sent**.

---

## Safety Limits

### Global Limit (`default_limit`)

The `default_limit` setting defines an absolute upper bound for the total number of HTTP requests
that can be generated from all routes.

If the expanded route count exceeds this limit:

* Route500Check stops before sending any requests
* Exit code `1` is returned
* A clear configuration-related message is displayed

This mechanism prevents accidental overload due to misconfiguration.

### Per-route Limits

Each route may define its own:

* `limit`
* `sample`

Effective limits are calculated safely, and always respect the global `default_limit`.

---

## Exit Code Semantics

Route500Check separates exit codes by intent to reduce operational risk:

| Exit code | Meaning                                                        |
| --------- | -------------------------------------------------------------- |
| `0`       | No HTTP 500 errors detected                                    |
| `1`       | Configuration or safety limit triggered (no requests executed) |
| `2`       | Runtime error or HTTP 500 detected                             |

Exit code `1` indicates a **safety stop**, not a runtime failure and not an HTTP 500 detection.

---

## Non-goals and Explicit Limitations

To avoid misuse, Route500Check intentionally does **not** provide:

* Parallel or high-volume request execution
* Automatic endpoint discovery
* Authentication or authorization bypass mechanisms
* Rate limit evasion or throttling circumvention

Any use outside the intended scope may violate laws, regulations, or terms of service.

---

## Responsible Use

Users are responsible for ensuring that Route500Check is executed only against systems they own
or are authorized to operate.

The authors and maintainers of Route500Check assume no responsibility for misuse of this tool
outside its intended operational scope.

---

## Reporting Security Issues

If you believe you have found a security vulnerability in Route500Check itself (not in a target
application), please report it responsibly.

At this time, please open a GitHub issue with a clear description of the problem and steps to
reproduce it. Sensitive details should be minimized.

---

## Policy Updates

This security policy may be updated as the project evolves. Please review it periodically to
stay informed about Route500Check's security posture.
