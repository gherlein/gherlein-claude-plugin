# Changelog

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

## v1.0.0

- Initial gherlein skills plugin (39 skills).
