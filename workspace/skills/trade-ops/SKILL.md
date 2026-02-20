# Trade Operations Skill

**Purpose:** Conversational trade entry/exit system with structured tagging for quality analysis.

## Overview

Steve sends trades directly to Elon → validation → DB insert via CRUD endpoint.  
Replaces screenshot pipeline with conversational processing.

**Why this matters:**
- Prevents errors at entry (not after)
- Captures complex rolls/splits/restructures
- Rich journal context with tags
- Direct DB access for corrections

---

## CRUD Endpoint

**Base URL:** `https://beep.stevewalker.net/webhook/option_trade_ops`  
**Auth:** `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`  
**Method:** POST

### Actions

#### 1. list
```json
{
  "action": "list",
  "symbol": "AAPL",           // optional
  "status": "Active",         // optional: Active, Closed, Expired, etc.
  "account_id": "uuid",       // optional
  "expiry_from": "2026-02-17", // optional: YYYY-MM-DD
  "expiry_to": "2026-03-21",   // optional: YYYY-MM-DD
  "limit": 10                  // optional, default 100
}
```

#### 2. get
```json
{
  "action": "get",
  "trade_id": "uuid"
}
```

#### 3. create

**IMPORTANT:** Create action expects data nested under `"data": { ... }` key (unlike update/delete which read from top level).

```json
{
  "action": "create",
  "data": {
    "account_id": "uuid",
  "symbol": "AAPL",
  "strategy_type": "bull_put_spread",
  "trade_datetime_open": "2026-02-17T14:30:00.000Z",
  "expiry": "2026-03-21",
  "status": "Active",
  "qty_open": 1,
  "side_open": "SELL",
  "price_open": 0.50,
  "cash_open": 50.00,
  "max_loss_est": 450.00,
  "open_stock_price": 172.50,
  "legs_details": {
    "legs": [
      {"strike": 170, "type": "put", "side": "SELL", "qty": 1},
      {"strike": 165, "type": "put", "side": "BUY", "qty": 1}
    ],
    "legs_count": 2
  },
  "entry_journal": "Tags: #Source_Self #Target_50pct #Sup_Res\n\nAAPL bounced off 21 MA support at $170. Selling 165/170 bull put spread for income with 50% target.",
  "hedge_flag": false
    }
  }
}
```

#### 4. update
```json
{
  "action": "update",
  "trade_id": "uuid",
  "entry_journal": "Updated journal text",
  "status": "Closed",
  "exit_journal": "Tags: #TP_Hit #Boss_Mode\n\nClosed at 50% profit target as planned."
}
```

#### 5. delete
```json
{
  "action": "delete",
  "trade_id": "uuid"
}
```

---

## Account ID Map

**Logic layer only** - endpoint uses UUIDs, skill translates names:

- **Saxo**: `fae1ac21-a1c5-4ef2-b68a-27a0e71f1e0f`
- **ToS (Thinkorswim)**: `20be4501-a4ca-4e64-a9c5-c4613748b3d3`
- **IB (S)**: `1eaf83e9-a11b-476a-89e7-4fa45302b68c`
- **IB (C)**: `3122556f-0739-4bd7-92a9-0187b34ad100`
- **IB (K)**: `f08f6683-a11b-476a-89e7-4fa45302b68c`
- **IB (H)**: `82950690-a11b-476a-89e7-4fa45302b68c`

When Steve says "IB (S)" or "ToS", translate to UUID before calling endpoint.

---

## Strategy Codes

Use these for `strategy_type` field:

**Income (Premium Collection):**
- `covered_call`
- `cash_secured_put`
- `bull_put_spread`
- `bear_call_spread`
- `iron_condor`
- `jade_lizard`

**Directional (Debit):**
- `long_call`
- `long_put`
- `bull_call_spread`
- `bear_put_spread`
- `call_debit_spread`
- `put_debit_spread`

**Complex:**
- `long_combo` (synthetic long)
- `short_combo` (synthetic short)
- `long_straddle`
- `short_straddle`
- `long_strangle`
- `short_strangle`
- `butterfly`
- `condor`

**Hedges:**
- `protective_put`
- `collar`
- `vix_hedge`

---

## Entry Tags (The "Why" & "The Plan")

Apply when opening the trade. Include in `entry_journal`.

### A. THE SOURCE (Who's Idea?)
- `#Source_IA` - InvestAnswers (e.g., Copper Thesis)
- `#Source_CTL` - Chart The Lane / Technical Service
- `#Source_BL` - Boss Level / Me
- `#Source_Self` - Your own idea

### B. THE STRATEGY & INTENT (What are we doing?)

