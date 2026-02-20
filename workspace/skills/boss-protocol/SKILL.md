---
name: boss-protocol
description: Portfolio oversight and longer term portfolio thinking. The Boss enforces discipline, prevents rule-breaking, and validates all actions against the rule hierarchy. Load when reviewing portfolio, or running monthly reviews.
---

⚠️ **For individual trade evaluations:** Follow `skills/trade-assessment-protocol.md` (Extract → Fetch → Journal → Assess) before applying verdict rules.
**For portfolio reviews / monthly reviews:** Use MAP protocol below (different data flow).

# Boss Protocol — Trade Validation & Portfolio Oversight

## Priority Hierarchy (Hard — higher overrides lower)
1. **MAP** (Mandatory Analysis Protocol)
2. **Live Data** (only what is explicitly present)
3. **Portfolio Risk Rules** (see PORTFOLIO-RULES.md)
4. **Options Rules** (see below + options-income/options-directional skills)
5. **Behavioural Principles** (see TRADING-PHILOSOPHY.md)

If a rule requires missing data → mark **SKIPPED**.

## MAP — Mandatory Analysis Protocol (v2.3)

### Step 1: Data Validation
**Required (blocks execution):**
- `performance.year_to_date`
- `accounts.balances`

Missing required → STOP, request corrected data.

**Soft fields (never block):** holdings, closed_trades, weekly_analysis, active_options → continue, mark SKIPPED.

### Step 2: Numeric Audit Block (first, no narrative)
- Month P&L (USD + %)
- YTD P&L (USD + %)
- Realised options P&L (sum or SKIPPED)
- Realised crypto P&L (sum or SKIPPED)
- Account-level equity changes
- Distinguish Transfers/Withdrawals from Trading P&L

### Step 3: Interpretation
- Reference only numbers from data
- Skip rules requiring missing data
- Apply Portfolio Risk Rules and Options Rules strictly
- State "Not evaluable due to missing data" where applicable

## Options Rules

### Premium-at-Risk (Debit/Long)
- Evaluate ONLY the stop level, NOT total premium
- No stop provided → request it, mark SKIPPED
- Max loss > 1% of account → Red Flag

### DTE Management
| Band | DTE | Rules |
|---|---|---|
| Urgent | ≤ 7 | Flag for immediate review |
| Short | 8–14 | Flag through earnings, flag on expiry day |
| Core Swing | 15–45 | Flag if DTE ≤ 21 ("21-Day Rule"), flag at ≥ 50% profit |
| Long-dated | 45+ | Monthly review only |

### Spread Risk
- Credit must be ≥ 25% of max risk (= 20% of spread width)
- Below threshold → "Junk Yield" flag

### Hedge Treatment
- Do NOT count hedge premiums as trading losses for win rate
- Track hedge cost and expiration separately

### Win Rate Discipline
| Strategy | Min | Flag |
|---|---|---|
| Credit/Income | 70% | Amber if below |
| Debit/Speculative | 50% | Amber if below |
| Combined | 50% | Red if below |

## Trade Verdict Format
```
VERDICT: ✅ APPROVED / ⚠ CONDITIONS / ❌ REJECTED / ⛔ CAUTION
```
- **✅ APPROVED**: Fits regime & rules perfectly
- **⚠ CONDITIONS**: Soft rule deviation justified by TA
- **❌ REJECTED**: Hard rule violation (Red Zone puts, earnings, aggressive delta without TA)
- **⛔ CAUTION**: Technically legal but significant external risk

## Output: Trade Evaluation
```
TICKER: [SYMBOL]
═══════════════════════════════════════
$ TECHNICAL REGIME
├─ Price: $XXX.XX
├─ vs 200 SMA: ABOVE/BELOW → Bullish/Bearish
├─ vs 50/21/10: [alignment]
├─ RSI: XX → Overbought/Oversold/Neutral
└─ MACD: Bullish/Bearish Cross

% STRUCTURE
├─ Nearest Resistance: $XXX, $XXX
├─ Nearest Support: $XXX, $XXX
├─ Range Position: XX%
└─ Trend: RANGE / BREAKOUT / BREAKDOWN

& TRIGGER
├─ Pattern: [NAME] or NO_CLEAR_PATTERN
└─ Validity: ✅ AT key level / ❌ NOISE

) CATALYST
├─ Sentiment: X Pos / X Neu / X Neg
└─ Event Risk: CLEAR / ⚠ FLAG

+ JOURNAL ALIGNMENT
└─ [Aligned / Conflict noted]
═══════════════════════════════════════
VERDICT: [VERDICT]
RATIONALE: [one sentence]
```

## Output: Quick Price Check
```
[TICKER]: $XXX.XX (▲/▼ X.XX%)
├─ 10 EMA: $XXX | 21 SMA: $XXX | 50 SMA: $XXX
├─ Pivot: $XXX | S1: $XXX | R1: $XXX
└─ RSI: XX | Range: XX%
```

## Output: Monthly Review
1. Numeric Audit Block (NAV, YTD P&L, Leverage, Market Zone)
2. Rule Violations
3. Concentration/Leverage Map
4. Hedge Adequacy
5. Top 3 Risks
6. Action Lists (Must-Close, Must-Hedge, Must-Review)
7. Mandate
