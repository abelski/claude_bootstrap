# Skill authoring convention

Convention used consistently across this machine's other repos, following the
[Agent Skills specification](https://agentskills.io/specification).

## Scope

Anything authored for a specific project — a command, a skill, an agent — goes in that project's
own `.claude/` directory, never the user-global `~/.claude/`. Project scope means it's checked
into the repo, versioned with the code it applies to, and available to anyone who clones it;
global scope is for genuinely cross-project tooling only.

## Required structure

```
.claude/
└── skill-name/
    ├── SKILL.md          # Required: YAML frontmatter + Markdown instructions
    ├── scripts/           # Optional: executable code
    ├── references/        # Optional: detailed documentation
    └── assets/             # Optional: templates, resources
```

## `SKILL.md` frontmatter

```yaml
---
name: skill-name          # lowercase, hyphens only, max 64 chars
description: |            # max 1024 chars — what it does AND when to use it
  ...
license: Proprietary      # optional
compatibility: ...        # optional — only if env requirements exist
allowed-tools: Bash Read  # optional, experimental
---
```

Rules:

- `name` must match the parent directory name.
- No uppercase, no consecutive hyphens, no leading/trailing hyphens.
- `description` states both *what* the skill does and *when* to invoke it — that's the only
  signal an agent has for whether to pick it up unprompted.
- Keep `SKILL.md`'s body under 500 lines; move heavy reference material to `references/` files
  and point at them rather than inlining.
- Write step-by-step, numbered instructions, not prose — an agent following the skill re-reads it
  fresh each time and needs an unambiguous sequence.
- Parse `$ARGUMENTS` explicitly in step 1 if the skill takes input.
- Add a confirmation step before any destructive action (delete, overwrite, external-system
  mutation).
- End with a report/summary step so the caller knows what happened.
- Add a "Gotchas" section for anything non-obvious a future reader would otherwise rediscover the
  hard way.
