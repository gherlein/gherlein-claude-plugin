---
name: build-autonomous
description: Complete autonomous design-build-test cycle from requirements through final documentation
disable-model-invocation: true
---

# Autonomous Full-Cycle Implementation

Use when the user wants a complete hands-off implementation from design through delivery.

## When to Use

- User says "design and build this autonomously"
- User says "build-autonomous" or invokes this skill
- User provides requirements and wants minimal interaction until completion
- Complex features requiring full design-plan-implement-test-document cycle

## Complete Workflow

### Phase 1: Context Loading

Load the full execution context:

1. Read `~/.claude/INDEX.md`
2. Identify the project's languages, frameworks, and domains from the approved spec and any existing code
3. Read every relevant security rule file listed in INDEX.md for those languages and domains -- at minimum always read `~/.claude/security-rules/_core/owasp-2025.md`
4. Note which skills from INDEX.md apply to this project (e.g., `postgresql`, `rest-api-design`, `web-frontend`) -- invoke them as needed during design and implementation phases

### Phase 2: Sub-Agent Team Assembly

Create specialized sub-agents for parallel work:

1. **Design Agent** - Architecture and system design
2. **Test Planning Agent** - Test strategy and test plan creation
3. **Implementation Agent(s)** - Code implementation per module/service
4. **Review Agents** - Spec compliance, design, security reviews (post-implementation)

### Phase 3: Design and Planning

**With subagents:** run design and test planning agents in parallel.
**Without subagents:** run design first, then test planning, in the same session.

**Design Agent Tasks (or: design pass in current session):**
- Analyze the approved spec from Phase 0 and all constraints
- Create architecture (modules, boundaries, contracts, state model)
- Define interfaces (APIs, protocols, schemas)
- Document constraints and invariants
- Write to `docs/DESIGN.md`
- Update `PROJECT.md` if it exists with project-specific details

**Test Planning Agent Tasks (or: test planning pass in current session):**
- **Invoke the `test-as-guardrails` skill** to structure the plan — use its edge-case categories (boundary, nil/empty, error propagation, concurrency, network, resource) and its language-specific testing patterns (Go, web, embedded, distributed) as the template
- Design test strategy (unit, integration, e2e)
- Define test phases aligned with implementation phases
- Specify test coverage targets
- Document edge cases and failure scenarios (enumerate per the `test-as-guardrails` edge-case matrix)
- Define the sub-30-second smoke suite to run after every phase
- Record the mocking policy (mocking as a last resort; prefer in-memory fakes; never mock your own code)
- **If the project exposes any network API** (HTTP/REST, gRPC, GraphQL, WebSocket): **invoke the `api-canary` skill** to plan the external black-box canary — the exposed-endpoint inventory and the smoke/contract/auth/negative/latency tiers become part of the test strategy
- Write to `docs/TEST-PLAN.md`

**Update Configuration:**
- If domain-specific settings provided (e.g., "service health every 5 minutes", "7-day forecast"), update `CLAUDE.md` project instructions with these as requirements
- Document any service-level parameters, refresh intervals, or constraints

### Phase 4: Project Infrastructure Setup

Before implementation begins, ensure proper version control and file management:

**Git Repository Initialization:**
1. Check if `.git` directory exists
2. If NOT exists: run `git init`
3. Verify git is properly initialized

**Gitignore Configuration:**
1. Check if `.gitignore` exists
2. If exists: verify it contains mandatory entries (see below)
3. If NOT exists OR missing entries: create/update `.gitignore` with:
   - **Mandatory entries** (always include):
     - `.env`
     - `.envrc`
     - `*~` (emacs backups)
     - `bin/`
   - **Language-specific entries** (add based on project type):
     - **Go**: `vendor/`
     - **Node/TypeScript**: `node_modules/`, `dist/`
     - **Python**: `__pycache__/`, `*.pyc`, `.venv/`
     - **C/C++**: `*.o`, `*.a`, `*.so`, `build/`
     - **Rust**: `target/`
4. Do NOT overwrite existing entries, only append missing ones

### Phase 5: Phased Implementation

Each Implementation Agent **must invoke two skills** at the start of its work:
- **`test-driven-development`** — governs the order: a failing test before any production code, no exceptions (Red-Green-Refactor with a verified red).
- **`test-as-guardrails`** — governs the quality of those tests: strict assertions, the mocking-as-last-resort policy, the edge-case matrix from `docs/TEST-PLAN.md`, and the language-specific patterns for the project's stack.

Where sub-agents are available, apply the `test-as-guardrails` three-context workflow to defeat specification gaming: write implementation and tests in separate fresh contexts, and triage any failure in a third fresh context (bug in code, or wrong test?).

For projects that expose a network API, once the API surface for a phase is implemented, **invoke the `api-canary` skill** to generate/extend the standalone black-box canary module (`canary/`, no imports of the service). The canary is a deliverable built alongside the code, not after it.

