# Investment Journal

Strategic insights, analyst views, and standing orders via n8n endpoint.

## Authentication

**All requests require:**
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`

**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## 📚 Get Investment Journal

**Endpoint:** `POST /webhook/get-investment-journal`

Retrieves strategic insights, analyst views (e.g., Bob Loukas), and the Fund Manager's (Steve) standing orders. **Use this to check for "Master Plan" alignment or resolve conflicts** (e.g., Green metrics vs Bearish analyst).

**Input:**
```json
{"author": "Steve Walker"}
{"topic": "BTC"}
{"topic": "Bucket 1"}
{"sentiment": "Defensive"}
```

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| author | string | No | Filter by author (e.g., "Steve Walker", "Bob Loukas", "James (IA)", "CTL", "Peter Brandt") |
| topic | string | No | Filter by topic (e.g., "BTC", "TSLA", "Bucket 1", "SPY") |
| sentiment | string | No | Filter by sentiment (e.g., "Defensive", "Bullish", "Bearish", "Caution") |

**Defaults:** Looks back 60 days

**Returns:**
- **result_count:** Total entries matching filter
- **journal_entries:** Array of entries with:
  - entry_date
  - author
  - asset_class (e.g., Crypto, Equities, Index)
  - ticker (symbol)
  - sentiment (Bullish/Bearish/Caution/Review/Trim)
  - time_horizon (e.g., "Short-term", "3-6 months", "Long-term")
  - core_message (strategic insight/analyst view)
  - action_plan (specific next steps)

**Use for:**
- "What's Steve's view on BTC?"
- "What did Bob Loukas say recently?"
- "Any standing orders?"
- "Show me defensive journal entries"
- "Check Master Plan alignment on TSLA"
- "What's the analyst consensus on crypto?"

**Example response structure:**
```json
{
  "result_count": 26,
  "journal_entries": [
    {
      "entry_date": "2026-02-15",
      "author": "Bob Loukas",
      "asset_class": "Crypto",
      "ticker": "BTC",
      "sentiment": "Bearish",
      "time_horizon": "Intermediate-term",
      "core_message": "Bitcoin is in a confirmed 4-year cycle decline...",
      "action_plan": "Avoid aggressive long exposure. Consider reducing..."
    }
  ]
}
```

---

---

## ✍️ Write Journal Entry

**Endpoint:** `POST /webhook/journal-write`

Writes a journal entry to the investment_journal table for AI conversation handoffs. **Use this at the end of any substantive conversation about an asset** to preserve context for future sessions.

**Input:**
```json
{
  "ticker": "PLTR",
  "core_message": "## Context\nCore B2 position. 400 shares (~$59K, 4% NAV).\n\n## Current Trades\n- Stock: 400 shares, hedged 50% with 160P x2\n- Options: 150/135 BPS (ITM, Mar expiry)\n\n## Decision Made\nHOLD 150/135 BPS through earnings.\n\n## Triggers\n- Reassess: Weekly close below $145",
  "sentiment": "Bullish",
  "time_horizon": "Short-term",
  "action_plan": "Reassess if weekly close below $145. Next event: Earnings Feb 3 AMC.",
  "asset_class": "Equities"
}
```

**Required Fields:**
| Field | Type | Description |
|-------|------|-------------|
| ticker | string | Stock/asset symbol (e.g., "PLTR", "BTC", "SPY") |
| core_message | string | Markdown summary including context, trades, discussion, decisions, triggers |

**Optional Fields (with defaults):**
| Field | Type | Options | Default |
|-------|------|---------|---------|
| sentiment | string | Bullish / Bearish / Neutral / Review / Income / Alert | Neutral |
| time_horizon | string | Short-term / Medium-term / Long-term | Medium-term |
| action_plan | string | Specific next steps or triggers to watch | (none) |
| author | string | Who created the entry | AI |
| asset_class | string | Equities / Crypto / Options / ETF | Equities |
| source_type | string | Entry source | Conversation |

**Core Message Structure (Recommended):**
```markdown
## Context
[Position size, NAV %, thesis]

## Current Trades
[Stock positions, option positions, hedges]

## What We Discussed
[Key points from conversation]

## Decision Made
[Action taken]

## Triggers
[What to watch for, reassessment conditions]
```

**Returns:** Success confirmation with entry ID

**Use for:**
- End-of-conversation handoff to future sessions
- Preserving context after trade decisions
- Documenting strategic discussions
- Setting up triggers for reassessment

**Example use case:**
After discussing PLTR earnings decision, write an entry documenting:
- Current position (400 shares, hedges)
- Decision (HOLD BPS through earnings)
- Trigger (Reassess if weekly close below $145)

This allows future sessions to quickly understand the context without re-reading entire conversation history.

---

## Quick Reference

| Endpoint | Method | Purpose |
|----------|--------|---------|
| /webhook/get-investment-journal | POST | Search strategic notes by author/topic/sentiment |
| /webhook/journal-write | POST | Write context handoff for future sessions |
