# Changelog

## v1.1.2

- Remove the `codebase-memory` skill and its `codebase-memory-mcp` dependency.
  The skill was inert without the external MCP server (and its `cbm-*` discovery
  hooks), which is not bundled with the plugin. Plugin now ships 40 skills.
- Docs: drop stale pre-launch planning notes (`docs/DESIGN.md`, `docs/PLAN.md`,
  `docs/recommendation.md`) that referenced the old repo name, the removed skill,
  and superseded install commands. Correct the skills-summary count.
- Fix the marketplace listing to reference `gherlein/gherlein-claude-plugin`.

## v1.1.1

- Make the `clean-comments` skill description self-contained (remove the foreign
  plugin-namespace reference) so it passes `scripts/check-self-contained.sh`.

## v1.1.0

- Attribution: add `LICENSE` (MIT) and `NOTICE.md` crediting the upstream
  Superpowers project (Jesse Vincent / obra, MIT) for the twelve derived skills.
- Vendor a pristine, pinned snapshot of `obra/superpowers` at
  `f268f7c953744036f0fa7e9d4b73535c04e57cb8` under `vendor/superpowers/` as the
  attribution baseline and controlled-refresh diff target.
- Add `source:`/`license:` provenance frontmatter to each derived skill.
- Self-containment: rewrite `superpowers:` references to `gherlein:`; repoint the
  code-reviewer dispatch to a `general-purpose` subagent with the bundled
  `code-reviewer.md` template; de-namespace the optional `elements-of-style`
  reference.
- Add `scripts/check-self-contained.sh` and a GitHub Actions workflow that fails
  the build on any foreign plugin-namespace reference in shipped skills.
- Fix stale repo names in `README.md` and `plugin.json` (was `claude-skills`;
  now `gherlein-claude-plugin`) and correct the install command to
  `gherlein@gherlein-marketplace`.
- Bundle the enforcement layer so the plugin is self-enforcing for anyone who
  installs it: add `using-superpowers` (proactive skill discovery) and
  `writing-skills` (skill authoring), both attributed to obra/superpowers, with
  `writing-skills/anthropic-best-practices.md` credited to Anthropic. Plugin now
  ships 41 skills.

## v1.0.0

- Initial gherlein skills plugin (39 skills).
