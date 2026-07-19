# gherlein-claude-plugin — Skills Summary

**Plugin:** `gherlein` (v1.2.0) — Greg Herlein
**Description:** Engineering discipline skills: planning, code quality, Go, TypeScript, PostgreSQL, git workflow, debugging.
**Repo:** https://github.com/gherlein/gherlein-claude-plugin (MIT)
**Invocation:** Skills are namespaced under `gherlein:` — e.g. `/gherlein:code-review`.

Skills marked **[manual]** have `disable-model-invocation: true` — they run only when explicitly invoked, not auto-triggered by the model. Skills marked **[superpowers]** are vendored from `obra/superpowers` (MIT). All others auto-trigger on the keywords listed.

Total: **41 skills**.

---

## Skill Framework & Meta

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `using-superpowers` | [superpowers] session start | Enforces proactive skill discovery — requires invoking the Skill tool before *any* response, including clarifying questions. |
| `writing-skills` | [manual][superpowers] | How to author, edit, and test skills before deployment. |
| `learn` | [manual] | Document tricky problems and their solutions in `CLAUDE.local.md` for future reference. |
| `onboard` | [manual] | Bootstrap `CLAUDE.md` and hierarchical context files for a new/unfamiliar codebase. |
| `llm-context` | `.llm/` folder, task tracking | Conventions for the `.llm/` directory (extra LLM context + active `todo.md` task list). |

## Planning & Orchestration

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `plan` | [manual] | Four-phase planning for non-trivial features spanning multiple packages, services, or tiers. |
| `writing-plans` | [manual][superpowers] | Turn a spec/requirements into a written multi-step plan before touching code. |
| `executing-plans` | [manual][superpowers] | Execute a written implementation plan in a separate session with review checkpoints. |
| `subagent-driven-development` | [manual][superpowers] | Execute plans with independent tasks in the *current* session. |
| `orchestrate` | [manual] | "Maestro" pattern — decompose complex multi-step projects into atomic tasks with sub-agent delegation. |
| `dispatching-parallel-agents` | [manual][superpowers] | Fan out 2+ independent tasks with no shared state or sequential dependencies. |
| `build-autonomous` | [manual] | Complete autonomous design→build→test cycle from requirements through final documentation. |
| `spec-driven` | requirements/spec/design docs present | Treat specs (`PROJECT.md`, `REQUIREMENTS.md`, `docs/DESIGN.md`) as authoritative; regenerate code when it diverges. |

## Thinking & Analysis

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `brainstorming` | [manual][superpowers] | Collaborative dialogue to explore intent, requirements, and design before implementation. |
| `three-experts` | [manual] | Multi-perspective analysis with three domain experts for complex architecture/design decisions. |
| `refine` | [manual] | Progressive improvement over 3 rounds of critical analysis (algorithms, performance, system design). |
| `reverse-engineer` | [manual] | 10-phase framework for source analysis, component inventory, coupling analysis, architectural docs. |
| `engineering-principles` | before non-trivial implementation | Full discipline behind CLAUDE.md: think-before-coding, simplicity-first, surgical changes, goal-driven execution, research-plan-execute-validate. |

## Code Quality & Review

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `code-review` | review this code / PR / before merge | Four-category review framework (architecture, quality, maintainability, correctness) with domain-specific safety checks. |
| `requesting-code-review` | [superpowers] finished a feature | Verify work meets requirements before declaring done or merging. |
| `receiving-code-review` | [superpowers] got review feedback | Respond to review feedback with technical rigor, not performative agreement. |
| `refactoring` | refactor / clean up / reduce duplication | Safe incremental refactoring with continuous test verification and code-smell detection (Go, frontend, distributed). |
| `clean-comments` | clean up / strip WHAT-comments | Remove obvious, redundant, or process-narrating comments; enforce WHY-not-WHAT; delete commented-out code. |
| `verification-before-completion` | [superpowers] about to say done/fixed/passing | Require running verification commands and confirming output before any success claim. |

