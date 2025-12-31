# Contributing to Route500Check

Thank you for your interest in Route500Check.

This project is intentionally designed to be **minimal, conservative, and operationally safe**.
Before opening issues or pull requests, please read this document carefully.

---

## Project Scope

Route500Check is a tool for:

- Detecting HTTP 500 errors
- Monitoring **your own** Rails applications
- Running safely in CI or cron jobs

It is **not** intended to be:

- A vulnerability scanner
- A brute-force or crawling tool
- A high-performance or parallel request engine

Requests that move the project toward those directions are out of scope.

---

## Reporting Bugs

Bug reports are welcome.

Please include:

- Ruby version
- Rails version
- Route500Check version
- Configuration (`route_500_check.rb`, sanitized if needed)
- Command used to execute the tool
- Expected vs actual behavior

Minimal reproduction steps are highly appreciated.

---

## Feature Requests

Feature requests are **generally not accepted**.

This project prioritizes:

- Predictable behavior
- Operational safety
- Minimal configuration surface

If you believe a change is necessary, please explain:

- Why the current behavior is incorrect
- Why this cannot be solved by configuration or documentation
- How the change avoids increasing complexity or risk

Requests that significantly expand scope will likely be declined.

---

## Pull Requests

Pull requests are accepted **only for limited cases**, such as:

- Bug fixes
- Documentation improvements
- Test improvements
- Internal refactoring that does not change behavior

Pull requests that introduce new features, DSL keywords, or behavioral changes
will likely be rejected unless discussed in advance.

---

## Design Philosophy

When contributing, please respect the following principles:

- Prefer safety over performance
- Prefer explicit configuration over magic
- Prefer recording results over automatic judgment
- Avoid features that could enable misuse (e.g., high-speed scanning)

If a contribution conflicts with these principles, it will not be merged.

---

## Legal and Ethical Use

Do not use Route500Check against systems you do not own or operate.
Unauthorized scanning or enumeration may violate laws or terms of service.

By contributing to this project, you agree to follow responsible and ethical usage guidelines.

---

## License

By contributing to Route500Check, you agree that your contributions
will be licensed under the MIT License.
