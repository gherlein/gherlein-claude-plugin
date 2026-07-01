# gherlein-claude-plugin

Claude Code plugin providing engineering discipline skills for planning,
code quality, Go, TypeScript, PostgreSQL, git workflow, and debugging.

Disclaimer: This works for me — that's the entire guarantee. Built with AI
in the loop, so check your own biases before you love it or hate it on
principle. Use at your own risk, fork freely, and don't @ me when it
explodes. (But do drop me a note if it helps — pay it forward.)

## Install

```
/plugin marketplace add gherlein/claude-marketplace
/plugin install gherlein@gherlein-marketplace
/reload-plugins
```

## Skills

Skills are namespaced under `gherlein:` — e.g. `/gherlein:code-review`.

### Skill Framework

| Skill | Purpose |
|-------|---------|
| `gherlein:using-superpowers` | Enforces proactive skill discovery and use before responding |
| `gherlein:writing-skills` | How to author, edit, and test skills |

### Planning & Orchestration

| Skill | Purpose |
|-------|---------|
| `gherlein:brainstorming` | Structured brainstorming before implementation |
| `gherlein:build-autonomous` | Full autonomous design-build-test-review cycle |
| `gherlein:dispatching-parallel-agents` | Run independent tasks concurrently |
| `gherlein:executing-plans` | Execute a pre-written plan in a fresh session |
| `gherlein:finishing-a-development-branch` | Branch cleanup and merge prep |
| `gherlein:orchestrate` | Complex project sub-agent delegation |
| `gherlein:plan` | Non-trivial feature spanning multiple packages |
| `gherlein:spec-driven` | Spec/requirements docs as source of truth |
| `gherlein:subagent-driven-development` | Rigorous two-stage review protocol |
| `gherlein:three-experts` | Multiple perspectives on complex architecture |
| `gherlein:writing-plans` | Rigorous plans with subagent review |

### Code Quality

| Skill | Purpose |
|-------|---------|
| `gherlein:clean-comments` | Remove redundant or obvious comments |
| `gherlein:code-review` | Four-category code review framework |
| `gherlein:edge-case-discovery` | Systematic missing edge case discovery |
| `gherlein:refactoring` | Safe incremental refactoring |
| `gherlein:test-as-guardrails` | Tests as guardrails during development |
| `gherlein:test-driven-development` | Test-first mandatory development |
| `gherlein:verification-before-completion` | Final gate before declaring work done |

### Standards & Conventions

| Skill | Purpose |
|-------|---------|
| `gherlein:engineering-principles` | Full principles + workflow guide |
| `gherlein:gitignore-policy` | Correct .gitignore when scaffolding repos |
| `gherlein:llm-context` | `.llm/` folder and task tracking conventions |
| `gherlein:makefile-builds` | Makefile-based build conventions |

### Git Workflow

| Skill | Purpose |
|-------|---------|
| `gherlein:git-ops` | Commit messages, cherry-pick, rebase |
| `gherlein:receiving-code-review` | Respond to review feedback with rigor |
| `gherlein:requesting-code-review` | Request a code review |
| `gherlein:using-git-worktrees` | Isolated git worktrees for feature work |

### Language & Domain

| Skill | Purpose |
|-------|---------|
| `gherlein:go-performance` | Go GC optimization, pprof, allocation reduction |
| `gherlein:go-usb` | USB, HID, serial device development in Go |
| `gherlein:postgresql` | Schema, queries, migrations, indexing |
| `gherlein:rest-api-design` | Designing or reviewing a REST API |
| `gherlein:web-frontend` | React / TypeScript / Tailwind frontend |

### Docs & Debugging

| Skill | Purpose |
|-------|---------|
| `gherlein:documentation` | READMEs, API docs, design documents |
| `gherlein:evidence-based-debugging` | Go/K8s domain debugging tools |
| `gherlein:systematic-debugging` | Disciplined root-cause-first debugging |

### Onboarding

| Skill | Purpose |
|-------|---------|
| `gherlein:learn` | Document tricky solutions for future reference |
| `gherlein:onboard` | Unfamiliar or new codebase onboarding |
| `gherlein:refine` | Iterative improvement of algorithms |
| `gherlein:reverse-engineer` | Understand an existing system's architecture |

## Development

### Adding a New Skill

```bash
# 1. Add the skill to the plugin repo
mkdir -p skills/my-new-skill
# write skills/my-new-skill/SKILL.md

# 2. Bump the version in .claude-plugin/plugin.json

# 3. Commit and push
git add .
git commit -m "add my-new-skill"
git push

# 4. Update the installed plugin
/plugin marketplace update gherlein-marketplace
/reload-plugins
```

### Bootstrap a New Machine

```bash
/plugin marketplace add gherlein/claude-marketplace
/plugin install gherlein@gherlein-marketplace
/reload-plugins
```

## Credits

Twelve skills in this plugin are derived from the **Superpowers** project by
Jesse Vincent (https://github.com/obra/superpowers), used under the MIT License
and Copyright (c) 2025 Jesse Vincent. A pristine upstream snapshot is vendored
at `vendor/superpowers/` and pinned in `vendor/superpowers/PINNED_AT.txt`. See
[`NOTICE.md`](NOTICE.md) for the full attribution and the list of derived skills.

All other skills are original works Copyright (c) 2026 Greg Herlein. This project
is MIT-licensed; see [`LICENSE`](LICENSE).