## Testing & Debugging

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `test-driven-development` | [superpowers] implement feature / fix bug | Test-first: write a failing test before implementation. |
| `test-as-guardrails` | writing tests, meaningful tests | Three-context testing workflow preventing spec gaming; edge-case categories for Go, web, embedded, distributed. |
| `api-canary` | find all exposed APIs, external/canary tests, API drift | Discover every externally exposed endpoint, then generate a standalone black-box canary framework that probes the live service from outside the deployment boundary. |
| `edge-case-discovery` | what edge cases am I missing | Two-step systematic discovery of missing edge cases; checklists for Go, web, RP2040, K8s. |
| `systematic-debugging` | [superpowers] any bug / test failure / broken | Disciplined debugging: reproduce and find root cause before proposing a fix. |
| `evidence-based-debugging` | debug this / why failing / root cause | Closed-loop debugging with 5-Whys RCA and domain tools for Go, web, embedded, K8s. |

## Git & Workflow

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `git-ops` | commit message / cherry-pick / rebase conflict | Commit conventions, inspect-and-recreate cherry-pick, rebase conflict resolution. |
| `using-git-worktrees` | [superpowers] isolate feature work | Create isolated git worktrees with smart directory selection and safety checks. |
| `finishing-a-development-branch` | [manual][superpowers] work complete | Structured options for integrating finished work — merge, PR, or cleanup. |
| `gitignore-policy` | new repo / git init / before first commit | Ensure a correct `.gitignore` when writing files into any project with a `.git` dir. |

## Language / Domain Specific

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `go-performance` | Go slow / reduce allocations / pprof | Go GC optimization, allocation reduction, pprof profiling, escape analysis, benchmarking. |
| `go-usb` | USB device in Go / gousb / HID / udev | Go USB development with gousb, karalabe/usb, serial, HID, udev rules, troubleshooting. |
| `web-frontend` | React component / TS / Tailwind / Playwright | React/TypeScript conventions, Tailwind/shadcn styling, frontend testing (testing-library, Playwright). |
| `postgresql` | Postgres schema / index / slow query / migration | PostgreSQL best practices: data types, indexing, queries, migrations, ORM policy, monitoring, backups. |
| `rest-api-design` | design REST API / add endpoint / status code | RESTful conventions: status codes, pagination, error format, auth, caching, versioning, OpenAPI. |
| `unifi-fixed-hosts` | UniFi fixed IP / DHCP reservation / device MAC / network info | Read/add/delete fixed IP assignments on a UniFi/UDM controller, look up detected device MACs, and inspect network subnets + DHCP pools via the `gofips`/`gofimac`/`gofinet` CLIs. |

## Build & Documentation

| Skill | Trigger / Mode | Purpose |
|-------|----------------|---------|
| `makefile-builds` | build this / add a target / run make | Build via a Makefile rather than ad hoc commands; run builds safely (avoid raw `go build`). |
| `documentation` | write a README / docs / diagram / design doc | Documentation standards: README structure, writing style, Mermaid diagrams, API docs, design docs. |

---

## Notes

- **Two invocation modes.** ~half the skills are `disable-model-invocation: true` ([manual]) — heavier workflows (planning, orchestration, autonomous builds, meta-skills) that you run deliberately. The rest auto-trigger on keyword matches in their descriptions.
- **Superpowers provenance.** 12 skills are vendored from `obra/superpowers` (the disciplined-workflow set: TDD, systematic debugging, worktrees, plan execution, code-review etiquette, skill authoring).
- **Cross-references from global CLAUDE.md.** The user's global config explicitly points at `build-autonomous`, `spec-driven`, `engineering-principles`, and `clean-comments`.
- **Target audience/stack.** Skills lean toward the user's stack: Go, TypeScript/React frontends, PostgreSQL, embedded (RP2040), and Kubernetes/distributed systems.
