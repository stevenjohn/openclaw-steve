---
name: trade-ops
description: Trade entry/exit tagging, journal formats, and operation workflows. Load when recording trades, closing positions, rolling, or reviewing trade quality.
---

# Trade Operations — Tags & Workflows

This skill defines HOW to document trades (tags, journal format, workflows).
The actual API calls are handled by data-fetcher — instruct it with exact field values.

---

## Entry Tags (The "Why" & "The Plan")

Include in `entry_journal` field when opening a trade.

### A. THE SOURCE (Whose Idea?)
- `#Source_IA` — InvestAnswers
- `#Source_CTL` — Chart The Lane / Technical Service
- `#Source_BL` — Boss Level / Me
- `#Source_Self` — Your own idea

### B. THE STRATEGY & INTENT

**Income Specific:**
- `#Target_50pct` — Standard Managed Income (Close at 50%)
- `#Target_80pct` — Aggressive Income (Let it decay deep)
- `#Exp_Ride` — Hold to Expiration
- `#Accumulate` — Happy to own shares, will not force-exit at 21 DTE
- `#Wheel_In` — Selling Put, wanting assignment/accumulation
- `#Wheel_Out` — Selling Call, wanting shares called away

**Debit/Directional:**
- `#Swing` — Short term directional
- `#LEAPS` — Long term replacement
- `#Lotto` — Low probability, high reward

**Hedges:**
- `#Tail_Hedge` — Crash protection (e.g., VIX)
- `#Delta_Neutral` — Balancing portfolio delta

### C. THE TRIGGER (Technical/Fundamental)
- `#Sup_Res` — Support/Resistance Bounce
- `#Breakout` — Crossing a key level
- `#MA_Test` — Bounce off 21/50/200 MA
- `#Earnings_Play` — Trading event volatility
- `#High_IV` — Selling purely because premiums are juicy

---

## Exit Tags (The "Result" & "Reality")

Include in `exit_journal` field when closing a trade.

### A. THE OUTCOME
- `#TP_Hit` — Limit order filled at target
- `#Stop_Hit` — Mechanical stop triggered
- `#Time_Stop` — Closed because DTE < 21 or thesis took too long
- `#Assigned` — Put shares in account or Call shares taken away
- `#Expired` — Worthless

### B. THE MANAGEMENT
- `#Early_Take` — Closed green before 50% to reduce risk/free capital
- `#Roll_Defensive` — Rolling down/out to save a loser
- `#Roll_Attack` — Rolling up/out to capture more trend
- `#Leg_Out` — Closing one side of a spread/condor

### C. THE PSYCHOLOGY (CRITICAL — The Learning Loop)
- `#Boss_Mode` — Followed plan perfectly, win or lose
- `#FOMO_Entry` — Realized later you chased
- `#Panic_Exit` — Sold because scared, not rules
- `#Greed_Hold` — Held a winner until it became a loser
- `#Fat_Finger` — Execution error

---

## Journal Format

**Entry journal example:**
```
Tags: #Source_CTL #Swing #Breakout

FCX broke above $63 resistance with strong volume. Buying $63/$68 bull call spread, 35 DTE.
Target: 50% profit or $68 price target.
Stop: Close below $62.
```

**Exit journal example:**
```
Tags: #TP_Hit #Boss_Mode

Closed at 52% profit as FCX hit $66.50. Followed plan perfectly. Held 18 days.
```

---

## Operation Workflows

### Opening a New Trade

**Steve says:** "Opened bull put spread on QQQ, 450/445, sold for $0.75, Mar 21 expiry, ToS account."

1. **Fetch current stock price** from data-fetcher (unless Steve says it's a past date)
2. Ask for context/tags if not provided
3. Construct the full create instruction with all fields:
   - account (translate name to UUID via data-fetcher)
   - symbol, strategy_type, expiry, status=Active
   - qty, side_open, price_open, cash_open, max_loss_est
   - open_stock_price (from fetched data)
   - legs_details structure
   - entry_journal with tags
   - hedge_flag
   - entry_chart (if TradingView URL in message)
4. Instruct data-fetcher to create the trade
5. Confirm trade_id and summary to Steve

### Closing a Trade

1. Instruct data-fetcher to list trades by symbol/status to find the trade
2. Calculate P&L
3. Ask for exit context/tags
4. Construct update instruction:
   - status, trade_datetime_close, qty_close, side_close, price_close, cash_close, close_stock_price
   - exit_journal with tags
   - exit_chart (if TV URL present)
5. Instruct data-fetcher to update
6. Confirm final P&L

**side_close rule:** Based on NET CASH FLOW.
- Closing costs money (net debit) → side_close = "BUY"
- Closing makes money (net credit) → side_close = "SELL"
- Ignore individual leg actions — only net cash flow matters

### Rolling a Trade

Rolling = Close old + Open new, linked.

1. Find original trade
2. Close it with status "Rolled" + exit journal
3. Create new trade with new strike/expiry
4. Set `rolled_from_trade_id` to original trade_id
5. Link context in both journals

### Splitting a Position

When closing partial quantity:
1. Create new trade for closed contracts (status: "Closed")
2. Update original trade to reduce qty_open
3. Journal notes the split in both records

### Restructuring/Legging

When managing one leg independently:
1. Update original trade status: "Restructured"
2. Create new trade for remaining structure
3. Document the change in exit_journal

---

## Validation Checklist

**Before instructing data-fetcher to create:**
- [ ] open_stock_price fetched (unless backdated)
- [ ] Account name translated correctly
- [ ] Strategy code matches structure
- [ ] Expiry is future (unless backfilling)
- [ ] Entry journal includes tags
- [ ] legs_details is complete
- [ ] cash_open sign correct (credit = positive)
- [ ] entry_chart included if TV URL present

**Before instructing data-fetcher to close/update:**
- [ ] Exit journal includes outcome + psychology tags
- [ ] P&L calculation makes sense
- [ ] side_close matches net cash flow direction
- [ ] Status reflects true outcome (Closed, Expired, Assigned, Rolled)
- [ ] exit_chart included if TV URL present
