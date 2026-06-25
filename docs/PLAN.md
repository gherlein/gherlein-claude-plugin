# Plan: Split Agent Dotfiles into Shareable Plugin

## Goal

Extract the shareable skills from `~/dotfiles` into a GitHub-hosted Claude Code plugin (`gherlein/claude-skills`), backed by a marketplace repo (`gherlein/claude-marketplace`), so the skills are installable by others via `/plugin install` and manageable atomically. Keep personal-only skills and all hooks/config in dotfiles.

## Outcome

- New machine bootstrap: `make stow` + `/plugin install gherlein@gherlein`
- Others install your skills: `/plugin marketplace add gherlein/claude-marketplace` + `/plugin install gherlein@gherlein`
- Third-party plugins: add/remove without touching dotfiles

---

## Skills Disposition

**Move to plugin (39 skills):**

| Skill | Category |
|-------|----------|
| `brainstorming` | Planning |
| `build-autonomous` | Planning |
| `dispatching-parallel-agents` | Planning |
| `executing-plans` | Planning |
| `finishing-a-development-branch` | Planning |
| `orchestrate` | Planning |
| `plan` | Planning |
| `spec-driven` | Planning |
| `subagent-driven-development` | Planning |
| `three-experts` | Planning |
| `writing-plans` | Planning |
| `clean-comments` | Code Quality |
| `code-review` | Code Quality |
| `edge-case-discovery` | Code Quality |
| `refactoring` | Code Quality |
| `test-as-guardrails` | Code Quality |
| `test-driven-development` | Code Quality |
| `verification-before-completion` | Code Quality |
| `engineering-principles` | Standards |
| `gitignore-policy` | Standards |
| `llm-context` | Standards |
| `makefile-builds` | Standards |
| `git-ops` | Git |
| `receiving-code-review` | Git |
| `requesting-code-review` | Git |
| `using-git-worktrees` | Git |
| `go-performance` | Language: Go |
| `go-usb` | Language: Go |
| `postgresql` | Language: DB |
| `rest-api-design` | Language: API |
| `web-frontend` | Language: Web |
| `documentation` | Docs |
| `codebase-memory` | Onboarding |
| `evidence-based-debugging` | Debugging |
| `systematic-debugging` | Debugging |
| `learn` | Onboarding |
| `onboard` | Onboarding |
| `refine` | Onboarding |
| `reverse-engineer` | Onboarding |

**Keep in dotfiles (4 skills — personal only):**

| Skill | Reason |
|-------|--------|
| `emoji` | Personal preference |
| `plan-todo` | Tightly coupled to personal workflow |
| `using-superpowers` | References your specific setup |
| `writing-skills` | Internal skill-authoring tooling |

---

## Phase 1: Create the Plugin Repo

### 1.1 Create the directory structure locally

```bash
mkdir -p ~/claude-skills/.claude-plugin
mkdir -p ~/claude-skills/skills
```

### 1.2 Create the manifest

Create `~/claude-skills/.claude-plugin/plugin.json`:

```json
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

### 1.3 Copy skills from dotfiles into the plugin

```bash
SKILLS=(
  brainstorming build-autonomous dispatching-parallel-agents executing-plans
  finishing-a-development-branch orchestrate plan spec-driven
  subagent-driven-development three-experts writing-plans
  clean-comments code-review edge-case-discovery refactoring
  test-as-guardrails test-driven-development verification-before-completion
  engineering-principles gitignore-policy llm-context makefile-builds
  git-ops receiving-code-review requesting-code-review using-git-worktrees
  go-performance go-usb postgresql rest-api-design web-frontend
  documentation codebase-memory evidence-based-debugging systematic-debugging
  learn onboard refine reverse-engineer
)

for skill in "${SKILLS[@]}"; do
  cp -r ~/.claude/skills/$skill ~/claude-skills/skills/
done
```

Verify count:

```bash
ls ~/claude-skills/skills/ | wc -l   # should print 39
```

### 1.4 Create README.md

Create `~/claude-skills/README.md`:

```markdown
# gherlein/claude-skills

Claude Code plugin providing engineering discipline skills for planning,
code quality, Go, TypeScript, PostgreSQL, git workflow, and debugging.

Disclaimer: This works for me — that's the entire guarantee. Built with AI
in the loop, so check your own biases before you love it or hate it on
principle. Use at your own risk, fork freely, and don't @ me when it
explodes. (But do drop me a note if it helps — pay it forward.)

## Install

/plugin marketplace add gherlein/claude-marketplace
/plugin install gherlein@gherlein
/reload-plugins

## Skills

Skills are namespaced under `gherlein:` — e.g. `/gherlein:code-review`.
```

### 1.5 Test the plugin locally before pushing

```bash
claude --plugin-dir ~/claude-skills
```

Inside the session, verify a few skills work:
```
/gherlein:code-review
/gherlein:engineering-principles
/gherlein:go-performance
```

Run `/help` and confirm 39 skills appear under the `gherlein` namespace.

### 1.6 Validate

```bash
cd ~/claude-skills
claude plugin validate
```

Fix any reported issues before continuing.

### 1.7 Create and push the GitHub repo

```bash
cd ~/claude-skills
git init
git add .
git commit -m "initial: gherlein claude-skills plugin"
gh repo create gherlein/claude-skills --public --source=. --push
```

---

## Phase 2: Create the Marketplace Repo

### 2.1 Create the marketplace directory

```bash
mkdir -p ~/claude-marketplace/.claude-plugin
```

### 2.2 Create marketplace.json

Create `~/claude-marketplace/.claude-plugin/marketplace.json`:

```json
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

