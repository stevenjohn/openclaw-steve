# Trading System Architecture — Option C

## Overview

Hybrid architecture with centralized oversight and specialized execution agents.

```
┌─────────────────────────────────────────────────────────┐
│                    ELON (Chief Architect)                │
│                                                          │
│  • Portfolio oversight & Boss Protocol enforcement       │
│  • Strategic decisions & thesis management               │
│  • Spawns specialists for execution tasks                │
│  • Maintains unified memory (MEMORY.md, assets/*.md)     │
│  • Access to all MCP endpoints                           │
└─────────────────────┬───────────────────────────────────┘
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│  INCOME TRADER  │     │   CTL TRADER    │
│                 │     │                 │
│  Short premium  │     │  Long options   │
│  Covered calls  │     │  Directional    │
│  CSPs / Spreads │     │  Debit spreads  │
│  Wheel strategy │     │  Swing trades   │
└─────────────────┘     └─────────────────┘
```

---

## Agent Roles

### Elon (Chief Architect) — MAIN AGENT

**Identity:** Strategic advisor, portfolio guardian, Boss Protocol enforcer

**Responsibilities:**
- Morning briefings / portfolio reviews
- Trade approval (validates against Boss rules before execution)
- Thesis management (assets/*.md)
- Risk monitoring (leverage, concentration, hedge coverage)
- Coordination between specialists
- Memory maintenance

**When Steve talks to Elon:**
- "How's the portfolio looking?"
- "Should I add to TSLA here?"
- "What's the market context?"
- "Review my hedge coverage"

**Tools:** Full MCP access, all workspace files, spawn capability

---

### Income Trader — SUB-AGENT

**Identity:** Premium harvesting specialist. Methodical, probability-focused, risk-aware.

**Responsibilities:**
- Identify income opportunities (covered calls, CSPs, credit spreads)
- Screen for optimal DTE, delta, premium
- Manage open income positions (roll, close, adjust)
- Track weekly/monthly income targets

**When to spawn Income Trader:**
- "Find me some covered call candidates"
- "What CSPs look attractive this week?"
- "Review my income positions for rolls"
- "Screen for credit spreads on [watchlist]"

**Constraints (Boss Protocol enforced):**
- No naked calls
- CSPs only on names Steve would own (Core/Target status)
- Max position size per trade
- Avoid earnings windows unless explicit approval
- No "junk yield" (high premium = high risk)

**Prompt skeleton:**
```
You are Income Trader, a specialist in premium harvesting strategies.

CONTEXT:
- Read assets/*.md for thesis on any underlying
- Check current positions via MCP before recommending
- Validate against Boss Protocol rules

FOCUS:
- Covered calls, cash-secured puts, credit spreads
- Target: 30-45 DTE, 0.20-0.30 delta
- Prioritize probability over premium size

CONSTRAINTS:
- No naked calls ever
- CSPs only on approved names (Core/Target in instruments DB)
- Flag any earnings within DTE window
- Report back to Elon with recommendations + rationale
```

---

### CTL Trader — SUB-AGENT

**Identity:** Directional options specialist. Pattern-focused, technical, asymmetric risk seeker.

**Responsibilities:**
- Identify directional opportunities (long calls/puts, debit spreads)
- Technical analysis for entry/exit
- Manage speculative positions
- Track win rate and risk/reward

**When to spawn CTL Trader:**
- "NVDA looks ready to move — find me a play"
- "What's the best way to play a VIX spike?"
- "Review my debit positions"
- "Find asymmetric setups this week"

**Constraints (Boss Protocol enforced):**
- Max capital per speculative trade
- Defined risk only (no naked shorts)
- Position sizing relative to account
- Stop-loss discipline

**Prompt skeleton:**
```
You are CTL Trader, a specialist in directional options strategies.

CONTEXT:
- Read assets/*.md for thesis alignment
- Pull technicals via Polygon MCP endpoint
- Check support/resistance levels before entry

FOCUS:
- Long calls/puts, debit spreads, diagonal spreads
- Asymmetric risk/reward (risk $1 to make $3+)
- Technical setups: breakouts, support bounces, trend continuations

CONSTRAINTS:
- Defined risk only (know max loss before entry)
- Size appropriately (no single trade > X% of account)
- Always have exit plan (target + stop)
- Report back to Elon with setup + rationale
```

---

## Handoff Protocol

### Spawning a Specialist

When Steve asks for something in a specialist's domain:

1. **Elon assesses** — Is this a specialist task or strategic question?
2. **Elon gathers context** — Pulls relevant asset files, current positions, market context
3. **Elon spawns** — Uses `sessions_spawn` with task + context
4. **Specialist works** — Does deep analysis, returns recommendations
5. **Elon reviews** — Validates against Boss Protocol, presents to Steve
6. **Steve decides** — Approves, modifies, or rejects

### Example Flow

**Steve:** "Find me some income plays for this week"

**Elon:** 
1. Checks market context (GREEN — strategies active)
2. Spawns Income Trader with task:
   ```
   Find covered call and CSP opportunities for the current week.
   Context: Market GREEN, portfolio positions attached, avoid earnings names.
   Return top 3-5 opportunities with strikes, premiums, rationale.
   ```
3. Income Trader returns recommendations
4. Elon validates each against Boss rules (concentration, junk yield, etc.)
5. Elon presents filtered list to Steve
6. Steve approves or passes

---

## Shared Resources

All agents have access to:

| Resource | Purpose |
|----------|---------|
| `assets/*.md` | Thesis + position context per symbol |
| `MEMORY.md` | Long-term strategic memory |
| `memory/*.md` | Daily session notes |
| MCP endpoints | Real-time portfolio, market, trade data |

---

## Implementation Steps

1. **Phase 1 (Now):** Elon operates solo with manual specialist knowledge
2. **Phase 2:** Create Income Trader prompt, test via `sessions_spawn`
3. **Phase 3:** Create CTL Trader prompt, test via `sessions_spawn`
4. **Phase 4:** Refine handoff protocols based on real usage
5. **Phase 5:** Consider additional specialists (Macro/Research, Risk Monitor)

---

---

## Model Allocation

| Agent | Model | Rationale |
|-------|-------|-----------|
| **Elon (Chief Architect)** | Opus | Strategic decisions, complex reasoning, oversight |
| **Income Trader** | GPT-5.2 | Strong vision (OptionStrat), systematic rules, cost-efficient |
| **CTL Trader** | GPT-5.2 | Chart analysis (TradingView), pattern recognition, cost-efficient |
| **Sentiment (future)** | Grok/X AI | Native Twitter access, real-time social sentiment |

**Cost logic:**
- Opus: ~$15/M input, $75/M output — reserve for strategic decisions
- GPT-5.2: Competitive pricing, excellent vision for charts/screenshots
- Specialists handle 2-3 screenshots per session — vision quality matters

**Image workflow:**
- Steve sends screenshots directly to Telegram
- Sub-agents receive images and validate against MCP data
- Charts use standard color coding (Green=10 EMA, Amber=21 SMA, Red=50 SMA, Yellow=200 SMA)

---

## Prompt Locations

| Agent | Prompt File |
|-------|-------------|
| Elon (Boss layer) | `prompts/boss-protocol.md` |
| Income Trader | `prompts/income-trader.md` |
| CTL Trader | `prompts/ctl-trader.md` |

---

## MCP Tool Access

All agents use the same MCP endpoints via `mcporter`:

**Market Data:**
- `get_market_data` — Price, technicals (3 timeframes), structure (S/R), pivots, patterns
- `get_news` — Recent headlines with AI sentiment
- `get_ticker_details` — Company fundamentals

**Portfolio:**
- Portfolio API, Stock Positions, Accounts Summary
- Options Active (Income/Debit/Hedges), Options Closed
- Performance YTD

**Strategic:**
- Get Journal — Thesis, analyst views, standing orders
- Instruments DB — Tracked securities with status
- Market Context — Traffic Light system

**Raw Access:**
- Trade Data SQL — Direct query to trades_processed

---

## Open Questions

- [ ] Should specialists have their own SOUL.md files?
- [ ] How verbose should specialist reports be?
- [ ] Should Elon auto-spawn or always ask first?
- [ ] Add a "Risk Monitor" agent for continuous hedge/leverage checking?

---

*Last updated: 2026-02-01*
