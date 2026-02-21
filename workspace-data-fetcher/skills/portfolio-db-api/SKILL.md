---
name: portfolio-db-api
description: Portfolio instrument and allocation target write endpoints.
---

# Portfolio DB API (Write Layer)

## Authentication
- Header: `Content-Type: application/json`
- Header: `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`
- Base URL: `https://beep.stevewalker.net/webhook/`

## Endpoints

### Instrument Update
```
POST /webhook/instrument-update
```

Partial update — only provided fields are changed. `last_reviewed` is auto-set to NOW().

**Request:**
```json
{
  "symbol": "NVDA",
  "updates": {
    "priority": 2,
    "status": "Core",
    "target_portfolio": 0.12,
    "technical_grade": 4,
    "entry_zone_low": 115.00,
    "entry_zone_high": 140.00,
    "invalidation_price": 100.00,
    "thesis_short": "AI capex secular winner",
    "sector": "chips_semi_conductors"
  }
}
```

**Updatable fields:**
| Field | Type | Constraints |
|-------|------|-------------|
| priority | smallint | 1-10 |
| status | text | Core, Guest, Target, Exit |
| target_portfolio | numeric | 0-1 |
| technical_grade | smallint | 1-5 |
| entry_zone_low | numeric | > 0 |
| entry_zone_high | numeric | > entry_zone_low |
| invalidation_price | numeric | > 0 |
| thesis_short | text | max 500 chars |
| sector | text | must exist in sectors_ref (see below) |

**Valid sector codes:** ai, batteries, cash, chips_semi_conductors, commodities, crypto, cybersecurity, data_centres, drones, energy, fintech, genomics_biotech, healthcare, index, misc, networking, nuclear, quantum, rare_earths, robotics, self_driving_cars, software, space, wearables.

**Sector → Bucket mapping:** B0=cash. B1=crypto. B2=ai, chips_semi_conductors, cybersecurity, data_centres, drones, fintech, networking, quantum, robotics, self_driving_cars, software, space. B3=everything else.

### Target Update
```
POST /webhook/target-update
```

Upsert (create or update) allocation targets.

**Bucket target:**
```json
{"scope": "bucket", "key": "B3", "target_pct": 0.20, "notes": "Reduced pending thesis"}
```

**Asset target:**
```json
{"scope": "asset", "key": "NVDA", "target_pct": 0.12, "notes": "B2 core - AI capex"}
```

**Fields:**
| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| scope | text | Yes | `bucket` or `asset` |
| key | text | Yes | B0/B1/B2/B3 for bucket, or symbol for asset |
| target_pct | numeric | Yes | 0-1 (asset cap: 0.30) |
| notes | text | No | Description |
| is_active | boolean | No | Default: true |

**Returns:** Confirmation with `action: "created"` or `"updated"`.