### 2.3 Create and push the GitHub repo

```bash
cd ~/claude-marketplace
git init
git add .
git commit -m "initial: gherlein claude-marketplace"
gh repo create gherlein/claude-marketplace --public --source=. --push
```

---

## Phase 3: Update Dotfiles

All edits in this phase are to files under `~/dotfiles/claude/.claude/` (the stow source). Do not edit `~/.claude/` directly.

### 3.1 Update settings.json

Edit `~/dotfiles/claude/.claude/settings.json` to add `extraKnownMarketplaces`. The final file:

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
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Grep|Glob|Read|Search",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/cbm-code-discovery-gate"
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/gitignore-gate"
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/cbm-session-reminder" }
        ]
      },
      {
        "matcher": "resume",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/cbm-session-reminder" }
        ]
      },
      {
        "matcher": "clear",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/cbm-session-reminder" }
        ]
      },
      {
        "matcher": "compact",
        "hooks": [
          { "type": "command", "command": "~/.claude/hooks/cbm-session-reminder" }
        ]
      }
    ]
  }
}
```

### 3.2 Remove migrated skills from dotfiles

```bash
SKILLS=(
  brainstorming build-autonomous dispatching-parallel-agents executing-plans
  finishing-a-development-branch orchestrate plan spec-driven
  subagent-driven-development three-experts writing-plans
  clean-comments code-review edge-case-discovery refactoring
  test-as-guardrails test-driven-development verification-before-completion
  engineering-principles gitignore-policy llm-context makefile-builds
  git-ops receiving-code-review requesting-code-review using-git-worktrees
  go-performance go-usb postgresql rest-api-design web-frontend
  documentation codebase-memory evidence-based-debugging systematic-debugging
  learn onboard refine reverse-engineer
)

for skill in "${SKILLS[@]}"; do
  rm -rf ~/dotfiles/claude/.claude/skills/$skill
done
```

Verify only the 4 personal skills remain:

```bash
ls ~/dotfiles/claude/.claude/skills/
# expected: emoji  plan-todo  using-superpowers  writing-skills
```

### 3.3 Update CLAUDE.md

Add the following to the "For AI Agents" block near the top of `~/dotfiles/claude/.claude/CLAUDE.md`, after the existing bullet points:

```markdown
- Core skills are installed via the `gherlein` marketplace plugin, not from
  this dotfiles repo. On a new machine, after `make stow`, run:
  `/plugin install gherlein@gherlein` then `/reload-plugins`
```

### 3.4 Commit dotfiles changes

```bash
cd ~/dotfiles
git add claude/.claude/settings.json
git add claude/.claude/skills/
git add claude/.claude/CLAUDE.md
git status   # verify only the expected files are staged
git commit -m "agent: migrate 39 skills to gherlein/claude-skills plugin"
```

---

## Phase 4: End-to-End Verification

Start a fresh Claude Code session (so no cached plugin state):

```bash
claude
```

Inside the session:

```
# Install from marketplace (marketplace is pre-registered via settings.json)
/plugin install gherlein@gherlein
/reload-plugins

# Verify skills appear
/help

# Spot-check a few
/gherlein:engineering-principles
/gherlein:code-review
/gherlein:go-performance

# Verify personal skills still work (short names, no namespace)
/using-superpowers
/writing-skills
```

Check the plugin manager:
```
/plugin list          # should show gherlein@gherlein installed
```

---

## Phase 5: New Machine Smoke Test (optional but recommended)

On a second machine or a Docker container, confirm the full bootstrap works:

```bash
# 1. Stow dotfiles as usual
cd ~/dotfiles && make stow

# 2. Start Claude and install the plugin
claude
# inside session:
# /plugin install gherlein@gherlein
# /reload-plugins
# /gherlein:code-review   <- should work
```

---

## Rollback

If anything goes wrong:

```bash
# Restore skills from the plugin repo back to dotfiles
cp -r ~/claude-skills/skills/* ~/dotfiles/claude/.claude/skills/

# Revert settings.json (remove extraKnownMarketplaces)
# edit ~/dotfiles/claude/.claude/settings.json manually

# Revert CLAUDE.md edit
git -C ~/dotfiles checkout claude/.claude/CLAUDE.md

cd ~/dotfiles && make restow
```

---

## Post-Migration: Managing Third-Party Plugins

```bash
# Try a third-party plugin
/plugin marketplace add scaccogatto/okf-skills
/plugin install okf@scaccogatto
/reload-plugins

# Remove it atomically
/plugin marketplace remove scaccogatto
/reload-plugins

# List what's installed
/plugin list
```

## Post-Migration: Adding a New Skill to Your Plugin

```bash
# 1. Add the skill to the plugin repo
mkdir -p ~/claude-skills/skills/my-new-skill
# write ~/claude-skills/skills/my-new-skill/SKILL.md

# 2. Bump the version in plugin.json
# edit ~/claude-skills/.claude-plugin/plugin.json: "version": "1.1.0"

# 3. Commit and push
cd ~/claude-skills
git add .
git commit -m "add my-new-skill"
git push

# 4. Update the installed plugin
/plugin marketplace update gherlein
/reload-plugins
```
