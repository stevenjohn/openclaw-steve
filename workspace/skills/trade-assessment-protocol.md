# Trade Assessment Protocol (Shared)

**Referenced by:** options-income, options-directional, hedging, boss-protocol

All trade assessments follow this sequence BEFORE applying domain-specific rules.
This is the data-gathering layer. Domain skills are the evaluation layer.

---

## When Does This Apply?

Any time Steve presents a trade for assessment, review, or validation — whether income, directional, or hedge. This includes:
- New trade ideas (with or without images)
- Position reviews ("how's my NVDA spread doing?")
- Roll/adjustment decisions
- Hedge adequacy checks

**Does NOT apply to:**
- **Data lookups** ("show active income trades", "what options do I have?", "list my hedges") — go directly to the relevant data skill endpoint
- Pure portfolio reviews or monthly reviews (Boss Protocol MAP handles those)
- Quick price checks
- Account balance / equity queries

**If Steve is asking to SEE positions (not evaluate a trade idea), skip this protocol entirely and use the data skill endpoints.**

---

## The Sequence

### Step 1: EXTRACT (if images provided)

**OptionStrat screenshots** — enumerate these metrics FIRST, before any analysis:
- Structure (e.g., bull put spread, iron condor)
- Net Credit or Debit
- Max Loss / Max Profit
- Probability of Profit (PoP%)
- Break-even price(s)
- DTE
- Greeks if visible (delta, theta, vega)
- P&L curve shape (risk profile)

**Chart images** — note:
- Visible trend direction
- Key levels the trade is near
- Pattern context (if any)
- Timeframe shown

State extracted data explicitly. Do not silently absorb and skip ahead.

### Step 2: FETCH — Market Data (always)

**One call per underlying ticker.** Cached 18hrs, so this is cheap.

```
POST /webhook/market-data
{"tool": "get_market_data", "ticker": "SYMBOL"}
```

**Index proxies (Polygon doesn't support index tickers):**
- SPX → use `SPY`
- RUT → use `IWM`
- VIX → use Market Context endpoint instead

This returns: price, all MAs (10/21/50/200 on daily/weekly/monthly), RSI, MACD, support/resistance levels, structure, candlestick patterns, pivots.

**Also fetch market-context IF:**
- No regime check in current session yet, OR
- Session is >1hr old (regime could have shifted)

**Skip market-context IF:** already fetched this session and <1hr ago.

### Step 3: CONTEXT — Journal Check (always)

```
POST /webhook/get-investment-journal
{"topic": "SYMBOL"}
```

Surface: prior thesis, active positions, standing orders, analyst views (last 60 days).
If nothing returned, note "No recent journal entries" and continue.

### Step 4: ASSESS — Apply Domain Rules

NOW load and apply the relevant domain skill:
- **Income trade** → options-income rules (tier, yield floor, regime gate, structure)
- **Directional trade** → options-directional rules (CTL sequence, location, trigger)
- **Hedge** → hedging rules (coverage target, structure preference, cost analysis)
- **Boss validation** → boss-protocol rules (MAP, risk rules, verdict format)

Combine: extracted image data + fetched technicals + journal context + domain rules.

### Step 5: NEWS (conditional — don't over-fetch)

Fetch news ONLY when:
- Earnings fall within the DTE window
- Stock moved >3% today (visible from market data)
- It's a Tier 3 / Hunter play (unknown name, need context)
- Steve asks about catalysts

Skip news when:
- Index trade (SPX/RUT/SPY) with no specific event concern
- Stock is well-known and no earnings imminent
- Pure roll/management decision on existing position

```
POST /webhook/market-data
{"tool": "get_news", "ticker": "SYMBOL"}
```

---

## Cost Budget

A standard assessment = **2 API calls** (market data + journal). That's it.
Add market-context only at session start. Add news only when warranted.
This is NOT a bloat problem — it's 2 lightweight cached calls that prevent bad analysis.

---

## Failure Handling

- If market data fetch fails → state "DATA UNAVAILABLE" and note which fields are missing. Do NOT guess prices, MAs, or levels.
- If journal fetch fails → continue without, note "Journal unavailable."
- If images are blurry/unreadable → ask Steve to resend. Don't guess metrics.
