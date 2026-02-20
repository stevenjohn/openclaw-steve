# Portfolio & Accounts

Portfolio positions, account balances, and performance tracking via n8n endpoints.

## Authentication

**All requests require:**
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`

**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## 💼 Portfolio Strategy (Bucket Allocation)

**Endpoint:** `GET /webhook/portfolio-strategy`

Strategic portfolio breakdown by bucket (B0-B3) with targets and funding gaps.

**Returns:**
- Portfolio NAV (Net Asset Value)
- **Current holdings per bucket** (symbol, role, priority, value, quantity)
- **Bucket stats:** current %, target %, funding gap, action (BUY/TRIM/HOLD)
- **Target shopping list** per bucket (symbols to buy when rebalancing)

**Bucket Structure:**
- **B0:** Cash / Dry Powder (target 5%)
- **B1:** Crypto (target 15%)
- **B2:** AI & Growth (target 55%)
- **B3:** Real Assets (target 25%)

**Use for:** 
- "What's my portfolio allocation?"
- "Which bucket needs funding?"
- "What should I be buying?"
- "Show me B2 holdings"
- "Am I overweight crypto?"

---

## 💰 Accounts Summary

**Endpoint:** `GET /webhook/accounts-summary`

Account-level balances, equity, leverage, and performance across all trading accounts.

**Returns:**
- **Total portfolio equity** (all accounts combined)
- **Per-account breakdown:**
  - Current equity + month-start equity
  - MTD return %
  - Leverage ratio (1.0 = no leverage)
  - Cash/margin available
  - Max single-asset exposure (largest position per account)
  - 30-day realized P&L
- **Leverage alerts** (accounts using margin)
- **Sandbox accounts** (test/paper accounts flagged separately)

**Accounts tracked:** IB (C), IB (S), ToS, Saxo, SwissQuote, SafePal, Trezor, Kraken, OKX, ByBit, Phantom

**Use for:** 
- "What's my total equity?"
- "Am I using leverage?"
- "Which account has the most exposure?"
- "Show me month-to-date performance"
- "What's my 30-day P&L?"

---

## 📊 Stock Positions (with LEAPs)

**Endpoint:** `GET /webhook/stocks-positions`

Detailed view of stock holdings PLUS long-dated call options (LEAPs) for combined equity exposure.

**Returns:**

**Stock Positions:**
- Symbol, quantity, current price, value
- Sector classification
- Status (Core/Guest/Target)
- Target weight % vs actual weight %
- Portfolio weight concentration

**LEAPs (Long-dated Calls):**
- Symbol, strike, expiry, contracts, DTE
- Premium paid vs notional exposure
- Combined equity exposure = stocks + LEAP notional

**Aggregations:**
- Total stock value + total LEAP notional
- Top 5 holdings by value
- Positions by sector (AI, Chips, Crypto, etc.)
- Concentration alerts (positions >20% of portfolio)

**Use for:** 
- "What stocks do I own?"
- "How much NVDA do I have?"
- "What's my biggest position?"
- "Show me sector exposure"
- "What LEAPs am I holding?"
- "What's my total equity exposure including options?"

---

## 📈 Performance (YTD + Historical)

**Endpoint:** `GET /webhook/performance-ytd`

Portfolio performance with monthly breakdown and flow-adjusted returns.

**Default:** Returns current year-to-date (YTD)

**Optional Query Params:**
- `?months=6` - Last 6 months
- `?months=12` - Last 12 months (trailing year)
- `?months=24` - Last 24 months (2-year view)

**Returns:**
- **Summary:** Total P&L ($ and %), current equity, win/loss month count
- **Monthly breakdown:**
  - Equity at month-end
  - Monthly P&L ($ and %)
  - Cumulative P&L ($ and %)
  - Deposits and withdrawals (flow-adjusted)

**Use for:** 
- "How am I doing this year?"
- "What was my best/worst month?"
- "Show me last 12 months performance"
- "What's my 6-month return?"
- "How many winning months did I have?"

---

## Quick Reference

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /webhook/portfolio-strategy | GET | Bucket allocation + holdings + targets |
| /webhook/accounts-summary | GET | All account balances/equity/leverage |
| /webhook/stocks-positions | GET | Stock holdings + LEAPs + sector exposure |
| /webhook/performance-ytd | GET | Monthly/YTD performance (add ?months=N for historical) |
