# Changelog

## v0.2.0

### Summary

This release focuses on **stability, safety, and operational clarity**.
No new features were added. Existing functionality was refined to ensure
predictable behavior in production cron jobs and CI environments.

---

### Added

* Explicit **exit code semantics** to distinguish:

  * HTTP 500 detection
  * Configuration / safety stops
  * Runtime failures
* `SECURITY.md` documenting intended usage, safety guarantees, and non-goals
* Validation layer (`DSL::Validator`) executed **before any HTTP requests**

---

### Changed

* Entry point unified through CLI (`exe/route500check` → `Route500Check.run`)
* DSL evaluation stabilized using instance-scoped execution
* Route expansion logic centralized in `RouteParamBuilder`
* Safety limit violations now raise a dedicated configuration exception
* Human-readable configuration errors clearly separated from runtime failures

---

### Safety Improvements

* Route expansion is fully deterministic and validated prior to execution
* No HTTP requests are sent when configuration validation fails
* Global and per-route limits are enforced consistently

---

### Exit Codes

| Code | Meaning                                                        |
| ---- | -------------------------------------------------------------- |
| 0    | No HTTP 500 errors detected                                    |
| 1    | Configuration or safety limit triggered (no requests executed) |
| 2    | Runtime error or HTTP 500 detected                             |

---

### Compatibility Notes

* No changes to DSL syntax
* Existing configurations continue to work as-is
* Behavior is stricter where misconfiguration previously led to silent over-execution

---

### Notes

This version intentionally avoids feature expansion.
Future releases will prioritize correctness and maintainability over additional DSL features.

---

© mntkst
