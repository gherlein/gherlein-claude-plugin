# gherlein-claude-plugin

A Claude Code plugin of engineering-discipline skills: planning, code quality,
Go, TypeScript, PostgreSQL, git workflow, debugging, and full design-build-test
workflows. It ships 30 skills that either auto-trigger when your request matches
their subject or run deliberately by name.

Disclaimer: This works for me — that's the entire guarantee. Built with AI
in the loop, so check your own biases before you love it or hate it on
principle. Use at your own risk, fork freely, and don't @ me when it
explodes. (But do drop me a note if it helps — pay it forward.)

## Install

The plugin is distributed through the `gherlein-marketplace` catalog. Add the
marketplace once, then install:

```
/plugin marketplace add gherlein/claude-marketplace
/plugin install gherlein@gherlein-marketplace
/reload-plugins
```

## Updating

The marketplace pins the plugin to an exact release, so a new version is not
visible to you until you refresh the marketplace listing. To pull the latest
release into an already-installed copy:

```
/plugin marketplace update gherlein-marketplace
/plugin install gherlein@gherlein-marketplace
/reload-plugins
```

`marketplace update` refreshes the catalog metadata; `install` then re-resolves
`gherlein` to the newly published release; `reload-plugins` reloads the skills
into your current session without a restart.

## Using the skills

Skills are namespaced under `gherlein:` — invoke any of them explicitly with
`/gherlein:<name>` (e.g. `/gherlein:code-review`).

- **Auto-triggering skills** fire on their own when your request matches their
  subject — asking to review code invokes `code-review`, asking about a slow Go
  hot path invokes `go-performance`, and so on. You don't have to name them.
- **Manual-only skills** (marked *manual* below) are heavier workflows that run
  only when you invoke them by name. These are the multi-phase orchestration and
  planning flows you want to start deliberately, not have fire mid-conversation.

### Planning & orchestration

| Skill | Mode | Purpose |
|-------|------|---------|
| `build-autonomous` | manual | Two interactive gates (vision → requirements), then an autonomous design-build-test-review-document cycle |
| `plan` | manual | Four-phase planning for non-trivial features spanning multiple packages, services, or tiers |
| `spec-driven` | auto | Treat spec docs (`REQUIREMENTS.md`, `docs/DESIGN.md`) as the authoritative source; code implements them |
| `engineering-principles` | auto | Think-before-coding, simplicity-first, surgical changes, goal-driven execution |
| `subagent-driven-development` | manual | Execute an implementation plan's independent tasks with a two-stage review protocol |
| `executing-plans` | manual | Execute a pre-written plan in a fresh session with review checkpoints |
| `dispatching-parallel-agents` | manual | Run 2+ independent tasks concurrently across subagents |
| `three-experts` | manual | Multi-perspective analysis for complex architecture and design decisions |

#### The `build-autonomous` loop

`build-autonomous` is the flagship end-to-end workflow. It always opens with two
**interactive, human-gated** phases and then runs the rest **autonomously** — it
does not start building until you have signed off on what to build.

1. **Vision (brainstorming)** — reads or creates `VISION.md` in the repo root and
   uses a one-question-at-a-time dialogue to capture purpose, users, goals,
   non-goals, constraints, and success criteria. This phase loops until **you
   explicitly say you're done brainstorming**.
2. **Requirements analysis** — from the vision, writes or edits `REQUIREMENTS.md`
   (root, authoritative) via `spec-driven`: functional requirements, numbered
   constraints, invariants, non-functional requirements, and explicit
   out-of-scope items. Loops until **you explicitly say requirements are done**,
   then commits `VISION.md` and `REQUIREMENTS.md`.
3. **Autonomous build** — from here it proceeds without prompting: design
   (`docs/DESIGN.md`) → test plan → project/git setup → phased, test-first
   implementation → full integration validation → the three-way review gate
   (spec, design, security) → remediation → verification gate → `README.md` →
   finishing the development branch. It breaks for you only when a downstream
   step genuinely needs a decision.

The two gates are the contract: you own the vision and the requirements; the
plugin owns everything downstream of them.

### Code quality

