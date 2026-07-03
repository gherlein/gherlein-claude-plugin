---
name: build-autonomous
description: "Complete design-build-test cycle that opens with two interactive, user-gated phases -- vision brainstorming into VISION.md, then requirements analysis into REQUIREMENTS.md -- and then runs autonomously through design, implementation, testing, review, and documentation. Triggers on: build this autonomously, build-autonomous, design and build this hands-off, full design-plan-implement-test-document cycle."
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

This skill is a loop. It opens with two **interactive, human-gated** phases (Phase 0.1 and 0.2). Everything from Phase 1 onward runs **autonomously** -- break for the user only when a downstream skill explicitly requires input (e.g. `systematic-debugging` surfacing a decision, a review gate needing a judgment call).

**Version-control rhythm:** all work happens on a dedicated branch created in Phase 0.1, never directly on `main`. When the project is under git, treat each phase as an atomic unit of work -- at the **end of every phase, before advancing to the next, commit all changes** with a message naming the phase (e.g. `phase 4: design`, `phase 5: implement <module>`). These per-phase commits are deliberate rollback points: if a later phase goes wrong, you can reset to the last good phase. Phase 0 already commits `VISION.md`/`REQUIREMENTS.md` at its gates; every phase from 1 onward follows the same commit-before-advancing rule.

### Phase 0: Vision and Requirements (INTERACTIVE -- the only human-gated phases)

Do NOT enter Phase 1 until the Phase 0.2 requirements gate is cleared by the user.

#### Phase 0.1: Vision (Brainstorming)

1. **Confirm version control first.** Check whether the working folder is a git
   repo (`git rev-parse --git-dir`). If it is **not**, ask the user whether they
   want one created before continuing:
   - **If yes:** run `git init` now, so `VISION.md` (and later artifacts) can be
     committed as they are written. (`.gitignore` setup still happens in Phase 4.)
   - **If no:** note that later commit, tag, and release steps will not be
     possible, and proceed without version control.
   Ask this once, up front, before the brainstorming dialogue begins.
   Once version control is in place, **create and switch to a working branch**
   named for the project -- a short kebab-case slug derived from the topic, e.g.
   `build/<topic>`. All Phase 0 and later commits land on this branch; it is the
   unit of work that gets merged or turned into a PR at the end (Phase 11). Skip
   branch creation only if the user declined version control.
2. Look for `VISION.md` in the repo root:
   - **If it exists:** read it and treat it as the starting point -- confirm and expand it with the user rather than starting over.
   - **If it does not exist:** create it and grow it as the conversation progresses.
3. **Invoke the `brainstorming` skill for its dialogue technique:** explore project context, then ask clarifying questions ONE AT A TIME (purpose, users, constraints, success criteria, non-goals), and propose 2-3 approaches with a recommendation wherever a direction is unclear.
   - **Redirect brainstorming's output to `VISION.md`.** Do not use its default dated spec path and do NOT follow its terminal `writing-plans` handoff here -- in this workflow the vision flows into Phase 0.2 (requirements), not into a plan.
4. **Document each answer into `VISION.md` as the dialogue proceeds -- do not leave
   the reasoning only in the chat.** After each meaningful exchange, fold the
   user's answer (and the rationale behind it) into the relevant section so the
   file steadily becomes a complete, self-contained, readable narrative of what is
   being built and why. `VISION.md` must stand on its own: someone who reads only
   the file -- without the conversation -- should understand the project. Use
   these sections, scaled to the project:
   - **Purpose** -- what this is, in a sentence or two
   - **Problem / motivation** -- why it is worth building; what pain it removes
   - **Primary users** -- who uses it and in what context
   - **Goals** -- what success looks like, concretely
   - **Non-goals** -- what is explicitly out of scope
   - **Key constraints** -- platform, performance, security, deployment, timeline
   - **Chosen approach** -- the direction settled on, with a brief note on the
     alternatives considered and why this one won
   - **Success criteria** -- how we will know it works
   - **Open questions** -- anything still unresolved (these seed Phase 0.2)
   Write in prose the user can actually read, not terse fragments or bare headings.