**Income Specific:**
- `#Target_50pct` - Standard Managed Income (Close at 50%)
- `#Target_80pct` - Aggressive Income (Let it decay deep)
- `#Exp_Ride` - Hold to Expiration (100% or nothing)
- `#Accumulate` - Happy to own shares, will not force-exit at 21 DTE
- `#Wheel_In` - Selling Put, *wanting* assignment/accumulation
- `#Wheel_Out` - Selling Call, *wanting* shares called away

**Debit/Directional:**
- `#Swing` - Short term directional
- `#LEAPS` - Long term replacement
- `#Lotto` - Low probability, high reward

**Hedges:**
- `#Tail_Hedge` - Crash protection (e.g., VIX)
- `#Delta_Neutral` - Balancing portfolio delta

### C. THE TRIGGER (Technical/Fundamental)
- `#Sup_Res` - Support/Resistance Bounce
- `#Breakout` - Crossing a key level (e.g., FCX > $63)
- `#MA_Test` - Bounce off 21/50/200 MA
- `#Earnings_Play` - Trading event volatility
- `#High_IV` - Selling purely because premiums are juicy

---

## Exit Tags (The "Result" & "Reality")

Apply when closing the trade. Include in `exit_journal`.

### A. THE OUTCOME (Pure Data)
- `#TP_Hit` - Limit order filled at target. Perfect execution.
- `#Stop_Hit` - Mechanical stop triggered.
- `#Time_Stop` - Closed because DTE < 21 or thesis took too long.
- `#Assigned` - Put shares in account or Call shares taken away.
- `#Expired` - Worthless (Good for short, bad for long).

### B. THE MANAGEMENT (The Decision)
- `#Early_Take` - Closed green before 50% to reduce risk/free capital.
- `#Roll_Defensive` - Rolling down/out to save a loser.
- `#Roll_Attack` - Rolling up/out to capture more trend.
- `#Leg_Out` - Closing one side of a spread/condor.

### C. THE PSYCHOLOGY (The Learning Loop - CRITICAL)
- `#Boss_Mode` - Followed plan perfectly, win or lose.
- `#FOMO_Entry` - Realized later you chased.
- `#Panic_Exit` - Sold because you were scared, not rules.
- `#Greed_Hold` - Held a winner until it became a loser.
- `#Fat_Finger` - Execution error.

---

## Journal Format

**Entry journal example:**
```
Tags: #Source_CTL #Swing #Breakout

FCX broke above $63 resistance with strong volume. Chart The Lane
signaled bullish setup. Buying $63/$68 bull call spread, 35 DTE.
Target: 50% profit or $68 price target hit.
Stop: Close below $62.
```

**Exit journal example:**
```
Tags: #TP_Hit #Boss_Mode

Closed at 52% profit as FCX hit $66.50. Followed plan perfectly.
Held for 18 days. Original thesis played out.
```

---

## DB Schema Reference

**Key fields:**

| Field | Type | Notes |
|-------|------|-------|
| `trade_id` | uuid | Primary key (auto-generated) |
| `account_id` | uuid | Required - use account map |
| `symbol` | text | Required |
| `strategy_type` | text | Required - use strategy codes |
| `expiry` | date | Required |
| `status` | text | Active, Closed, Expired, Rolled, Bought Back |
| `trade_datetime_open` | timestamp | Required |
| `trade_datetime_close` | timestamp | Optional |
| `qty_open` | integer | Contract quantity |
| `side_open` | text | BUY or SELL |
| `price_open` | numeric | Price per contract |
| `cash_open` | numeric | Net cash flow (positive = credit) |
| `max_loss_est` | numeric | Risk estimate |
| `open_stock_price` | numeric | Underlying price at entry |
| `close_stock_price` | numeric | Underlying price at exit |
| `legs_details` | jsonb | Spread structure |
| `entry_journal` | text | Entry tags + context |
| `exit_journal` | text | Exit tags + outcome |
| `hedge_flag` | boolean | True if protective hedge |
| `rolled_from_trade_id` | uuid | Link to original if rolled |

**Generated columns (read-only):**
- `cash_close` - calculated from close fields
- `realized_pnl` - total P&L
- `contract_kind` - C, P, or COMBO
- `assignment_adj_pnl` - P&L adjusted for assignments

---

## Operation Workflows

### Opening a New Trade

**Steve says:** "Opened bull put spread on QQQ, 450/445, sold for $0.75, Mar 21 expiry, ToS account."

**You respond:**
1. **AUTO-FETCH current price** via `/webhook/market-data` (use SPY for SPX) UNLESS Steve says it's a past date
2. Ask for context/tags if needed
3. Translate account name → UUID
4. Build `legs_details` structure
5. Construct `entry_journal` with tags
6. Call `create` action with fetched `open_stock_price`
7. Confirm trade_id and summary

