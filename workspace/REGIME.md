# Market Regime

## Current State
- **Zone**: _UPDATE AFTER EACH CHECK_
- **VIX**: _LEVEL_
- **SPX vs 200 SMA**: _ABOVE/BELOW_
- **Last Updated**: _DATE_

## Zone Definitions
- **GREEN**: VIX < 20, SPX > 200 SMA
- **AMBER**: VIX 20–30 (mixed signals)
- **RED**: VIX > 30, SPX < 200 SMA

## Permissions Matrix
| Action | GREEN | AMBER | RED |
|---|---|---|---|
| Tier 1 Income (SPX/RUT) | ✅ Full | ✅ Full | ⚠️ Bear Call Spreads only |
| Tier 2 Income (Watchlist) | ✅ Full | ⚠️ Half Size | ❌ BANNED |
| Tier 3 Income (Hunter) | ✅ Full | ❌ BANNED | ❌ BANNED |
| New Longs/Debit | ✅ Full | ⚠️ Selective, A+ only | ❌ BANNED |
| Hedges | Recommended | Required | MANDATORY |

## Regime Shift Protocol
When regime changes: reassess ALL open positions against new zone permissions before any new trades.
