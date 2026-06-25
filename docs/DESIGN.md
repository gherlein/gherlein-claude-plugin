# Design: gherlein/claude-skills Plugin

See `PLAN.md` for the full migration plan. This document summarizes the architecture.

## Structure

```
claude-skills/                    # Plugin repo root
├── .claude-plugin/
│   └── plugin.json               # Plugin manifest (name, version, author)
├── skills/                       # 39 skill directories
│   ├── brainstorming/
│   │   └── SKILL.md
│   ├── code-review/
│   │   └── SKILL.md
│   └── ...                       # (39 total)
├── README.md
└── .gitignore

claude-marketplace/               # Marketplace listing repo
├── .claude-plugin/
│   └── marketplace.json          # Points at gherlein/claude-skills
└── README.md
```

## Plugin Namespace

All skills are served under the `gherlein:` namespace.
Example: `/gherlein:code-review`, `/gherlein:engineering-principles`.

## Skills Disposition

- **39 skills** in this plugin (all general engineering discipline skills)
- **4 skills** remain personal-only in `~/.claude/skills/`:
  `emoji`, `plan-todo`, `using-superpowers`, `writing-skills`

## settings.json Change

`extraKnownMarketplaces` added to `~/.claude/settings.json` so Claude Code
knows about `gherlein/claude-marketplace` without a manual `/plugin marketplace add`.

## Bootstrap Sequence (new machine)

```
make stow                          # install dotfiles
/plugin install gherlein@gherlein  # install this plugin
/reload-plugins                    # activate
```
