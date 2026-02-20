---
name: portfolio-planning
description: Portfolio allocation analysis, rotation detection, asset grading, and strategic planning. Load when discussing portfolio review, bucket allocations, what to buy/sell, rotation opportunities, weekly audits, or asset entry/exit planning.
---

# Portfolio Planning Engine

Strategic allocation brain. Helps Steve decide what to own, how much, and when to act.

**This skill is about POSITIONS and ALLOCATION — not individual trade structures.**
For trade validation (spreads, entries, exits), use the relevant trading skill instead:
- Options structure → `options-income` or `options-directional`
- Hedge evaluation → `hedging`
- Monthly review / rule enforcement → `boss-protocol`
- Trade entry/exit recording → `trade-ops`

---

## Data Endpoints

### New (Portfolio-Specific)
| Endpoint | Method | Purpose |
|----------|--------|---------|
| /webhook/portfolio-buckets | POST | Bucket overview: 4 rows, NAV, current %, target %, gap, action |
| /webhook/portfolio-bucket-detail | POST | Drill-down: assets in a bucket with values, targets, deviations, planning fields |
| /webhook/instrument-update | POST | Update instrument metadata (grade, entry zones, thesis, etc.) |
| /webhook/target-update | POST | Upsert bucket or asset allocation targets |

### Existing (Reuse — Don't Duplicate)
| Endpoint | Method | Purpose | Skill Reference |
|----------|--------|---------|-----------------|
| /webhook/market-data | POST | Technicals for a ticker (price, MAs, RSI, MACD, S/R) | `market-data` |
| /webhook/market-context | GET | Traffic Light regime (VIX, breadth, trend) | `market-data` |
| /webhook/get-investment-journal | POST | Journal entries by ticker/topic | `journal` |
| /webhook/journal-write | POST | Write journal entry for handoff | `journal` |
| /webhook/portfolio-strategy | GET | Legacy bucket view (use portfolio-buckets instead) | `portfolio` |
| /webhook/stocks-positions | GET | Stock + LEAP positions with sector breakdown | `portfolio` |

