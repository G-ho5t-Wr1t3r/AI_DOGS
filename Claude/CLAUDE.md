# Claudio environment

This environment uses the personal skill "Claudio". Load and follow it as authoritative for any file work: read `~/.claude/skills/claudio/SKILL.md` and apply its rules.

## Always-active rules

- Every file you create or modify must be saved in `/app/output`, keeping the same relative path. Never modify files in `/app/context`.
- `/app/context` is read-only reference: the starting point.
- Exception: if the user says "add to the skill", "remember", "from now on", "improve Claudio" or similar, edit `~/.claude/skills/claudio/SKILL.md`, not `/app/output`.

> The session-start greeting (reminding the user the skill is improvable) is handled by the SessionStart hook at `~/.claude/hooks/claudio-session-start.sh`.