Follow the Autonomous Implementation Protocol from CLAUDE.md:

1. Break design into discrete phases with clear boundaries
2. Implement ONE phase at a time
3. After each phase:
   - Run ALL tests for that phase (`make test` or equivalent)
   - Run the sub-30-second smoke suite defined in `docs/TEST-PLAN.md` (e.g. `go test ./... -short`) and the concurrency checks under the race detector where the stack supports it (e.g. `-race`)
   - If any test fails: **invoke `systematic-debugging`** to diagnose the root cause before attempting a fix — never guess or retry blindly; triage per the `test-as-guardrails` third-context rule
   - After fixing, re-run tests; repeat until ALL pass
   - Do NOT proceed to next phase with failing tests
4. Repeat until all phases complete

### Phase 6: Full Integration Validation

After all phases implemented:

1. Run entire test suite end-to-end
2. Run the full smoke suite and, where supported, the concurrency checks under the race detector (per `test-as-guardrails`)
3. For API projects: start the service and run the `api-canary` smoke + contract tiers against the running instance from outside the process; run `make drift` to confirm no exposed endpoint is undocumented or missing
4. Run build (`make build`)
5. Run linters if configured
6. If anything fails: **invoke `systematic-debugging`** to diagnose before fixing, then iterate until everything passes

### Phase 7: Review Gate

**With subagents:** invoke `dispatching-parallel-agents` to launch all three reviewers simultaneously.
**Without subagents:** run all three reviews sequentially in the current session, writing each output file before starting the next.

Three reviews — run in parallel or sequentially depending on capability:

1. **Spec Compliance Review**
   - Compare implementation vs requirements and `docs/DESIGN.md`
   - Flag deviations, missing requirements, undocumented behavior
   - Write to `.llm/reviews/spec-review.md`

2. **Design/Architecture Review**
   - Verify interfaces, data flow, error handling patterns
   - Check deployment target compatibility
   - Verify adherence to code quality rules in CLAUDE.md
   - Write to `.llm/reviews/design-review.md`

3. **Security Review**
   - Read the security rule files loaded in Phase 1 as the authoritative checklist
   - Full audit against those rules (OWASP top 10, language-specific, framework-specific)
   - Input validation boundaries
   - Credential handling
   - Injection vectors
   - Dependency risks
   - Write to `.llm/reviews/security-review.md`

### Phase 8: Review Remediation

1. Read all three review files
2. Triage findings: critical > high > medium > low
3. Fix all critical and high findings (iterate with tests after each fix)
4. Document deferred medium/low findings with rationale in `.llm/reviews/deferred.md`
5. Re-run full test suite to confirm no regressions

### Phase 9: Verification Before Completion

**Invoke `verification-before-completion`** before writing documentation or declaring the work done. This skill enforces a final gate — do not skip it.

### Phase 10: Documentation

Write `README.md` with:
- Project summary and purpose
- Architecture overview (reference `docs/DESIGN.md`)
- Build instructions
- Test instructions
- Deployment instructions (if applicable)
- Configuration (environment variables, config files)
- Usage examples
- Development workflow

### Phase 11: Finishing the Development Branch

**Invoke `finishing-a-development-branch`** as the terminal step. This skill handles final branch cleanup, commit hygiene, and any remaining integration steps before the work is considered delivered.

## Key Constraints

- **Never skip phases** - each phase must complete and pass tests before next
- **Never skip reviews** - all three reviews must complete before declaring done
- **Never leave failing tests** - use `systematic-debugging` to diagnose, then iterate until all tests pass
- **Test-first always** - `test-driven-development` is mandatory for every Implementation Agent
- **Tests must be meaningful** - `test-as-guardrails` is mandatory for test planning (Phase 3) and implementation (Phase 5); strict assertions, edge-case matrix, mocking as a last resort
- **External API validation** - for projects exposing a network API, `api-canary` is mandatory: a standalone black-box canary (no service imports) is a deliverable, and its smoke/contract tiers plus drift check run in the Phase 6 integration gate
- **Minimal user interaction** - autonomous execution throughout
- **Document as you go** - design docs, test plans, and README are deliverables, not afterthoughts

## Invocation Pattern

User says:
> "Build this autonomously: [requirements]"

Or:
> "build-autonomous: [requirements]"

Or:
> "/build-autonomous [requirements]"

Then follow all phases sequentially with no human interaction after Phase 0 approval.

## Success Criteria

- All design documents written and committed
- All test plans documented
- All code implemented with tests written first
- For API projects: external `api-canary` module built (black-box) and its smoke/contract/drift checks passing against a running instance
- All builds successful
- All three reviews completed
- All critical/high findings remediated
- Verification-before-completion gate passed
- README.md complete and accurate
- Development branch finished and clean
