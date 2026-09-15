# claude_bootstrap

Reusable Claude Code setup pulled out of this machine's working repos — the parts that are
generic enough to drop into a new project instead of rebuilding from scratch each time.

## What's here

- **[CLAUDE.md](CLAUDE.md)** — a starter set of working practices (planning, testing, git/deploy
  safety, knowledge capture). Copy into a new project's `CLAUDE.md` and trim to what fits.
- **`.claude/skills/`**
  - `feature-analyst` — clarify → plan → approve → hand off to `ralph-implement`.
  - `ralph-implement` — bounded, resumable, self-correcting loop that executes a checklist plan.
  - `frontend-design` — guidance for distinctive, non-generic UI work.
  - `sql` — ad-hoc query runner against a project's database.
  - `update-readme` — keep README.md in sync with real changes only.
  - `triage` — bulk-intake sibling to `feature-analyst`: fetch unresolved issues from this
    project's own tracker (source left for the project to plug in), filter spam/test noise, draft
    a bugfix plan per confirmed issue into `plans/triage/active/`.
  - `fix-issue-from-triage` — companion to `triage`: execute one drafted plan via
    `ralph-implement`, confirm resolution with the user, then update the tracker (mechanism left
    for the project to plug in) and move the plan to `implemented/`.
- **`.claude/agents/`**
  - `ralph-implementer` — the mechanical worker `ralph-implement` spawns per pass.
  - `ralph-reviewer` — read-only code-review gate (security, dead code, over-engineering,
    config-vs-hardcoded, architecture fit) — optional add-on, not wired into `ralph-implement` by
    default; see the note at the bottom of that skill.
  - `spec-writer` — maintains `specs/<component>.md`, a living current-behavior doc (Gherkin
    scenarios) written after a plan's Definition-of-Done gate passes — optional add-on, invoked
    from `feature-analyst`'s wrap-up only if a project uses this convention.
  - `uat-tester` — black-box PASS/FAIL/INCONCLUSIVE verifier with zero codebase access, driving
    the running app via a project-supplied instrument (CLI, HTTP call, probe script) — optional
    add-on, invoked from `feature-analyst`'s Phase 4.5 only when a plan has a `## UAT
    verification` section.
- **`.claude/output-styles/talk-to-me.md`** — short, blunt, plain-language replies.
- **`docs/skill-authoring.md`** — the Agent Skills spec convention used across these repos.
- **`docs/patterns.md`** — heavier patterns seen elsewhere (a tiered plan-and-verify loop with
  black-box verification, a deploy-safety protocol, agent-loop design notes) that are pointers to
  their source repo, not copies — too coupled to genericize until actually needed.
- **`workflow-templates/`** — CI templates (Python lint+test, Python dependency audit).

## How to use it

Copy what you need into a new project's `.claude/` and `CLAUDE.md` — this repo isn't meant to be
symlinked or installed as a dependency, it's a catalog to pull from and adapt per-project.

## What got left out

Anything tightly coupled to one project's internal APIs or business domain (internal-portal
scrapers, chat-bot-specific scaffolding, a specific product's cloud/LLM-backend invariants).
Those stay in their source repos; `docs/patterns.md` captures the generalizable shape of the more
interesting ones without naming where they came from.
