---
name: trade-ops-api
description: Trade CRUD operations, account ID map, and strategy codes.
---

# Trade Operations API

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoint
```
POST /webhook/option_trade_ops
```

## Actions

### list
```json
{
  "action": "list",
  "symbol": "AAPL",
  "status": "Active",
  "account_id": "uuid",
  "expiry_from": "2026-02-17",
  "expiry_to": "2026-03-21",
  "limit": 10
}
```
All filter fields are optional. Default limit: 100.

### get
```json
{"action": "get", "trade_id": "uuid"}
```

### create
**IMPORTANT:** Data nests under `"data": { ... }` key.
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
    "entry_journal": "Tags: #Source_Self #Target_50pct #Sup_Res\n\nBounced off 21 MA support.",
    "hedge_flag": false
  }
}
```

### update
```json
{
  "action": "update",
  "trade_id": "uuid",
  "status": "Closed",
  "trade_datetime_close": "2026-03-01T15:00:00.000Z",
  "qty_close": 1,
  "side_close": "BUY",
  "price_close": 0.25,
  "cash_close": -25.00,
  "close_stock_price": 175.00,
  "exit_journal": "Tags: #TP_Hit #Boss_Mode\n\nClosed at 50% profit."
}
```

**side_close rule:** Net cash flow direction. If closing costs money (net debit) → `"BUY"`. If closing makes money (net credit) → `"SELL"`.

### delete
```json
{"action": "delete", "trade_id": "uuid"}
```

## Account ID Map

| Account | UUID |
|---------|------|
| Saxo | fae1ac21-a1c5-4ef2-b68a-27a0e71f1e0f |
| ToS | 20be4501-a4ca-4e64-a9c5-c4613748b3d3 |
| IB (S) | 1eaf83e9-a11b-476a-89e7-4fa45302b68c |
| IB (C) | 3122556f-0739-4bd7-92a9-0187b34ad100 |
| IB (K) | f08f6683-a11b-476a-89e7-4fa45302b68c |
| IB (H) | 82950690-a11b-476a-89e7-4fa45302b68c |

## Strategy Codes

**Income:** covered_call, cash_secured_put, bull_put_spread, bear_call_spread, iron_condor, jade_lizard
**Directional:** long_call, long_put, bull_call_spread, bear_put_spread, call_debit_spread, put_debit_spread
**Complex:** long_combo, short_combo, long_straddle, short_straddle, long_strangle, short_strangle, butterfly, condor
**Hedges:** protective_put, collar, vix_hedge

## Key Schema Fields

| Field | Type | Notes |
|-------|------|-------|
| trade_id | uuid | PK, auto-generated |
| account_id | uuid | Required — use map above |
| symbol | text | Required |
| strategy_type | text | Required — use codes above |
| expiry | date | Required |
| status | text | Active, Closed, Expired, Rolled, Bought Back |
| legs_details | jsonb | `{"legs": [...], "legs_count": N}` |
| entry_journal | text | Tags + context |
| exit_journal | text | Tags + outcome |
| hedge_flag | boolean | True if protective hedge |
| rolled_from_trade_id | uuid | Link to original if rolled |
| entry_chart | text | TradingView URL if provided |
| exit_chart | text | TradingView URL if provided |
