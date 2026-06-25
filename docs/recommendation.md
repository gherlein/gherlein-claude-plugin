# Recommendation: Splitting Dotfiles into a Shareable Plugin

## Current State

Your `~/.claude/` lives in `~/dotfiles` and is stow-symlinked onto the machine. It contains:

- **40+ skills** in `~/.claude/skills/` — planning, orchestration, code quality, language-domain (Go, TypeScript, PostgreSQL), AI/agent, git workflow, meta-utility
- **4 hooks** in `~/.claude/hooks/` wired via `settings.json` — gitignore-gate, cbm-code-discovery-gate, cbm-session-reminder, cbm-mcp-launch
- **Extensive security-rules** in `~/.claude/security-rules/` — OWASP, per-language, per-framework, RAG pipelines
- **CLAUDE.md + INDEX.md** — the routing layer that makes it all work together
- **settings.json** — model, theme, hook bindings

Everything is tightly coupled today: one stow package, one git history, short skill names (`/code-review`, not `/gherlein:code-review`).

---

## The Core Tension

Plugin skills are **namespaced** (`/gherlein:code-review`). Your standalone `.claude/skills/` skills are **not** (`/code-review`). You can't have both for the same skill without duplication. This means the split is a real architectural decision, not just a packaging step.

---

## Recommended Architecture: Two Layers

```
Layer 1: Dotfiles (personal, stays in stow)
  ~/.claude/CLAUDE.md          — personal prefs, identity, project rules
  ~/.claude/INDEX.md           — skill routing index
  ~/.claude/settings.json      — hooks config, marketplace registration
  ~/.claude/hooks/             — hook scripts (stay here, absolute path is fine)
  ~/.claude/security-rules/    — read-only reference material, keep in dotfiles
  ~/.claude/skills/            — personal-only skills (private, not worth sharing)

Layer 2: GitHub Plugin Repo (shareable, installed via marketplace)
  gherlein/claude-skills       — all skills worth sharing, packaged as a plugin
```

The CLAUDE.md and INDEX.md stay in dotfiles because they encode *your* personal preferences and workflow decisions — they're not shareable without modification. The skills are shareable because they encode general engineering discipline, not personal taste.

---

## Naming Decision

| Thing | Value | Rationale |
|-------|-------|-----------|
| **Plugin name** (`"name"` in `plugin.json`) | `gherlein` | Becomes the skill namespace: `/gherlein:code-review`, `/gherlein:go-performance`. Matches your GitHub username exactly — no collision possible, same pattern `scaccogatto` used for their okf-skills plugin. |
| **GitHub repo name** | `claude-skills` | Clear, discoverable, descriptive. Install command becomes `/plugin marketplace add gherlein/claude-skills` then `/plugin install gherlein@gherlein`. |

If you later want cross-agent portability (Cursor, Gemini CLI, Copilot via agentskills.io), consider a second repo `agent-skills` containing just the `SKILL.md` files with no Claude-specific plugin wrapper.

---

## Step 1: Create `gherlein/claude-skills`

Create a new GitHub repo with this structure:

```
claude-skills/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   ├── engineering-principles/SKILL.md
│   ├── spec-driven/SKILL.md
│   ├── build-autonomous/SKILL.md
│   ├── orchestrate/SKILL.md
│   ├── systematic-debugging/SKILL.md
│   ├── evidence-based-debugging/SKILL.md
│   ├── test-driven-development/SKILL.md
│   ├── test-as-guardrails/SKILL.md
│   ├── code-review/SKILL.md
│   ├── refactoring/SKILL.md
│   ├── clean-comments/SKILL.md
│   ├── edge-case-discovery/SKILL.md
│   ├── verification-before-completion/SKILL.md
│   ├── git-ops/SKILL.md
│   ├── using-git-worktrees/SKILL.md
│   ├── finishing-a-development-branch/SKILL.md
│   ├── go-performance/SKILL.md
│   ├── go-usb/SKILL.md
│   ├── makefile-builds/SKILL.md
│   ├── gitignore-policy/SKILL.md
│   ├── web-frontend/SKILL.md
│   ├── rest-api-design/SKILL.md
│   ├── postgresql/SKILL.md
│   ├── documentation/SKILL.md
│   ├── plan/SKILL.md
│   ├── writing-plans/SKILL.md
│   ├── executing-plans/SKILL.md
│   ├── brainstorming/SKILL.md
│   ├── three-experts/SKILL.md
│   ├── dispatching-parallel-agents/SKILL.md
│   ├── subagent-driven-development/SKILL.md
│   ├── onboard/SKILL.md
│   ├── reverse-engineer/SKILL.md
│   ├── learn/SKILL.md
│   ├── refine/SKILL.md
│   ├── llm-context/SKILL.md
│   └── codebase-memory/SKILL.md
└── README.md
```

Manifest:

```json
// .claude-plugin/plugin.json
{
  "name": "gherlein",
  "description": "Engineering discipline skills: planning, code quality, Go, TypeScript, PostgreSQL, git workflow, debugging.",
  "version": "1.0.0",
  "author": { "name": "Greg Herlein" },
  "homepage": "https://github.com/gherlein/claude-skills",
  "repository": "https://github.com/gherlein/claude-skills",
  "license": "MIT"
}
```

