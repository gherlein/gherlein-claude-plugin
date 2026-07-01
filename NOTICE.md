# Attribution

This project includes work derived from the **Superpowers** project by
Jesse Vincent (https://github.com/obra/superpowers), used under the MIT License.

Portions Copyright (c) 2025 Jesse Vincent.

A pristine, unmodified snapshot of the upstream skills is vendored at
`vendor/superpowers/` and pinned to:

    obra/superpowers @ f268f7c953744036f0fa7e9d4b73535c04e57cb8

(see `vendor/superpowers/PINNED_AT.txt`). That snapshot is the attribution
baseline and the diff target for controlled refreshes; the skills we actually
ship are adapted derivatives under `skills/`.

## Derived skills

The following skills in `skills/` are derived from the corresponding upstream
Superpowers skills (namespace-rewritten and edited for this plugin). Each carries
`source: obra/superpowers@<sha>` and `license: MIT` in its frontmatter:

- brainstorming
- dispatching-parallel-agents
- executing-plans
- finishing-a-development-branch
- receiving-code-review
- requesting-code-review
- subagent-driven-development
- systematic-debugging
- test-driven-development
- using-git-worktrees
- using-superpowers
- verification-before-completion
- writing-plans
- writing-skills

The file `skills/writing-skills/anthropic-best-practices.md` is derived from
Anthropic's Claude Code skill-authoring documentation and is Copyright (c)
Anthropic.

All other skills in this plugin are original works Copyright (c) 2026 Greg Herlein.

## Upstream MIT License

```
MIT License

Copyright (c) 2025 Jesse Vincent

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
