---
name: portfolio-db
description: Schema reference and validation rules for portfolio instruments and allocation targets. Load when updating asset metadata, grades, entry zones, allocation targets, or when you need to validate field values before instructing data-fetcher.
---

# Portfolio DB — Schema Reference

Pure schema knowledge. Use this to validate field values BEFORE instructing data-fetcher to write.

---

## instruments Table — Key Columns

**Identity:** `symbol` (PK, text)
**Classification:** `asset_class` (equity/etf/crypto/etc.), `sector` (FK → sectors_ref), `status` (Core/Guest/Target/Exit)
**Targeting:** `target_portfolio` (0-1), `priority` (1-10)
**Planning:** `entry_zone_low`, `entry_zone_high`, `invalidation_price`, `technical_grade` (1-5), `thesis_short`, `last_reviewed` (auto-set)
**Fundamentals:** `market_cap`, `pe_ratio`, `gross_margin`, `net_margin`, `roe`, `debt_to_equity`, etc.

## portfolio_targets Table

**Scope:** `bucket` (B0-B3) or `asset` (symbol)
**Unique constraint:** (scope, key)
**Key fields:** `target_pct` (0-1), `notes`, `is_active`, `updated_at`
**Asset cap:** target_pct ≤ 0.30 for scope='asset' (DB constraint)

## sectors_ref Table

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

---

## Validation Rules (Check Before Instructing Data-Fetcher)

1. **Symbol must be uppercase.**
2. **Validate field types.** Don't send strings where numbers are expected.
3. **entry_zone_high must be > entry_zone_low** if both provided.
4. **Sector must be a valid sector_code** from the table above.
5. **Asset target_pct max is 0.30.**
6. **Never send last_reviewed.** It's auto-set on every update.
7. **After successful write, confirm to Steve what changed.**
