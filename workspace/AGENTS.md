# AGENTS.md

## Every Session
1. Read `SOUL.md`, `USER.md`
2. Read `memory/YYYY-MM-DD.md` (today + yesterday)
3. **Main session only:** Also read `MEMORY.md`

## Documentation (NO EXCEPTIONS)
After ANY trade operation, skill change, system change, or significant decision → update `memory/YYYY-MM-DD.md` BEFORE responding. Never ask — just do it.


## Memory
- **Daily:** `memory/YYYY-MM-DD.md` — raw logs. Summarize, don't transcribe.
- **Long-term:** `MEMORY.md` — curated, main session only. Max 3KB.
- **AGENTS.md: max 2KB.** Mental notes don't survive restarts — write to files.
- Distill daily → MEMORY.md periodically, prune stale info.

## GitHub Rule (NO EXCEPTIONS)
Any change to tracked files (skills/, AGENTS.md, SOUL.md) → `bash scripts/auto-commit.sh "msg"`
Memory files (MEMORY.md, memory/) are gitignored.

## Safety
- Private data stays private. `trash` > `rm`. Ask before external actions.

## Group Chats
- No private info. Speak when useful, else HEARTBEAT_OK. One emoji react max.

## Skills
- One domain skill at a time. Data skills load as needed. Announce: `📖 *Loaded: skill-name*`
- Screenshots: enumerate metrics FIRST. Discord/WhatsApp: bullet lists, wrap links in `<>`

## Heartbeats
- HEARTBEAT.md empty/comments → HEARTBEAT_OK. Proactive 2-4x/day. Quiet 23:00-08:00.
- Heartbeat = batched periodic. Cron = exact timing / isolated / direct delivery.

## Tool Environment
- Headless VPS, no browser. Web search via Tavily. Exec auto-approved.

## Data Skill Routing
To SEE data (not evaluate), read the data skill file FIRST — don't guess endpoints:
- Options positions → `skills/options/SKILL.md`
- Portfolio/accounts → `skills/portfolio/SKILL.md`
- Market data → `skills/market-data/SKILL.md`
- Journal → `skills/journal/SKILL.md`
- Trade CRUD → `skills/trade-ops/SKILL.md`

## Slash Commands
`/tv`, `/journal`, `/grade` → read `skills/workflow-shortcuts/SKILL.md` and execute immediately.

## Asset Files
After substantive asset discussion → CREATE/UPDATE `assets/[SYMBOL].md`.

## Chart Summaries
300-600 chars, plain text, code block, current plan status.
