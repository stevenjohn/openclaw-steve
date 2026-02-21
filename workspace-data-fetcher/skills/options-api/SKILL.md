---
name: options-api
description: Options positions, P&L, and hedge tracking endpoints.
---

# Options API

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoints

### Active Income (Credit/Short Premium)
```
GET /webhook/options-active-income
```
Returns: Active credit/income positions — symbol, strike, expiry, DTE, premium collected, current P&L (opening side = SELL).

### Active Debit (Long Calls/Puts)
```
GET /webhook/options-active-debit
```
Returns: Active debit positions — symbol, strike, expiry, DTE, premium paid, current P&L (opening side = BUY).

### Active Hedges
```
GET /webhook/options-active-hedges
```
Returns: All positions where hedge_flag = true (protective puts, collars, VIX calls), regardless of credit/debit.

### Closed Trades
```
GET /webhook/options-closed
```
Returns: Closed option trades (current + prior month) — symbol, strategy, status, realized P&L, days in trade, win/loss.

### Weekly Debit P&L
```
GET /webhook/weekly-debit
```
Returns: Weekly P&L from closed debit option trades.
