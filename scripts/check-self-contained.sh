#!/usr/bin/env bash
# Fail if any shipped skill references a foreign plugin namespace.
#
# Self-containment invariant: skills under skills/ may only reference the
# `gherlein:` namespace. A reference like `superpowers:test-driven-development`
# would make the plugin depend on another plugin being installed. URL schemes
# (http, https, ...) are not skill references and are allowed.
#
# The pristine baseline under vendor/ is intentionally NOT checked -- it is an
# unmodified upstream snapshot and legitimately contains upstream namespaces.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$repo_root/skills"

# A skill reference looks like `<namespace>:<skill-name>` with no space after
# the colon. Allowed namespaces / schemes are stripped before we look for any
# survivors.
allow='gherlein|https?|ftp|ftps|git|ssh|file|mailto|data|tel'

# MAC-address octets (e.g. `aa:bb:cc:dd:ee:ff`) tokenize into hex pairs like
# `aa:bb` that match the namespace pattern. A namespace ref never has both sides
# be two hex digits, so drop trailing two-hex:two-hex matches to avoid false
# positives from example MAC addresses in skills.
offenders="$(
  grep -rEno '\b[a-z][a-z0-9_-]*:[a-z][a-z0-9_-]+' "$skills_dir" --include=SKILL.md \
    | grep -vE ":(${allow}):" \
    | grep -vE ':[0-9a-fA-F]{2}:[0-9a-fA-F]{2}$' \
    || true
)"

if [[ -n "$offenders" ]]; then
  echo "ERROR: foreign plugin-namespace references found in shipped skills:" >&2
  echo "$offenders" >&2
  echo >&2
  echo "Skills must reference only the gherlein: namespace (self-containment)." >&2
  exit 1
fi

echo "OK: no foreign plugin-namespace references in skills/"
