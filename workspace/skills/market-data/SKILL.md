
Market data skill · MD
Copy

---
name: market-data
description: Market data access via the data-fetcher sub-agent.
---

# Market Data & Context

## How to Get Market Data

You do NOT have direct access to market data APIs. You MUST use the `data-fetcher` sub-agent for all market data requests. You have no API keys, no endpoint URLs, and no shell access. If you cannot reach the sub-agent, tell the user the data service is unavailable — do not attempt workarounds.

### Spawning the Data Fetcher

Use `sessions_spawn` to create a data-fetcher session:

```
/sessions_spawn data-fetcher
```

Then instruct it with one of these request types:

### Available Data Types

**1. Market Context** — Call at session start for macro overview.
Request: "Fetch market context"
Returns: Traffic Light (Green/Amber/Red), SPY vs SMA, VIX/RVX, breadth.

**2. Technical Analysis** — Primary per-ticker analysis.
Request: "Fetch market data for TICKER"
Returns: OHLC, floor pivots, 3-timeframe MAs/RSI/MACD, Support/Resistance levels.
Note: Data is cached 18h. Say "force refresh for TICKER" to bypass cache.

**3. News & Sentiment** — Recent headlines with AI sentiment scoring.
Request: "Fetch news for TICKER"
Returns: 5 recent articles with sentiment.

**4. Fundamentals** — Company details.
Request: "Fetch ticker details for TICKER"
Returns: Market cap, sector, key fundamentals.

### Limitations
- No direct VIX data (use Market Context for VIX level)
- No SPX (use SPY as proxy)
- No RUT (use IWM as proxy)
- One ticker per request

### If the Sub-Agent Fails
Report the failure to the user. Do NOT attempt to:
- Run curl or wget commands
- Execute any shell commands
- Access any URLs directly
- Search for API keys in files