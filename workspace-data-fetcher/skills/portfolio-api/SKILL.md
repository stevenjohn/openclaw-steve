---
name: portfolio-api
description: Portfolio positions, accounts, performance, and bucket allocation endpoints.
---

# Portfolio API

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoints

### Portfolio Strategy (Legacy Bucket View)
```
GET /webhook/portfolio-strategy
```
Returns: Portfolio NAV, holdings per bucket (B0-B3), bucket stats (current %, target %, gap, action), target shopping list.

### Portfolio Buckets (Summary)
```
POST /webhook/portfolio-buckets
{}
```
Returns: 4-row summary — NAV, current %, target %, gap, action per bucket.

### Portfolio Bucket Detail (Drill-Down)
```
POST /webhook/portfolio-bucket-detail
{"bucket": "B2"}
```
Returns: Assets in bucket with values, targets, deviations, planning fields (entry zones, grades, thesis, last_reviewed).

### Accounts Summary
```
GET /webhook/accounts-summary
```
Returns: Total portfolio equity, per-account breakdown (equity, MTD return %, leverage, cash/margin, max exposure, 30-day realized P&L), leverage alerts.

### Stock Positions (with LEAPs)
```
GET /webhook/stocks-positions
```
Returns: Stock holdings (symbol, qty, price, value, sector, status, weight), LEAPs (strike, expiry, DTE, premium, notional), aggregations (total value, top 5, sector breakdown, concentration alerts).

### Performance (YTD + Historical)
```
GET /webhook/performance-ytd
```
Optional query params: `?months=6`, `?months=12`, `?months=24`
Returns: Summary (total P&L $ and %, equity, win/loss months), monthly breakdown (equity, P&L, cumulative, deposits/withdrawals).
