# Market Data & Context

Real-time market data and trading context via n8n endpoints.

## Authentication

**All requests require:**
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`

**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## 🚦 Market Context (Traffic Light)

**Endpoint:** `GET /webhook/market-context`

**Call this at session start** to establish current market regime.

**Returns:**
- Traffic Light status: Green (risk-on) / Amber (cautious) / Red (defensive)
- Trend analysis: SPY vs SMA levels
- Volatility: VIX and RVX readings
- Market breadth indicators
- Risk signals: Safe Haven vs Junk Bond demand

**Use for:** "What's the market doing?", "Should I be aggressive or defensive?", "Is it safe to add risk?"

---

## 📰 News Checking Workflow

**When Steve says:** "check news", "check markets and news", "any weekend news", etc.

**DO NOT ASK** if you should check. **Just do it.**

**Proactive search workflow:**

1. **Use tavily-search skill** to search for:
   - "stock market news today"
   - "VIX volatility news"
   - "geopolitical news affecting markets"
   - "S&P 500 outlook [current week]"
   - Any specific events mentioned (e.g., "Presidents Day weekend", "FOMC meeting")

2. **Synthesize findings** into:
   - Major market-moving events
   - Sentiment shifts (risk-on vs risk-off)
   - Relevant catalysts for the week ahead
   - Geopolitical tensions or policy changes

3. **Connect to trading implications:**
   - Does this support/contradict current market context?
   - Any regime change signals?
   - Impact on premium levels or volatility?

**Do not ask permission.** When Steve mentions checking news, run the searches and report back.

---

## 📊 Polygon Market Data (3-IN-1 TOOL)

**Endpoint:** `POST /webhook/market-data`

Real-time and cached market data for US stocks via Polygon.io. **This is a 3-in-1 endpoint** with three sub-functions controlled by the `tool` parameter. **Each function accepts ONE ticker per request.**

---

### 1️⃣ get_market_data (PRIMARY FUNCTION)

**This is the main function for technical analysis.** Returns comprehensive unified payload.

**Input:**
```json
{"tool": "get_market_data", "ticker": "SPY"}
{"tool": "get_market_data", "ticker": "NVDA"}  // One ticker per call
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tool | string | Yes | `get_market_data` |
| ticker | string | Yes | Stock symbol (e.g., SPY, NVDA, AAPL) |
| force_refresh | boolean | No | Bypass 18-hour cache (default: false) |

**Note:** Call separately for each ticker. No arrays or comma-separated lists.

**Returns comprehensive payload:**
- **Current price:** OHLC, volume, change %
- **Floor trader pivots:** P, R1-R3, S1-S3
- **Technicals across 3 timeframes** (daily/weekly/monthly):
  - EMA(10), SMA(21, 50, 200)
  - RSI(14), MACD (value, signal, histogram)
- **Support/Resistance structure** (daily & weekly):
  - 3 nearest levels each direction
  - Range position %, trend context
- **Price action:** Candlestick pattern, type, strength, volatility %

**Use for:** "How is AAPL doing?", "Is SPY overbought?", "Where are support levels for NVDA?", "Full technical breakdown of TSLA"

**Data caching:** Cached for 18 hours. Use `force_refresh: true` only when you need live data.

**Strategy Notes:**
- Call `get_market_data` ONCE - it's comprehensive
- Validate patterns against S/R levels or key MAs (patterns in isolation are noise)
- Use weekly structure for major S/R; daily for tactical entries
- RSI > 70 = overbought, RSI < 30 = oversold
- MACD histogram crossing zero = momentum shift

---

### 2️⃣ get_news

**Recent news articles with AI sentiment analysis.** Always fetched live (not cached).

**Input:**
```json
{"tool": "get_news", "ticker": "TSLA"}
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tool | string | Yes | `get_news` |
| ticker | string | Yes | Stock symbol |

**Returns:** 5 most recent articles with:
- Title, publisher, date, URL
- **AI sentiment:** Positive/Negative/Neutral
- **Sentiment reasoning:** Why the AI scored it that way
- Article summary

**Use for:** "Why is TSLA down today?", "Any news on NVDA?", "What's driving CRWD?"

---

### 3️⃣ get_ticker_details

**Company fundamentals and profile data.** Always fetched live (not cached).

**Input:**
```json
{"tool": "get_ticker_details", "ticker": "CRWD"}
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| tool | string | Yes | `get_ticker_details` |
| ticker | string | Yes | Stock symbol |

**Returns:**
- Company name
- Market Cap
- Sector & Industry code
- Number of employees
- IPO/list date
- Company description
- Shares outstanding
- Website & HQ location

**Use for:** "What does this company do?", "What sector is PLTR in?", "When did CRWD go public?"

---

## ⚠️ Limitations

**VIX is NOT supported here.** Always fetch VIX data from Market Context endpoint instead.

**SPX is NOT supported.** Use SPY as a proxy for S&P 500.

**RUT is NOT supported.** Use IWM as a proxy for Russell 2000.

---

## Quick Reference

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /webhook/market-context | GET | Traffic Light status + VIX (CALL FIRST) |
| /webhook/market-data | POST | 3-in-1: Price/technicals/news/fundamentals |

**Sub-functions for market-data:**
- `get_market_data` → Full technical analysis (PRIMARY)
- `get_news` → Recent articles with AI sentiment
- `get_ticker_details` → Company fundamentals
