---
name: market-data
description: Real-time market context, technicals, and news via n8n.
---

# Market Data & Context

**CRITICAL ROUTING RULE:** You are the Income Trader. You must NEVER call these endpoints directly. To save tokens and enforce model routing, you MUST spawn the `data-fetcher` sub-agent and instruct it to call these endpoints and summarize the results for you. 

## Authentication (For Sub-Agent)
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## 🚦 1. Market Context
**Endpoint:** `GET /webhook/market-context`
- **Use:** Call at session start. Returns Traffic Light (Green/Amber/Red), SPY vs SMA, VIX/RVX, breadth.

## 📊 2. Polygon Market Data (3-in-1)
**Endpoint:** `POST /webhook/market-data`
**Body:** `{"tool": "<TOOL_NAME>", "ticker": "<TICKER>"}` (One ticker per request)

**Tools:**
- `get_market_data`: Primary tech analysis. Returns OHLC, pivots, 3-timeframe MAs/RSI/MACD, S/R levels. Cached 18h (use `"force_refresh": true` to bypass).
- `get_news`: 5 recent articles with AI sentiment.
- `get_ticker_details`: Fundamentals (Market cap, sector, etc).

**Limitations:**
- NO VIX (use Market Context). NO SPX (use SPY). NO RUT (use IWM).