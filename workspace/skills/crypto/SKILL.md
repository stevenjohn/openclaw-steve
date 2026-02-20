# Crypto Trading

Crypto positions, holdings, and P&L via n8n endpoints.

## Authentication

**All requests require:**
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`

**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## 🪙 Crypto Positions

**Endpoint:** `GET /webhook/crypto-positions`

Active and recently closed crypto trades.

**Returns:**
- Exchange, pair, side
- Risk amount
- Hedge flags

**Use for:** "What crypto trades are open?", "What's my BTC exposure?"

---

## Onchain Holdings

**Endpoint:** `GET /webhook/onchain-holdings`

On-chain crypto holdings by asset and wallet/exchange.

**Returns:**
- Asset, quantity, USD value
- Wallet/exchange location

**Use for:** "How much crypto do I hold?", "Where's my ETH?", "Exchange balances?"

---

## Weekly Crypto P&L

**Endpoint:** `GET /webhook/weekly-crypto`

Weekly realized P&L from closed crypto trades.

**Use for:** "How did crypto trading go this week?"

---

## Quick Reference

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /webhook/crypto-positions | GET | Active crypto trades |
| /webhook/onchain-holdings | GET | Wallet/exchange crypto |
| /webhook/weekly-crypto | GET | Weekly crypto P&L |
