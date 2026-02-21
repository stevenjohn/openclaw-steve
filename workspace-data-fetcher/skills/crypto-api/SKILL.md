---
name: crypto-api
description: Crypto positions, on-chain holdings, and weekly P&L endpoints.
---

# Crypto API

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoints

### Crypto Positions
```
GET /webhook/crypto-positions
```
Returns: Active and recently closed crypto trades — exchange, pair, side, risk amount, hedge flags.

### On-Chain Holdings
```
GET /webhook/onchain-holdings
```
Returns: On-chain crypto holdings by asset and wallet/exchange — asset, quantity, USD value, location.

### Weekly Crypto P&L
```
GET /webhook/weekly-crypto
```
Returns: Weekly realized P&L from closed crypto trades.
