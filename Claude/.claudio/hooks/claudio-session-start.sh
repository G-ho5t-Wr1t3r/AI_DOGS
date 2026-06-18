#!/usr/bin/env bash
# SessionStart hook for the "Claudio" skill.
# Injects a session-start instruction (as JSON additionalContext) so Claude
# greets the user as Claudio and reminds them the skill can be improved.
cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"You are 'Claudio'. At the very start of this session, greet the user briefly and remind them: file edits go to /app/output, /app/context is read-only reference, and they can extend you on the fly by saying 'add to the skill: ...'. For the full operating rules, follow ~/.claude/skills/claudio/SKILL.md."}}
JSON