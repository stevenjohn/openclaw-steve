---
name: market-data-api
description: Market data endpoints — context, technicals, news, fundamentals.
---

# Market Data API

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoints

### Market Context
```
GET /webhook/market-context
```
Returns: Traffic Light status (Green/Amber/Red), SPY vs SMA levels, VIX/RVX, market breadth.

### Technical Analysis
```
POST /webhook/market-data
{"tool": "get_market_data", "ticker": "AAPL"}
```
Returns: OHLC, floor pivots, 3-timeframe technicals (MAs, RSI, MACD), S/R structure.
Add `"force_refresh": true` to bypass 18h cache.

### News & Sentiment
```
POST /webhook/market-data
{"tool": "get_news", "ticker": "AAPL"}
```
Returns: 5 recent articles with AI sentiment scores.

### Ticker Details (Fundamentals)
```
POST /webhook/market-data
{"tool": "get_ticker_details", "ticker": "AAPL"}
```
Returns: Market cap, sector, company fundamentals.

## Rules
- One ticker per request.
- No VIX direct queries — use Market Context for VIX level.
- No SPX — use SPY. No RUT — use IWM.
- If endpoint fails, return exact HTTP status and error body.
