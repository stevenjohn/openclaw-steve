# OpenClaw Workspace

Steve's personal OpenClaw configuration, skills, and trading context.

## Structure

### Core Identity Files
- **SOUL.md** — Persona, communication style, core principles
- **USER.md** — Steve's profile, trading philosophy, working style
- **IDENTITY.md** — Name, creature type, vibe, emoji
- **AGENTS.md** — Workspace rules, memory management, documentation standards
- **TOOLS.md** — Local notes (camera names, SSH hosts, device-specific config)

### Trading Context (Standing)
- **REGIME.md** — Current market regime, zone permissions, trend/breadth/VIX
- **PORTFOLIO-RULES.md** — Three-engine model, concentration limits, DTE standards
- **TRADING-PHILOSOPHY.md** — Core principles, behavioral tie-breakers, edge definition

### Operational
- **HEARTBEAT.md** — Periodic check instructions (empty = skip heartbeat work)
- **ARCHITECTURE.md** — System design notes

### Skills (`skills/`)

**Domain Skills** (strategy, methodology):
- `boss-protocol/` — Trade validation system (MAP v2.3, rules enforcement)
- `options-income/` — Income Factory methodology (30-45 DTE, yield floors)
- `options-directional/` — CTL methodology for debit plays
- `trading-coach/` — Psychology, philosophy frameworks (Stoic/Daoist/Surfing/I Ching)
- `hedging/` — Coverage targets, regime triggers, protection strategies
- `crypto-trading/` — Sandbox rules, leverage limits, BTC/altcoin framework

**Data Skills** (endpoints, APIs):
- `market-data/` — Context endpoint + 3-in-1 data + proactive news checking
- `portfolio/` — Strategy, accounts, stock positions, performance data
- `options/` — Income/debit/hedges/closed/weekly views
- `crypto/` — Positions, holdings, weekly performance
- `journal/` — Investment journal read/write
- `trade-ops/` — CRUD operations for trades database (with entry/exit tags)

**Infrastructure Skills**:
- `github-pm/` — Issue tracking, kanban workflow
- `tavily-search/` — Web search (news, research)
- `workflow-shortcuts/` — `/journal` and `/tv` shortcuts

### Assets (`assets/`)
Trade context and decision history for specific tickers:
- `BTC.md`, `PLTR.md`, `SPX.md`, `TSLA.md`, etc.
- `_TEMPLATE.md` — Template for new asset files

### Legacy (`prompts/`)
Archive of original Claude Project prompts before skill migration.

## What's NOT in Git

**Excluded via `.gitignore`:**
- `memory/*.md` — Daily session logs (too noisy for version control)
- `MEMORY.md` — Long-term personal memory (security: kept local only)
- `.clawhub/` and `.openclaw/` — OpenClaw internals

## Workflow

**Steve edits on GitHub:**
1. Make changes via web interface or local clone
2. Elon runs `git pull` to sync changes

**Elon updates workspace:**
1. Makes changes (skill refinements, context updates, etc.)
2. Commits with descriptive message
3. Pushes to repo for Steve to review

## Key Principles

- **Skills are modular** — Load only what's needed per conversation topic
- **Standing context always loaded** — REGIME, PORTFOLIO-RULES, TRADING-PHILOSOPHY
- **Memory is local** — Daily logs and MEMORY.md never leave the VPS
- **Documentation is automatic** — Trade ops, decisions, and learnings documented before responding

## Links

- **Repo:** https://github.com/stevenjohn/openclaw-ops
- **OpenClaw Docs:** https://docs.openclaw.ai
- **Community:** https://discord.com/invite/clawd
- **ClawHub (skills):** https://clawhub.com
