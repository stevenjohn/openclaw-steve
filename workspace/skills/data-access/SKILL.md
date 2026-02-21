---
name: data-access
description: How to request data via the data-fetcher sub-agent. Required for any agent that needs market, portfolio, or trading data.
---

# Data Access Protocol

You cannot access market data, portfolio data, or trading APIs directly.
All data requests go through the `data-fetcher` sub-agent.

## Requesting Data

Spawn `data-fetcher` and describe WHAT you need in plain language:
- "Fetch market context (regime, VIX, breadth)"
- "Fetch technical analysis for NVDA"
- "Fetch news and sentiment for TSLA"
- "Get active income option positions"
- "Get active hedge positions"
- "Get portfolio bucket overview"
- "Get bucket detail for B2"
- "Get accounts summary"
- "Get YTD performance"
- "Get journal entries for BTC"
- "Get crypto positions"

## Requesting Writes

For data modifications, specify EXACTLY what to write. The data-fetcher executes your instruction precisely.

**Instrument updates:**
"Update instrument NVDA: technical_grade=3, entry_zone_low=115, entry_zone_high=140"

**Trade operations:**
"Create trade: bull_put_spread, QQQ, 450/445, sold $0.75, Mar 21 expiry, ToS account, qty 1, max_loss $450, stock price $478, entry_journal: [full text with tags]"

**Journal writes:**
"Write journal entry: ticker=PLTR, sentiment=Bullish, core_message=[text], action_plan=[text]"

**Target updates:**
"Update target: scope=asset, key=NVDA, target_pct=0.12, notes=B2 core"

Be precise with field values. The data-fetcher executes exactly what you specify.

## If Data-Fetcher Fails

Report the failure to Steve. Do NOT:
- Run curl, wget, or shell commands
- Search the web for market data
- Guess or hallucinate values
- Retry more than once
