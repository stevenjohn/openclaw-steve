# Options Trading

Options positions, P&L, and hedge tracking via n8n endpoints.

## Authentication

**All requests require:**
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`

**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## 📈 Options - Active Income (Credit/Short Premium)

**Endpoint:** `GET /webhook/options-active-income`

Active CREDIT/INCOME option positions (short premium). Excludes hedges and debit trades.

**Returns:**
- Symbol, strike, expiry, DTE
- Premium collected
- Current P&L
- Opening side = SELL

**Use for:** "What premium am I collecting?", "What's my theta exposure?", "Which puts expire this week?"

---

## Options - Active Debit (Long Calls/Puts)

**Endpoint:** `GET /webhook/options-active-debit`

Active DEBIT option positions (long calls/puts, debit spreads). Excludes hedges.

**Returns:**
- Symbol, strike, expiry, DTE
- Premium paid
- Current P&L
- Opening side = BUY

**Use for:** "What speculative options do I have?", "How much premium am I risking?"

---

## Options - Active Hedges

**Endpoint:** `GET /webhook/options-active-hedges`

All active HEDGE positions (protective puts, collars, VIX calls, etc.).

**Returns:**
- All positions where hedge_flag = true
- Regardless of credit/debit

**Use for:** "What protection do I have?", "Am I hedged?", "Show my protective puts"

---

## Options - Closed Trades

**Endpoint:** `GET /webhook/options-closed`

Closed option trades (current + prior month) with realized P&L.

**Returns:**
- Symbol, strategy, status
- Realized P&L
- Days in trade
- Win/loss

**Use for:** "What did I close this month?", "What's my win rate?", "Show recent winners"

---

## Weekly Debit P&L

**Endpoint:** `GET /webhook/weekly-debit`

Weekly P&L from closed debit option trades (long calls/puts).

**Use for:** "How did my speculative trades do this week?"

---

## Quick Reference

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /webhook/options-active-income | GET | Short premium positions |
| /webhook/options-active-debit | GET | Long options positions |
| /webhook/options-active-hedges | GET | Hedge positions |
| /webhook/options-closed | GET | Closed options P&L |
| /webhook/weekly-debit | GET | Weekly debit options P&L |
