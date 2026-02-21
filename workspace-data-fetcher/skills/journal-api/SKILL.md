---
name: journal-api
description: Investment journal read and write endpoints.
---

# Journal API

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoints

### Read Journal Entries
```
POST /webhook/get-investment-journal
```

Search strategic insights, analyst views, and standing orders. Default lookback: 60 days.

**Parameters (all optional):**
| Parameter | Type | Description |
|-----------|------|-------------|
| author | string | Filter by author (e.g., "Steve Walker", "Bob Loukas", "James (IA)", "CTL", "Peter Brandt") |
| topic | string | Filter by topic (e.g., "BTC", "TSLA", "Bucket 1", "SPY") |
| sentiment | string | Filter by sentiment (e.g., "Defensive", "Bullish", "Bearish", "Caution") |

**Examples:**
```json
{"author": "Steve Walker"}
{"topic": "BTC"}
{"sentiment": "Defensive"}
```

**Returns:** `result_count` + array of `journal_entries` with: entry_date, author, asset_class, ticker, sentiment, time_horizon, core_message, action_plan.

### Write Journal Entry
```
POST /webhook/journal-write
```

**Required fields:**
| Field | Type | Description |
|-------|------|-------------|
| ticker | string | Stock/asset symbol |
| core_message | string | Markdown summary (context, trades, decisions, triggers) |

**Optional fields:**
| Field | Type | Options | Default |
|-------|------|---------|---------|
| sentiment | string | Bullish / Bearish / Neutral / Review / Income / Alert | Neutral |
| time_horizon | string | Short-term / Medium-term / Long-term | Medium-term |
| action_plan | string | Specific next steps or triggers | (none) |
| author | string | Who created the entry | AI |
| asset_class | string | Equities / Crypto / Options / ETF | Equities |
| source_type | string | Entry source | Conversation |

**Returns:** Success confirmation with entry ID.