**Auth for all:** `Content-Type: application/json` + `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## Bucket Architecture

| Bucket | Name | Target | Contents |
|--------|------|--------|----------|
| B0 | Cash / Dry Powder | 5% | USD, USDT, SGOV |
| B1 | Crypto | 15% | BTC, IBIT, MSTR, SOL |
| B2 | AI & Growth | 55% | TSLA, NVDA, TSM, AVGO, PLTR, AMD, MU, GOOG, AMZN, MSFT, ALAB + LEAPs |
| B3 | Real Assets | 25% | Energy, commodities, healthcare, rare earths, misc |

Sector → bucket mapping lives in `sectors_ref.strategy_bucket` (DB canonical source).

---

## Protocols

### 1. Portfolio Overview

**Trigger:** "Review portfolio", "How are allocations?", "Where am I at?"

```
1. POST /webhook/portfolio-buckets  →  4-row summary
2. Identify buckets with >5% deviation from target
3. Present: clean table with current %, target %, gap, action
4. Note any bucket needing immediate attention
5. Ask Steve which bucket to drill into (don't auto-drill all 4)
```

**Token cost:** 1 API call, ~200 tokens response.

---

### 2. Bucket Deep Dive

**Trigger:** "Review B2", "What needs attention in crypto?", "Drill into AI bucket"

**Triage format — always render this copy-paste list when asking Steve to grade:**
```
SYMBOL: 
SYMBOL: 

1: Screaming Buy — Buy Now
2: Accumulate — Buy on Dips
3: Hold — Do Nothing
4: Watch — Keep an Eye
5: Ignore/Sell — Sell or Remove
```

```
1. POST /webhook/portfolio-bucket-detail  {"bucket": "B2"}
2. Scan returned assets for:
   a. STALE: last_reviewed is null or > 14 days ago
   b. DEVIATION: pct_of_bucket vs target_pct differs by >3%
   c. EMPTY: target_pct > 0 but value = 0 (unfunded targets)
   d. UNPLANNED: value > 0 but target_pct = 0 (Guest positions with no target)
   e. ENTRY ZONE: if entry_zone_low/high are set, flag if current price is in zone
3. For the top 2-3 flagged assets, fetch market data (one call each)
4. Present findings with recommendations
5. Discuss with Steve → update via instrument-update as decisions are made
```

**Token cost:** 1 API call for bucket (~500 tokens) + 2-3 market data calls as needed.

---

### 3. Asset Assessment (Allocation Focus)

**Trigger:** "How does NVDA look for accumulation?", "Should I add to AVGO?", "Is it time to enter MSTR?"

This is different from trade assessment (which evaluates a specific spread/structure). This asks: **should we be building/reducing this position at the portfolio level?**

```
1. POST /webhook/market-data  {"tool": "get_market_data", "ticker": "SYMBOL"}
2. POST /webhook/get-investment-journal  {"topic": "SYMBOL"}
3. POST /webhook/portfolio-bucket-detail  {"bucket": "Bx"}  (to see current position + target)
4. Evaluate:
   - TECHNICAL: Price vs entry_zone_low/high? RSI overbought/oversold? Trend alignment?
   - FUNDAMENTAL: Thesis intact? (check thesis_short + journal)
   - ALLOCATION: Current weight vs target? Room to add? Concentration risk?
   - TIMING: In entry zone? At support? Or extended and chasing?
5. Recommend: ACCUMULATE / HOLD / TRIM / EXIT with rationale
6. If Steve agrees → update instruments (grade, zones, thesis, last_reviewed)
```

**Token cost:** 3 API calls (market data + journal + bucket detail).

---

### 4. Rotation Analysis

**Trigger:** "Rotation opportunities?", "What's extended vs cheap?", "Where should I move capital?"

```
1. POST /webhook/portfolio-bucket-detail  {"bucket": "Bx"}
2. For all Core assets with value > 0 in that bucket, fetch market data
3. Score each asset on:
   - RSI: >70 = extended, <30 = depressed
   - Distance from 21 SMA: >5% above = extended, >5% below = depressed
   - Entry zone: in zone = opportunity, above zone = full
   - Deviation: overweight = trim candidate, underweight = add candidate
4. Rank into two lists:
   - EXTENDED (trim candidates): overweight + overbought
   - DEPRESSED (add candidates): underweight + oversold or at support
5. Present rotation pairs: "Trim X (extended, +29% vs target) → Add Y (at 21 SMA, -5% vs target)"
```

**Token cost:** 1 bucket call + N market data calls (N = number of Core assets in bucket).
**Limit:** Max 6-8 market data calls per rotation analysis. Prioritize by deviation size.

---

### 5. Weekly Audit

**Trigger:** "Weekly check-in", "Portfolio audit", "What needs attention?"

```
1. POST /webhook/portfolio-buckets  →  overview
2. POST /webhook/market-context  →  regime check (if not done this session)
3. For each bucket with significant deviation (>5%), fetch bucket-detail
4. Scan ALL assets across fetched buckets for:
   - STALE: last_reviewed > 14 days
   - INVALIDATION BREACH: price below invalidation_price (need market data to check)
   - ENTRY ZONE HIT: price entered entry_zone (need market data to check)
   - CONCENTRATION: any asset > 20% of portfolio
   - UNREVIEWED: technical_grade is null
5. For flagged assets needing price check, fetch market data (limit: top 5 priority)
6. Present prioritized action list:
   a. 🔴 Urgent: invalidation breaches, concentration risk
   b. 🟡 Review: stale reviews, entry zone proximity
   c. 🟢 Opportunity: assets in buy zone with room to add
7. Work through items with Steve, update instruments as decisions are made
```

**Token cost:** 1 overview + 2-4 bucket details + up to 5 market data calls.

---

## Post-Discussion Protocol (MANDATORY)

After ANY substantive discussion about an asset allocation or planning:

1. **Update instruments** via `/webhook/instrument-update`:
   - `technical_grade` — if we assessed the setup (1-5)
   - `entry_zone_low` / `entry_zone_high` — if we defined buy zones
   - `invalidation_price` — if we defined thesis-break levels
   - `thesis_short` — if we discussed or changed the thesis
   - `last_reviewed` — auto-set by endpoint on any update

2. **Update targets** via `/webhook/target-update` if allocation targets changed

3. **Write journal entry** via `/webhook/journal-write` if significant (thesis change, new plan, major decision)

4. **Update asset file** at `assets/SYMBOL.md` if it exists (per standing Asset File Rule in MEMORY.md)

**Do not ask Steve if you should save this. Just do it.**

---

## Token Efficiency Rules (CRITICAL)

These aren't suggestions — they prevent unnecessary API spend:

1. **Start broad, drill narrow:** Bucket overview first (4 rows). Then ONE bucket. Then specific assets.
2. **Don't fetch all assets at once.** Work through 3-5 at a time during discussion.
3. **Market data is cached 18hrs.** Don't re-fetch same ticker in same session.
4. **Only fetch market data for assets under active discussion.** Not "let me check all 12 B2 assets."
5. **Bucket detail includes planning fields.** Don't separately query instruments — it's already in the response.
6. **News is almost never needed here.** This is allocation planning, not trade timing. Skip it unless Steve specifically asks about catalysts.

---

## Instrument Update — Request Format

```
POST /webhook/instrument-update
{
  "symbol": "NVDA",
  "updates": {
    "priority": 2,
    "status": "Core",
    "target_portfolio": 0.12,
    "technical_grade": 4,
    "entry_zone_low": 115.00,
    "entry_zone_high": 140.00,
    "invalidation_price": 100.00,
    "thesis_short": "AI capex secular winner, accumulate at 21 SMA tests",
    "sector": "chips_semi_conductors"
  }
}
```

Only include fields being changed. `last_reviewed` is auto-set.

**Validation:** priority 1-10, status Core/Guest/Target/Exit, target_portfolio 0-1, technical_grade 1-5, sector must exist in sectors_ref.

---

## Target Update — Request Format

```
POST /webhook/target-update
{
  "scope": "asset",
  "key": "NVDA",
  "target_pct": 0.12,
  "notes": "B2 core - AI capex"
}
```

- Scope: `bucket` (B0-B3) or `asset` (symbol)
- Asset targets capped at 30%
- Returns `action: "created"` or `action: "updated"`
