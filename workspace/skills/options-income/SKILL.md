---
name: options-income
description: Premium income engine rules. Regime-based structures, Income Factory tiers, yield quality analysis, management protocols. Load when discussing credit spreads, iron condors, put selling, or income strategy for both new and existing income trades.
---

⚠️ **When EVALUATING a new or existing income trade:** Follow `skills/trade-assessment-protocol.md` first (Extract → Market Data → Journal → Evaluate).
**When just LOOKING UP positions:** Skip the protocol — use data endpoints directly (see `skills/options/SKILL.md` for active income/debit/hedge endpoints).

# Options Income Engine

Guardian of the income process. Protect capital first, generate income second.

## Operational Mindset
- **Don't Nag**: Assume Steve has checked VIX/Regime. Only flag regime risk if trade is blatantly dangerous.
- **Focus on Yield Quality**: We don't want any income — we want efficient income.
- **Be ruthless on math**: Direct, insightful, supportive, but uncompromising on numbers.

## Income Factory Tiers

### Macro Gatekeeper (Check REGIME.md First)
- **RED**: Tier 2 & 3 BANNED. No new longs. Hedges mandatory.
- **AMBER**: Block Tier 3. Tier 2 at half size only.
- **GREEN**: Full permissions.

### Tier 1: Anchor (SPX/RUT)
- Max Risk: **$15,000**
- Yield Floor: **≥ 20% of spread width** (Credit/Width)
- Below floor = reject, not worth the capital
- Slow & steady engine

### Tier 2: Yield Boost (Watchlist Stocks)
- Max Risk: **$6,000**
- Yield Floor: **≥ 25% of spread width** (justifies single-stock gap risk)
- Entry: **IV Rank > 30** mandatory
- No earnings in expiry cycle
- **Technical Gate**: Fetch market data before approval. RSI > 70 AND extended → "Reduce Size by 50%"

### Tier 3: Hunter (Screener Plays)
- Max Risk: **$2,000** ($1,000 if IV > 100%)
- Target: 30–40% profit
- **Technical Gate**: Requires valid pattern at key level. No pattern = BLOCK.

## Standard DTE: 30–45 Days
All income trades target **30–45 DTE**. No weeklies.
- Provides adequate theta decay without excessive gamma risk
- Allows time to manage/roll if tested

## Drawdown Discipline
- Track monthly max drawdown for income trades (Steve defines %)
- If breached: **NO new income risk** — only reduce/hedge/close
- Anti-reflex: "Need to make income this week" = RED FLAG

## GREEN Zone Structures

### Track A: Indices (SPX/SPY)
- Structure: Short Put or Bull Put Spread
- Delta: **0.30**
- DTE: **30–45 days**
- Manage: 50% profit or 21 DTE
- Stop: NONE (no market-order stops). Roll out for net credit. If credit roll impossible, close.
- Capital: Max 60% portfolio risk; 25% Rule on buying power

### Track B: High-Beta Stocks (TSLA/NVDA)
- Structure: Put Credit Spread
- Delta: **0.20**
- DTE: **30–45 days**
- Manage: Close at 50% profit. **Close 3 days before earnings.**
- Stop: Defined risk only (spread width = structural stop)
- Yield: Must pass Tier 2 floor (≥ 25% of width)
- Width: ~1/10th of stock price

## AMBER Zone Structures

### Track A: Indices
- Structure: Iron Condor or Strangle (neutral bias)
- Delta: **0.16** (~1 SD)
- DTE: **30–45 days**
- Manage: 50% profit or 21 DTE
- Stop: Roll tested side to later cycle. Don't close for loss unless thesis breaks.
- Yield: >25–30% of width

### Track B: High-Beta Stocks
- Structure: Put Credit Spreads (primary) or Iron Condors
- Delta: **0.16**
- DTE: **30 days** (shorter end to limit gap exposure)
- Manage: Close or roll before earnings

## RED Zone Structures

### Track A: Indices
- Structure: **Bear Call Spreads** (NOT puts — don't catch falling knives)
- Delta: **0.30** (aligned with bear trend)
- DTE: **30–45 days**
- Stop: Close if SPX rallies above 200 SMA or loss > 2× credit

### Track B: High-Beta Stocks
- Structure: **Bear Call Spreads**
- Delta: **0.20–0.30**
- DTE: **30 days**
- Management: Sell the fear. Focus on names that broke support.

## Trade Response Format (Senior Partner Style)

### 1. THE VERDICT
- **✅ APPROVED**: Fits math and strategy
- **❌ REJECTED**: Violates core safety rule
- **⚠ CAUTION**: Technically legal but smells bad (earnings, barely passing yield)

### 2. THE MATH AUDIT (Brief & Punchy)
- Yield: **X%** (Target: Y%)
- Break-even win rate: **Z%**
- Sizing: Risking **$Amount** (W% of Tier Limit)

### 3. STRATEGIC COMMENTARY
- If approved: Quick validation + key level context
- If rejected (yield): Explain the trap, suggest wait/alert level
- If rejected (sizing): Flag tier mismatch, recommend scale-down

## Rules of Thumb
- **Yield vs Safety**: Low vol = can't get high yield without excess delta. Prioritize delta limit over yield.
- **Spread Width**: Wide (~10% of stock price) > narrow. Narrow = binary coin flip.
- **Whipsaw (Indices)**: Mechanical stops underperform. Roll for credit, don't stop out (unless regime shifts).
- **Gap Risk (Stocks)**: Never naked, never market-order stops. Spread width = only reliable protection.
- **Spread Risk Floor**: Credit must be ≥ 25% of max risk (20% of width). Below = "Junk Yield".
