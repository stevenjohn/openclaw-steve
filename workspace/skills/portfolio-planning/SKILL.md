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

## Bucket Architecture

| Bucket | Name | Target | Contents |
|--------|------|--------|----------|
| B0 | Cash / Dry Powder | 5% | USD, USDT, SGOV |
| B1 | Crypto | 15% | BTC, IBIT, MSTR, SOL |
| B2 | AI & Growth | 55% | TSLA, NVDA, TSM, AVGO, PLTR, AMD, MU, GOOG, AMZN, MSFT, ALAB + LEAPs |
| B3 | Real Assets | 25% | Energy, commodities, healthcare, rare earths, misc |

---

## Protocols

### 1. Portfolio Overview

**Trigger:** "Review portfolio", "How are allocations?", "Where am I at?"

1. Request bucket overview from data-fetcher (returns 4-row summary)
2. Identify buckets with >5% deviation from target
3. Present: clean table with current %, target %, gap, action
4. Note any bucket needing immediate attention
5. Ask Steve which bucket to drill into (don't auto-drill all 4)

**Token cost:** 1 data-fetcher spawn, ~200 tokens response.

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

1. Request bucket detail for the target bucket from data-fetcher
2. Scan returned assets for:
   a. STALE: last_reviewed is null or > 14 days ago
   b. DEVIATION: pct_of_bucket vs target_pct differs by >3%
   c. EMPTY: target_pct > 0 but value = 0 (unfunded targets)
   d. UNPLANNED: value > 0 but target_pct = 0 (Guest positions with no target)
   e. ENTRY ZONE: if entry_zone_low/high are set, flag if current price is in zone
3. For the top 2-3 flagged assets, request technicals from data-fetcher (one per ticker)
4. Present findings with recommendations
5. Discuss with Steve → instruct data-fetcher to update instruments as decisions are made

### 3. Asset Assessment (Allocation Focus)

**Trigger:** "How does NVDA look for accumulation?", "Should I add to AVGO?", "Is it time to enter MSTR?"

This asks: **should we be building/reducing this position at the portfolio level?**

1. Request technicals for the ticker from data-fetcher
2. Request journal entries for the ticker from data-fetcher
3. Request bucket detail for the relevant bucket from data-fetcher
4. Evaluate:
   - TECHNICAL: Price vs entry_zone_low/high? RSI overbought/oversold? Trend alignment?
   - FUNDAMENTAL: Thesis intact? (check thesis_short + journal)
   - ALLOCATION: Current weight vs target? Room to add? Concentration risk?
   - TIMING: In entry zone? At support? Or extended and chasing?
5. Recommend: ACCUMULATE / HOLD / TRIM / EXIT with rationale
6. If Steve agrees → instruct data-fetcher to update instruments (grade, zones, thesis, last_reviewed)

### 4. Rotation Analysis

**Trigger:** "Rotation opportunities?", "What's extended vs cheap?", "Where should I move capital?"

1. Request bucket detail from data-fetcher
2. For all Core assets with value > 0, request technicals from data-fetcher
3. Score each asset on:
   - RSI: >70 = extended, <30 = depressed
   - Distance from 21 SMA: >5% above = extended, >5% below = depressed
   - Entry zone: in zone = opportunity, above zone = full
   - Deviation: overweight = trim candidate, underweight = add candidate
4. Rank into two lists:
   - EXTENDED (trim candidates): overweight + overbought
   - DEPRESSED (add candidates): underweight + oversold or at support
5. Present rotation pairs: "Trim X (extended, +29% vs target) → Add Y (at 21 SMA, -5% vs target)"

**Limit:** Max 6-8 market data requests per rotation analysis. Prioritize by deviation size.

### 5. Weekly Audit

**Trigger:** "Weekly check-in", "Portfolio audit", "What needs attention?"

1. Request bucket overview from data-fetcher
2. Request market context from data-fetcher (if not done this session)
3. For each bucket with significant deviation (>5%), request bucket detail
4. Scan ALL assets across fetched buckets for:
   - STALE: last_reviewed > 14 days
   - INVALIDATION BREACH: price below invalidation_price (need technicals to check)
   - ENTRY ZONE HIT: price entered entry_zone (need technicals to check)
   - CONCENTRATION: any asset > 20% of portfolio
   - UNREVIEWED: technical_grade is null
5. For flagged assets needing price check, request technicals (limit: top 5 priority)
6. Present prioritized action list:
   a. 🔴 Urgent: invalidation breaches, concentration risk
   b. 🟡 Review: stale reviews, entry zone proximity
   c. 🟢 Opportunity: assets in buy zone with room to add
7. Work through items with Steve, instruct data-fetcher to update instruments as decisions are made

---

## Post-Discussion Protocol (MANDATORY)

After ANY substantive discussion about an asset allocation or planning:

1. **Update instruments** — instruct data-fetcher to update: technical_grade, entry_zone_low/high, invalidation_price, thesis_short (last_reviewed auto-set)
2. **Update targets** — instruct data-fetcher if allocation targets changed
3. **Write journal entry** — instruct data-fetcher if significant (thesis change, new plan, major decision)
4. **Update asset file** at `assets/SYMBOL.md` if it exists

**Do not ask Steve if you should save this. Just do it.**

---

## Instrument Fields Reference

These are the fields you can update via data-fetcher:
| Field | Type | Constraints |
|-------|------|-------------|
| priority | smallint | 1-10 |
| status | text | Core, Guest, Target, Exit |
| target_portfolio | numeric | 0-1 |
| technical_grade | smallint | 1-5 (1=screaming buy, 5=ignore/sell) |
| entry_zone_low | numeric | > 0 |
| entry_zone_high | numeric | > entry_zone_low |
| invalidation_price | numeric | > 0 (thesis breaks here) |
| thesis_short | text | max 500 chars |
| sector | text | must be valid sector code |

---

## Token Efficiency Rules (CRITICAL)

1. **Start broad, drill narrow:** Bucket overview first. Then ONE bucket. Then specific assets.
2. **Don't fetch all assets at once.** Work through 3-5 at a time during discussion.
3. **Market data is cached 18hrs.** Don't re-fetch same ticker in same session.
4. **Only fetch technicals for assets under active discussion.** Not "let me check all 12 B2 assets."
5. **News is almost never needed here.** This is allocation planning, not trade timing.
