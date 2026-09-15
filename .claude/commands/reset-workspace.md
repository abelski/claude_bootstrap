---
description: Reset the project to a fresh state by deleting all user-generated output files, after explicit confirmation.
---

Reset the project to a fresh state by deleting all user-generated output files.

## Step 1 — Find generated files

Adjust the paths below to match this project's actual output directories (e.g. generated
reports, scratch output, temp/cache folders — never source, config, or `.claude/`):

```bash
find <output-dir-1> -type f 2>/dev/null | sort
find <output-dir-2> -type f 2>/dev/null | sort
```

## Step 2 — Show the list and ask for consent

Display the full list of files found. Then ask the user:

> The above N files will be permanently deleted. This cannot be undone.
> Type **YES** to confirm, or anything else to cancel.

Do NOT proceed until the user explicitly types YES (case-insensitive). If they type anything
else, or do not confirm, abort and tell them nothing was deleted.

## Step 3 — Delete

Only after YES confirmation, delete each file and remove empty subdirectories:

```bash
find <output-dir-1> -type f -delete
find <output-dir-2> -type f -delete
find <output-dir-1> <output-dir-2> -mindepth 1 -type d -empty -delete
```

## Step 4 — Confirm

Tell the user how many files were deleted and that the project is back to a clean state.

## What is kept

- `CLAUDE.md` — project instructions
- `README.md` — documentation
- `.claude/` — skills and commands
- Source code and configuration
