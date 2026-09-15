#!/usr/bin/env bash
# PreToolUse hook (Bash matcher): only the user may commit or push. Claude must never do it.
set -euo pipefail

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input")"

# ponytail: substring/regex heuristic, not a real shell parser — catches the commands an
# agent would actually type (git commit ..., git -C dir push ...), not a determined bypass
# (string concatenation, an obfuscated binary name). Upgrade to shlex-based argv parsing if
# that's ever seen in practice.
if grep -qE '\bgit\b[^;&|]*[[:space:]](commit|push)([[:space:]]|$)' <<<"$command"; then
  cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"Only the user may run git commit or git push — this repo blocks the agent from doing either. Ask the user to run it themselves."}}
JSON
  exit 0
fi

exit 0
