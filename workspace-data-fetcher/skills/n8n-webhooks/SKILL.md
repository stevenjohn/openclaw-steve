---
name: n8n-webhooks
description: Core API routing for fetching raw market data and context.
---

# n8n Market Data Webhooks

You are the data-fetcher. Execute these endpoints when requested by the Income Trader and return the parsed data cleanly. 

## Authentication (Required for all calls)
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## 1. Market Context
**Endpoint:** `GET /webhook/market-context`
**Returns:** Traffic Light status, SPY vs SMA levels, VIX/RVX.

## 2. Polygon Market Data
**Endpoint:** `POST /webhook/market-data`
**Body Format:** `{"tool": "<TOOL_NAME>", "ticker": "<TICKER>"}` 

**Available Tools:**
- `get_market_data`: Returns OHLC, floor pivots, 3-timeframe technicals (MAs, RSI, MACD), and Support/Resistance structure.
- `get_news`: Returns 5 recent articles with AI sentiment.
- `get_ticker_details`: Returns company fundamentals.

**Execution Rule:** Use your native fetch or curl capabilities to hit these endpoints. Do not hallucinate the data. If the endpoint fails, return the exact HTTP error code.