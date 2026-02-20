---
name: portfolio-db
description: CRUD operations for portfolio instruments and allocation targets. Schema-aware write layer for instruments, portfolio_targets, and sectors_ref. Load when updating asset metadata, grades, entry zones, allocation targets, or reviewing DB schema.
---

# Portfolio DB — Write Layer

Pure data access. No analysis, no opinions. Knows the schema and validates before writing.

**Used by:** `portfolio-planning` (primary consumer), direct requests from Steve.
**Read endpoints live in:** `portfolio` skill (stocks-positions, accounts-summary, etc.)

---

## Authentication

All requests require:
- `Content-Type: application/json`
- `X-API-Key: ${CLAUDE_ENDPOINTS_API_KEY}`

**Base URL:** `https://beep.stevewalker.net/webhook/`

---

## Instrument Update

**Endpoint:** `POST /webhook/instrument-update`

Partial update of instrument metadata. Only provided fields are changed. `last_reviewed` is auto-set to NOW() on every call — never send it manually.

### Request
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
    "thesis_short": "AI capex secular winner, accumulate at 21 SMA tests",
    "sector": "chips_semi_conductors"
  }
}
```

Only include fields being changed. Omitted fields keep their existing values.

### Updatable Fields

| Field | Type | Constraints | Purpose |
|-------|------|-------------|---------|
| priority | smallint | 1-10 | Asset ranking within bucket (1 = highest) |
| status | text | Core, Guest, Target, Exit | Role in portfolio |
| target_portfolio | numeric(8,4) | 0-1 | Target weight in portfolio (0.12 = 12%) |
| technical_grade | smallint | 1-5 | Current setup quality (5 = perfect, 1 = avoid) |
| entry_zone_low | numeric(18,6) | > 0 | Lower bound of accumulation zone |
| entry_zone_high | numeric(18,6) | > entry_zone_low | Upper bound — stop adding above this |
| invalidation_price | numeric(18,6) | > 0 | Thesis breaks at this price — triggers review/exit |
| thesis_short | text | max 500 chars | One-liner thesis summary |
| sector | text | must exist in sectors_ref | Sector classification (determines bucket) |

### Response (Success)
```json
[{
  "symbol": "NVDA",
  "priority": 2,
  "status": "Core",
  "target_portfolio": "0.1200",
  "technical_grade": 4,
  "entry_zone_low": "115.000000",
  "entry_zone_high": "140.000000",
  "invalidation_price": "100.000000",
  "thesis_short": "AI capex secular winner, accumulate at 21 SMA tests",
  "sector": "chips_semi_conductors",
  "last_reviewed": "2026-02-18T07:00:00.000Z"
}]
```

### Error Responses
- Missing symbol → `{"error": "Missing required field: symbol"}`
- No valid fields → `{"error": "No valid update fields. Allowed: ..."}`
- Grade out of range → `{"error": "technical_grade must be 1-5"}`
- Bad status → `{"error": "status must be: Core, Guest, Target, Exit"}`
- Bad sector (FK) → `{"message": "violates foreign key constraint..."}`
- Symbol not found → `{"error": "Symbol not found — no rows updated"}`

### Backup
All updates are logged to `instruments_backup` table automatically via DB trigger. The pre-update row is preserved before changes are applied.

---

## Target Update

**Endpoint:** `POST /webhook/target-update`

Upsert (create or update) allocation targets at bucket or asset level.

### Request — Bucket Target
```json
{
  "scope": "bucket",
  "key": "B3",
  "target_pct": 0.20,
  "notes": "Reduced pending B3 thesis development"
}
```

### Request — Asset Target
```json
{
  "scope": "asset",
  "key": "NVDA",
  "target_pct": 0.12,
  "notes": "B2 core - AI capex"
}
```

### Fields

| Field | Type | Required | Constraints |
|-------|------|----------|-------------|
| scope | text | Yes | `bucket` or `asset` |
| key | text | Yes | B0/B1/B2/B3 for bucket, or symbol for asset |
| target_pct | numeric | Yes | 0-1 (asset cap: 0.30 due to DB constraint) |
| notes | text | No | Description / rationale |
| is_active | boolean | No | Default: true. Set false to deactivate. |

### Response (Success)
```json
[{
  "id": "34",
  "scope": "asset",
  "key": "NVDA",
  "target_pct": "0.120000",
  "notes": "B2 core - AI capex",
  "is_active": true,
  "updated_at": "2026-02-18T07:07:08.087Z",
  "action": "created"
}]
```

`action` returns `"created"` for new rows or `"updated"` for existing.

### Error Responses
- Bad scope → `{"error": "scope must be: bucket or asset"}`
- Bad bucket key → `{"error": "bucket key must be: B0, B1, B2, B3"}`
- Asset >30% → `{"error": "asset target_pct cannot exceed 0.30 (30%)"}`
- target_pct out of range → `{"error": "target_pct must be between 0 and 1"}`

---

## Read Endpoints (Reference)

These live in the `portfolio` skill but are listed here for completeness:

| Endpoint | Method | Returns |
|----------|--------|---------|
| /webhook/portfolio-buckets | POST | 4 bucket rows: NAV, current %, target %, gap, action |
| /webhook/portfolio-bucket-detail | POST | Assets in a bucket with values, targets, deviations, planning fields |
| /webhook/portfolio-strategy | GET | Legacy bucket view |
| /webhook/stocks-positions | GET | Stock + LEAP positions with sector breakdown |
| /webhook/accounts-summary | GET | Account balances, equity, leverage |

---

## Schema Reference

### instruments Table — Key Columns

**Identity:** `symbol` (PK, text)
**Classification:** `asset_class` (equity/etf/crypto/etc.), `sector` (FK → sectors_ref), `status` (Core/Guest/Target/Exit)
**Targeting:** `target_portfolio` (0-1), `priority` (1-10)
**Planning (new):** `entry_zone_low`, `entry_zone_high`, `invalidation_price`, `technical_grade` (1-5), `thesis_short`, `last_reviewed`
**Fundamentals:** `market_cap`, `pe_ratio`, `gross_margin`, `net_margin`, `roe`, `debt_to_equity`, etc.

### portfolio_targets Table

**Scope:** `bucket` (B0-B3) or `asset` (symbol)
**Unique constraint:** (scope, key)
**Key fields:** `target_pct` (0-1), `notes`, `is_active`, `updated_at`
**Asset cap:** target_pct ≤ 0.30 for scope='asset' (DB constraint)

### sectors_ref Table (Read-Only Reference)

| Sector Code | Bucket | Display Name |
|-------------|--------|--------------|
| ai | B2 | Ai |
| batteries | B3 | Batteries |
| cash | B0 | Cash |
| chips_semi_conductors | B2 | Semi Conductors |
| commodities | B3 | Commodities |
| crypto | B1 | Crypto |
| cybersecurity | B2 | Cybersecurity |
| data_centres | B2 | Data Centres |
| drones | B2 | Drones |
| energy | B3 | Energy |
| fintech | B2 | Fintech |
| genomics_biotech | B3 | Genomics & Biotech |
| healthcare | B3 | Healthcare |
| index | B3 | Index |
| misc | B3 | Misc |
| networking | B2 | Networking |
| nuclear | B3 | Nuclear |
| quantum | B2 | Quantum |
| rare_earths | B3 | Rare Earths |
| robotics | B2 | Robotics |
| self_driving_cars | B2 | Self-Driving Cars |
| software | B2 | Software |
| space | B2 | Space |
| wearables | B3 | Wearables |

**Bucket summary:** B0 = cash. B1 = crypto. B2 = ai/tech/software/semis/networking/drones/quantum/robotics/space/fintech/cybersecurity/data_centres/self_driving_cars. B3 = everything else (energy/commodities/healthcare/nuclear/rare_earths/batteries/genomics/misc/index/wearables).

---

## Validation Rules (Agent-Side)

Before calling any write endpoint:

1. **Symbol must be uppercase.** The endpoint handles this, but be consistent.
2. **Validate field types before calling.** Don't send strings where numbers are expected.
3. **entry_zone_high must be > entry_zone_low** if both are provided in the same update.
4. **Sector must be a valid sector_code** from the table above. Don't guess — check the list.
5. **Asset target_pct max is 0.30.** The DB enforces this, but catch it early to avoid a cryptic FK error.
6. **Never send last_reviewed.** It's auto-set by the endpoint.
7. **After successful write, confirm to Steve what changed.** Don't silently update.

---

## Quick Reference

| Action | Endpoint | Key Param |
|--------|----------|-----------|
| Update asset metadata | instrument-update | `symbol` + `updates: {...}` |
| Set/change allocation target | target-update | `scope` + `key` + `target_pct` |
| Deactivate a target | target-update | `is_active: false` |
| Read bucket overview | portfolio-buckets | `{}` |
| Read bucket detail | portfolio-bucket-detail | `{"bucket": "B2"}` |
