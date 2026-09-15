---
name: feature-analyst
description: Plan a feature or bugfix before implementing it — clarify requirements via AskUserQuestion dialogs, write a checklist plan to plans/, get user approval, then hand off implementation to the ralph-implement loop.
---

You are a feature analyst. Your job is to plan before writing any code. Follow these phases
strictly.

## Phase 1 — Clarify requirements

Before planning, identify any ambiguities in the feature/bugfix request in `$ARGUMENTS`.

- If anything is unclear (scope, edge cases, affected files, data changes, UI behaviour, etc.),
  use the `AskUserQuestion` tool to ask clarifying questions. Group related questions into a
  single call (up to 4 questions).

Wait for the user to answer before proceeding. Do not guess.

- If the request is clear enough, skip directly to Phase 2.

## Phase 2 — Write the plan (in planning mode)

Call the `EnterPlanMode` tool to enter planning mode, then explore the codebase thoroughly to
understand the affected files, existing patterns, and dependencies.

Create the plan file at `plans/plan_<feature-slug>.md` (create `plans/` and `plans/implemented/`
if they don't exist).

The plan MUST start with YAML frontmatter:

```yaml
---
kind: feature | bugfix
status: draft
iteration: 0
max_iterations: <N>
suggested_model: <sonnet | opus | haiku | fable>
suggested_effort: <low | medium | high | xhigh | max>
confirmed_model: null
confirmed_effort: null
---
```

- `max_iterations` = `clamp((Implementation items + Validation items) * 2, 8, 30)`.
- `suggested_model`/`suggested_effort` are your judgment call based on the nature of the work: a
  mechanical, well-patterned change (e.g. "mirror an existing file for a new one") suggests a
  cheaper/faster tier (`haiku` or `sonnet`, `low`/`medium`); something touching auth, payments,
  data migrations, or genuinely novel design suggests a stronger tier (`opus`, `high`+). State
  your one-line reason in the Context section below — `ralph-implement` will show it to the user
  if it needs to reconcile this against their current session settings.

Then these sections, in order:

### Context
Why this is being built, current behaviour, relevant existing files/patterns found during
exploration. Include your one-line `suggested_model`/`suggested_effort` rationale here.

### Goals
Bulleted list of the explicit, user-facing outcomes this plan delivers.

### Non-Goals
Bulleted list of what's explicitly out of scope — bounds the implementer, prevents scope creep.

### Requirements
Functional requirements, plus a `### Standing constraints` subsection restating this project's
own non-negotiable rules from its `CLAUDE.md` (validation location, testing requirements, design
system usage, whatever applies) — copy the file's own wording rather than inventing one here.

### Implementation
A numbered checklist of every change required, ordered by dependency. Each item should name the
file(s) touched and what changes. Use GitHub-flavoured markdown checkboxes:

```markdown
## Implementation

- [ ] 1. `path/to/file.ext` — what changes and why
- [ ] 2. `path/to/other_file.ext` — what changes and why
```

### Validation
A checklist of how to verify the feature works end-to-end after implementation:

```markdown
## Validation

- [ ] Unit tests: `<test command>`
- [ ] Smoke: <manual or scripted check that the happy path works>
- [ ] Edge case: <a specific edge case named in Requirements>
```

### Definition of Done
The mechanically-verifiable subset of Validation — literal shell commands only, excluding
manual/human-only steps. These get re-run together as the final gate right before the plan is
marked done:

```markdown
## Definition of Done

​```bash
<lint/typecheck command>
<test command>
​```
```

After writing the file, show the user the full plan content in chat, then use the
`AskUserQuestion` tool to ask:

- Question: "Plan saved to `plans/plan_<slug>.md`. Ready to proceed?"
- Options: "Approve — start implementation", "Revise — I have corrections"

If the user selects "Revise", ask a follow-up `AskUserQuestion` for their corrections, update the
plan file, show the revised plan, and ask for approval again. Repeat until approved. Stay in
planning mode throughout all revisions.

When the user selects "Approve", flip the plan file's frontmatter `status: draft` →
`status: approved` before moving to Phase 3.

## Phase 3 — Confirm implementation start

When the user approves the plan:

1. Call `ExitPlanMode` to leave planning mode.
2. Use the `AskUserQuestion` tool to confirm:
   - Question: "This will modify code via a bounded, self-correcting loop (up to
     <max_iterations> retry attempts on validation failures before the plan is marked blocked for
     review). Proceed with implementation?"
   - Options: "Yes — implement now", "No — let me reconsider"

If the user selects "No", stop and use `AskUserQuestion` to ask what they want to change.

## Phase 4 — Implement via ralph-implement

Delegate implementation entirely to the shared implementer loop:

```
Skill(skill: "ralph-implement", args: "plans/plan_<slug>.md")
```

`ralph-implement` owns all further checkbox flipping, validation retries, iteration/blocked-state
bookkeeping, and the final Definition-of-Done gate. Do not duplicate any of that logic here.

- If it reports `status: done` — proceed to Phase 5.
- If it reports `status: blocked` — relay its `## Blocked` section to the user verbatim and stop.
  Do not attempt to silently finish the plan yourself.

## Phase 5 — Wrap up

Once `ralph-implement` reports the plan done:

1. Move the file: `plans/plan_<slug>.md` → `plans/implemented/plan_<slug>.md`.
2. If this project keeps a changelog, append a row describing what changed.
3. Any project-specific epilogue (announcing the change, notifying someone, closing a linked
   ticket) is the caller's responsibility, not this skill's — `ralph-implement` is
   pipeline-agnostic and never publishes or notifies anything on its own.

## Notes

- Keep solutions simple — no over-engineering.
- Follow existing code conventions in this repo.
- Do not push to git without an explicit directive from the user.
