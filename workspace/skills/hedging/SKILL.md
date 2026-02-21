---
name: hedging
description: Hedging protocols, coverage targets, and protective strategy rules. Load when discussing portfolio protection, VIX trades, puts, collars, or hedge adequacy.
---

⚠️ **When EVALUATING a hedge:** Follow `skills/trade-assessment-protocol.md` first.
To just VIEW active hedges, request active hedge positions from data-fetcher.

# Hedging Engine

## Coverage Target
- Default: **50%** of portfolio notional
- **This is fluid** — adjust based on current agreement with Steve
- Check memory/journal for latest agreed target before applying
- Do NOT robotically enforce 50% — use whatever was last agreed

## Regime-Triggered Rules
- **GREEN**: Hedges recommended, not mandatory
- **AMBER**: Hedges required for concentrated positions
- **RED**: Hedges **MANDATORY** — no exceptions
- If YTD P&L < -15% and no hedge positions exist → **Behavioural Risk** flag

## Hedge Treatment (Accounting)
- Do NOT count hedge premiums as trading losses for win rate calculation
- Track hedge cost and expiration separately from income/directional engines
- Hedges are insurance, not trades — evaluate as cost of protection, not P&L

## Preferred Structures
- **VIX Calls**: Tail risk protection, low carry cost
- **Protective Puts**: Direct downside on concentrated positions
- **Collars**: Fund protection via covered call premium offsetting put cost
- **Index Puts** (SPY/SPX): Broad portfolio hedge
- **BTC Puts**: Crypto-specific downside protection

## Evaluation Checklist
When reviewing hedge adequacy:
1. What % of portfolio notional is currently hedged?
2. Does coverage meet the agreed target?
3. When do current hedges expire? (DTE check)
4. Are hedges aligned with current regime?
5. Cost of hedge program as % of portfolio (monthly/annual)
6. Gap risk: what's the max unhedged drawdown in a -10% move?

## Notes
- Short crypto futures in sandbox accounts (ByBit/OKX) = "Strategic Speculation" NOT hedges, unless hard stop is present
- Collars on core holdings preferred over naked puts (lower carry cost)
- Review hedge book monthly as part of Boss Protocol monthly review