The plugin name `"gherlein"` means skills invoke as `/gherlein:code-review`, `/gherlein:go-performance`, etc.

### Skills to keep personal (stay in dotfiles, not packaged)

| Skill | Reason |
|-------|--------|
| `using-superpowers` | Meta-skill that references your specific setup |
| `writing-skills` | Internal tooling for your own skill authoring |
| `plan-todo` | Tightly coupled to your personal workflow patterns |
| `emoji` | Personal preference |

---

## Step 2: Create the Marketplace Repo

Create a second GitHub repo `gherlein/claude-marketplace`:

```
claude-marketplace/
└── .claude-plugin/
    └── marketplace.json
```

```json
// .claude-plugin/marketplace.json
{
  "plugins": [
    {
      "name": "gherlein",
      "description": "Engineering discipline skills: planning, code quality, Go, TypeScript, PostgreSQL, git workflow, debugging.",
      "source": {
        "type": "github",
        "repo": "gherlein/claude-skills"
      }
    }
  ]
}
```

This separates the catalog from the plugin content — you can later add more of your own plugins without changing the install command.

---

## Step 3: Update Dotfiles

### `settings.json` — register your marketplace automatically

Add `extraKnownMarketplaces` so any machine that stows your dotfiles gets the marketplace pre-registered:

```json
{
  "model": "sonnet",
  "theme": "dark",
  "skipDangerousModePermissionPrompt": true,
  "extraKnownMarketplaces": {
    "gherlein": {
      "source": {
        "source": "github",
        "repo": "gherlein/claude-marketplace"
      }
    }
  },
  "hooks": { ... }
}
```

### `~/.claude/skills/` — remove migrated skills

After the plugin is working, delete each skill directory that moved into the plugin. Keep only the personal-only ones listed above.

### `CLAUDE.md` — document the split

Add a note near the top of the agent instructions block:

```markdown
- Core skills are installed via the `gherlein` marketplace plugin.
  On a new machine: `/plugin install gherlein@gherlein` after stow.
```

---

## Step 4: New Machine Bootstrap Sequence

After this change, a new machine goes:

```bash
cd ~/dotfiles && make stow          # installs config, registers marketplace
claude                              # start a session
/plugin install gherlein@gherlein   # install your skills plugin
/reload-plugins                     # activate
```

Once installed, the plugin auto-updates from the git repo whenever the marketplace refreshes. Because `extraKnownMarketplaces` is in `settings.json`, the marketplace is always pre-registered on any stow'd machine — no manual `/plugin marketplace add` needed.

---

## Step 5: Managing Third-Party Plugins

For trying plugins like `scaccogatto/okf-skills`:

```bash
# Add and install
/plugin marketplace add scaccogatto/okf-skills
/plugin install okf@scaccogatto
/reload-plugins

# Atomic remove (removes all plugins from that source)
/plugin marketplace remove scaccogatto
/reload-plugins
```

**Scope decisions:**

| Scope | Use when |
|-------|----------|
| User (default) | Tools you want everywhere: LSPs, commit helpers, your own skills |
| Project | Team-shared tools: commit to `.claude/settings.json` in the repo |
| Local | Personal experiments in a specific project, not committed |

For third-party plugins you're evaluating, use **user scope** (easy to remove). For team-shared tools, use **project scope** (everyone gets it automatically when they trust the repo).

---

## Hooks: The Complication

Your current hooks reference `~/.claude/hooks/...` absolute paths in `settings.json`. This works fine for your personal dotfiles. However, **plugin hooks must be self-contained** — the hook scripts need to live inside the plugin directory and be referenced via `hooks/hooks.json`.

**For your shareable plugin:** if you want the hooks to ship with it, you'd need to:
1. Move the hook scripts into `claude-skills/hooks/bin/` 
2. Add a `hooks/hooks.json` wiring them up
3. Reference them as `./bin/cbm-session-reminder` (relative to plugin dir)

This is non-trivial because your hooks reference paths like `~/.claude/hooks/cbm-mcp-launch` that assume they're in your dotfiles. For now, the pragmatic choice is to keep hooks in dotfiles only and not bundle them in the shareable plugin. Anyone who installs your plugin gets the skills; they wire up their own hooks.

---

## Summary

| Item | Location | Rationale |
|------|----------|-----------|
| CLAUDE.md, INDEX.md | Dotfiles | Personal preferences, not shareable as-is |
| settings.json | Dotfiles | Personal config + marketplace registration |
| hooks/ scripts | Dotfiles | Absolute paths, personal tooling |
| security-rules/ | Dotfiles | Reference material, not invocable skills |
| 36+ general skills | `gherlein/claude-skills` plugin | Shareable engineering discipline |
| 4 personal skills | Dotfiles `~/.claude/skills/` | Too personal or meta to share |
| Third-party plugins | Plugin system (user/project scope) | Add/remove atomically without touching dotfiles |