5. **GATE -- user signals done brainstorming.** When you believe the vision is
   complete, tell the user `VISION.md` is ready and ask them to read it. Continue
   the dialogue and keep updating the file until the user explicitly indicates the
   vision is complete (e.g. "done brainstorming", "vision looks good", "move on to
   requirements"). Do NOT advance on your own judgment. When they signal done,
   finalize `VISION.md` and proceed to Phase 0.2.

#### Phase 0.2: Requirements Analysis

1. **Invoke the `spec-driven` skill** for structure and authority rules. Using everything learned in Phase 0.1 plus the contents of `VISION.md`, write or edit `REQUIREMENTS.md` at the repo root. `REQUIREMENTS.md` is the authoritative, detailed requirements you will build from.
2. Derive concrete, testable requirements from the vision: functional requirements, numbered constraints (e.g. `C-001`), invariants, non-functional requirements (performance, security, deployment targets), and explicit out-of-scope items.
3. Ask targeted clarifying questions -- one at a time -- wherever the vision is ambiguous or incomplete.
4. **GATE -- user signals done with requirements analysis.** Continue editing until the user explicitly indicates requirements are complete (e.g. "requirements are done", "requirements look good", "start building"). Do NOT advance on your own judgment. When they signal done, commit `VISION.md` and `REQUIREMENTS.md`, then proceed autonomously from Phase 1 onward.

### Phase 1: Context Loading

Load the full execution context:

1. Read `~/.claude/INDEX.md`
2. Identify the project's languages, frameworks, and domains from the Phase 0 artifacts (`VISION.md` and `REQUIREMENTS.md`) and any existing code
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
- Analyze `REQUIREMENTS.md` (authoritative) and `VISION.md` from Phase 0 and all constraints
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

The work now lives on the branch created in Phase 0.1. As the terminal step:

1. **Remind the user which branch they are on** (`git branch --show-current`) and confirm every phase commit is in.
2. **Ask how to integrate**, offering two choices:
   - **Open a PR to `main`** -- push the branch and create the pull request (`gh pr create`).
   - **Merge the branch into `main`.**
3. **If they choose merge, then ask whether to delete the branch** afterward. Honor the answer: delete it only if they say yes (`git branch -d <branch>`, plus `git push origin --delete <branch>` if it was pushed); otherwise leave it in place.
4. **Invoke `finishing-a-development-branch`** to carry out the chosen path rigorously -- it verifies tests, determines the base branch, executes the merge or PR, and handles branch removal. Execute the user's choices with real `git`/`gh` actions; do not merely describe them.

## Key Constraints

- **Never skip phases** - each phase must complete and pass tests before next
- **Never skip reviews** - all three reviews must complete before declaring done
- **Never leave failing tests** - use `systematic-debugging` to diagnose, then iterate until all tests pass
- **Test-first always** - `test-driven-development` is mandatory for every Implementation Agent
- **Tests must be meaningful** - `test-as-guardrails` is mandatory for test planning (Phase 3) and implementation (Phase 5); strict assertions, edge-case matrix, mocking as a last resort
- **External API validation** - for projects exposing a network API, `api-canary` is mandatory: a standalone black-box canary (no service imports) is a deliverable, and its smoke/contract tiers plus drift check run in the Phase 6 integration gate
- **Branch + commit per phase** - all work happens on a dedicated branch created in Phase 0.1; every phase ends with a commit as a rollback point before the next begins; integration (merge or PR) is chosen by the user in Phase 11
- **Interactive only in Phase 0** - vision brainstorming and requirements analysis are human-gated; the user must explicitly signal "done" at each gate before the workflow advances
- **Minimal user interaction after Phase 0** - autonomous execution from Phase 1 onward, breaking only when a downstream skill explicitly requires input
- **Document as you go** - design docs, test plans, and README are deliverables, not afterthoughts

## Invocation Pattern

User says:
> "Build this autonomously: [requirements]"

Or:
> "build-autonomous: [requirements]"

Or:
> "/build-autonomous [requirements]"

Regardless of how much detail the user provides up front, the workflow still opens with the interactive Phase 0: brainstorm the vision into `VISION.md` (gated), then analyze requirements into `REQUIREMENTS.md` (gated). After the user clears the requirements gate, follow all remaining phases sequentially with no human interaction unless a downstream skill requires it.

## Success Criteria

- `VISION.md` brainstormed and committed; user cleared the vision gate
- `REQUIREMENTS.md` written from the vision and committed; user cleared the requirements gate
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