| Skill | Mode | Purpose |
|-------|------|---------|
| `code-review` | auto | Four-category review framework (architecture, quality, maintainability, correctness) |
| `edge-case-discovery` | auto | Two-step discovery of missing edge cases, with Go / web / RP2040 / K8s checklists |
| `test-as-guardrails` | auto | Three-context testing workflow that prevents specification gaming |
| `refactoring` | auto | Safe incremental refactoring with continuous test verification |
| `clean-comments` | auto | Remove obvious, redundant, or process-narrating comments (WHY-not-WHAT) |
| `refine` | manual | Progressive solution improvement over three rounds of critical analysis |

### Standards & conventions

| Skill | Mode | Purpose |
|-------|------|---------|
| `makefile-builds` | auto | Build via a Makefile rather than ad hoc commands |
| `gitignore-policy` | auto | Ensure a correct `.gitignore` when scaffolding or adding files |
| `llm-context` | auto | Conventions for the `.llm/` directory (extra context and the task list) |

### Git workflow

| Skill | Mode | Purpose |
|-------|------|---------|
| `git-ops` | auto | Commit-message conventions, cherry-pick, rebase conflict resolution |
| `requesting-code-review` | manual | Verify work meets requirements before declaring done or merging |

### Language & domain

| Skill | Mode | Purpose |
|-------|------|---------|
| `go-performance` | auto | Go GC optimization, allocation reduction, pprof profiling |
| `go-usb` | auto | USB / HID / serial device development in Go (gousb, udev rules) |
| `postgresql` | auto | Schema, indexing, queries, migrations, ORM policy |
| `rest-api-design` | auto | Status codes, pagination, error format, auth, caching, OpenAPI |
| `web-frontend` | auto | React / TypeScript / Tailwind / shadcn conventions and testing |
| `api-canary` | auto | Discover exposed endpoints, then generate a black-box canary test framework |

### Docs & debugging

| Skill | Mode | Purpose |
|-------|------|---------|
| `documentation` | auto | README structure, writing style, Mermaid diagrams, API and design docs |
| `evidence-based-debugging` | auto | Closed-loop debugging with 5 Whys and Go / web / embedded / K8s tools |

### Understanding & onboarding

| Skill | Mode | Purpose |
|-------|------|---------|
| `onboard` | manual | Bootstrap `CLAUDE.md` and hierarchical context files for a new codebase |
| `reverse-engineer` | manual | 10-phase framework for systematic source analysis and architecture docs |
| `learn` | manual | Document tricky problems and their solutions for future reference |

## For maintainers

These steps publish updates to the plugin; they are not needed to install it.

The `gherlein-marketplace` catalog pins the plugin to an exact tag and commit, so
changes are invisible to installers until you tag a release **and** update the
marketplace listing.

```bash
# 1. Add or edit the skill
mkdir -p skills/my-new-skill        # write skills/my-new-skill/SKILL.md

# 2. Bump the version in .claude-plugin/plugin.json and add a CHANGELOG.md entry

# 3. Commit, tag, and push (this repo)
git add .
git commit -m "add my-new-skill"
git tag vX.Y.Z
git push && git push --tags

# 4. Point the marketplace at the new release (gherlein/claude-marketplace repo):
#    set source.ref = "vX.Y.Z" and source.commit = <new commit SHA> in
#    .claude-plugin/marketplace.json, then commit and push that repo.

# 5. Update an installed copy
/plugin marketplace update gherlein-marketplace
/plugin install gherlein@gherlein-marketplace
/reload-plugins
```

Each shipped skill must be self-contained (no foreign plugin-namespace
references). `scripts/check-self-contained.sh` enforces this, and a GitHub
Actions workflow fails the build on any violation.

## Credits

Four skills in this plugin are derived from the **Superpowers** project by Jesse
Vincent (https://github.com/obra/superpowers), used under the MIT License and
Copyright (c) 2025 Jesse Vincent: `dispatching-parallel-agents`,
`executing-plans`, `requesting-code-review`, and `subagent-driven-development`.
A pristine upstream snapshot is vendored at `vendor/superpowers/` and pinned in
`vendor/superpowers/PINNED_AT.txt`. See [`NOTICE.md`](NOTICE.md) for the full
attribution.

All other skills are original works Copyright (c) 2026 Greg Herlein. This project
is MIT-licensed; see [`LICENSE`](LICENSE).
