---
name: options-directional
description: Debit/directional trade validation using CTL methodology. Price action first, context before entry. Load when discussing swing trades, debit spreads, long calls/puts, or technical setups.
---

⚠️ **When EVALUATING a trade:** Follow `skills/trade-assessment-protocol.md` first. For data lookups (list positions, check hedges), use data endpoints directly — see `skills/options/SKILL.md`.
When assessing ANY directional trade: Extract images → Fetch market data → Check journal → THEN evaluate with CTL methodology below.

# Options Directional Engine (CTL Methodology)

Debit/directional trades are independent of the income engine. Sized in R-units with defined risk.

## Core Assets
AI infrastructure/tech leaders: NVDA, AVGO, TSM, GOOG, MSFT, AMZN, TSLA
Bitcoin cycle proxies: BTC, IBIT, MSTR, COIN

## CTL Analysis (Applied in Step 4 of Trade Assessment Protocol)

After data is gathered per the shared protocol, apply CTL-specific analysis:

### WEATHER — Market Regime
- GREEN/AMBER/RED determines permissions (see REGIME.md)
- RED = defensive, A+ setups only, no FOMO

### THESIS — Journal Alignment
- Does trade align with quarterly/monthly plan?
- Don't validate a Short if thesis is "Raging Bull" (unless labeled counter-trend scalp)

### FULL ANALYSIS — Technical Read
From fetched market data, evaluate:
- **Technicals**: Price vs 10 EMA / 21 SMA / 50 SMA / 200 SMA (daily + weekly)
- **"Air" Check**: Extended from EMAs? RSI overbought/oversold?
- **Location**: AT a key level or mid-range?
- **Trigger**: Pattern detected? Is it AT a key level?

### CATALYST — News (fetched conditionally per protocol Step 5)
- Earnings imminent? Negative sentiment? Flag event risk.

## Entry Validation Rules
- **Location is everything** — Trade retests and rotations, not extensions
- **Pattern at key level** = valid. Pattern mid-range = noise. BLOCK.
- **Timeframe alignment** — Daily/Weekly must agree. Intraday alone insufficient.
- **Defined risk mandatory** — Can't define the stop? Can't take the trade.
- **Premium-at-risk**: Evaluate only the stop level, not total premium. Max loss > 1% account = Red Flag.

## Trade Sizing
- Size in **R-units** (1R = max acceptable loss on the trade)
- Position sizing based on stop distance, not conviction level
- Regime affects sizing: GREEN = full, AMBER = reduced, RED = minimal

## Management
- Manage during first hour of US open (Bangkok UTC+7 constraint)
- Define exit triggers at entry: profit target, stop level, time stop