**CRITICAL:** Always fetch `open_stock_price` from market-data endpoint. DO NOT ask Steve for it. Only skip if trade is backdated (Steve explicitly mentions a past date).

### Closing a Trade

**Steve says:** "Closed QQQ spread at $0.35, hit my 50% target."

**You respond:**
1. Find the trade (list by symbol/status)
2. Calculate P&L (sold $0.75, bought back $0.35 = $40 profit)
3. Ask for exit context/tags
4. Call `update` with close fields and `exit_journal`
5. **If a TradingView URL is present in the message → include it as `exit_chart`**
6. **If opening a trade and TV URL present → include it as `entry_chart`**
7. Confirm final P&L

**CRITICAL: Determining `side_close`**

The `side_close` field represents **NET CASH FLOW**, not individual leg actions.

**Example 1: Simple credit spread close**
- Opened: Sold bull put spread for $0.75 credit
- Closed: Bought back for $0.35 debit
- Net: You PAID $0.35 → `side_close: "BUY"`

**Example 2: Multi-leg combo close (AMZN lesson)**
- Opened: 3-leg combo for $0.40 debit
- Closed: 
  - Paid $6.56 to close 220C/200P combo (debit)
  - Received $1.25 for 170P (credit)
  - Net: PAID $5.31 (-$6.56 + $1.25)
- **Net: You PAID $5.31 → `side_close: "BUY"`**

**Rule of thumb:**
- If closing costs money (net debit) → `side_close: "BUY"`
- If closing makes money (net credit) → `side_close: "SELL"`
- Always verify P&L makes sense against chart context

### Rolling a Trade

**Rolling = Close old + Open new, linked via `rolled_from_trade_id`**

**Steve says:** "Roll my AAPL 170 put down to 165 and out to next month."

**You respond:**
1. Find original trade
2. Close it with `status: "Rolled"` and exit journal
3. Create new trade with same structure but new strike/expiry
4. Set `rolled_from_trade_id` to original `trade_id`
5. Link context in both journals

### Splitting a Position

**When closing partial quantity:**

**Steve says:** "Closed 2 of 5 contracts on my SPY iron condor."

**You respond:**
1. Create new trade for the 2 closed contracts (status: "Closed")
2. Update original trade `qty_open: 3` (reduce by 2)
3. Journal notes the split in both records

### Restructuring/Legging

**When managing one leg independently:**

**Steve says:** "Bought back the short put side of my condor, leaving the call spread."

**You respond:**
1. Update original trade status: "Restructured"
2. Create new trade for remaining structure
3. Document the change in exit_journal of original

---

## Validation Checklist

Before inserting/updating trades:

**Entry validation:**
- [ ] `entry_chart` populated if TV URL was in Steve's message
- [ ] **`open_stock_price` fetched from market-data endpoint** (unless backdated trade)
- [ ] Account ID translated correctly
- [ ] Strategy code matches structure
- [ ] Expiry date is future (unless backfilling)
- [ ] DTE is 30-45 days (flag if weekly)
- [ ] Entry journal includes tags
- [ ] `legs_details` structure is complete
- [ ] `cash_open` sign is correct (credit = positive)

**Exit validation:**
- [ ] `exit_chart` populated if TV URL was in Steve's message
- [ ] Exit journal includes outcome tags
- [ ] P&L calculation matches reality
- [ ] Status reflects true outcome (Closed, Expired, Assigned, Rolled)
- [ ] Psychology tag included (#Boss_Mode or deviation)
- [ ] **CRITICAL:** `side_close` matches NET CASH FLOW direction:
  - If you PAY to close (net debit) → `side_close: "BUY"`
  - If you RECEIVE to close (net credit) → `side_close: "SELL"`
  - Ignore individual leg actions - only net cash flow matters
- [ ] Chart context sanity check: Does P&L align with price movement?

---

## Tag Analysis Queries

**After building trade history, these patterns become valuable:**

- Trades with `#FOMO_Entry` → average P&L vs `#Boss_Mode`
- Trades with `#Panic_Exit` → how many recovered?
- `#Target_50pct` hit rate and average hold time
- `#Source_CTL` win rate vs `#Source_Self`
- `#Greed_Hold` cost analysis (winners → losers)

The tags are the **learning loop** - they turn trade history into behavioral feedback.

---

## Notes

- Always use `entry_journal` and `exit_journal` for rich context
- Tags make analysis possible - enforce them consistently
- Account IDs in skill only (not in n8n data layer)
- Rolls create two linked trades, not updates
- Splits/legs create separate records, document relationships
- Psychology tags are as important as outcome tags
