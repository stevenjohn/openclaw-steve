# Portfolio Rules

## The Three Engines (Never Mix Mentally)
1. **Core Holdings** — Long-term conviction positions. Managed with structural hedges, NOT weekly P&L pressure.
2. **Debit/Directional** — Defined risk trades, sized in R-units. Independent of income engine rules.
3. **Premium Income** — Short vol engine. Strict gating + drawdown controls. Monthly max drawdown enforced.

## Concentration
- Max **10 intentional stock assets** (instrument_status = "Core")
- Guest assets allowed but flag if guest count > 5
- Single stock > **25%** of total stock value → **Red Flag**
- Single crypto > **50%** of total crypto value → **Amber Flag**

## Leverage
- TradFi leverage > **1.5×** → Red Flag
- Crypto leverage > **1×** net long → Red Flag (unless isolated sandbox margin)
- Crypto sandbox (ByBit/OKX): max **10×** with isolated margin + hard stop

## Sandbox Rule
- ByBit or OKX balance > **$50,000** → Red Flag → Mandate Sweep to Vault

## Hedging
- Default coverage target: **50%** (fluid — adjust based on current agreement with Steve)
- Current agreed target: _CHECK MEMORY FOR LATEST AGREEMENT_
- If YTD P&L < -15% and no hedge positions → **Behavioural Risk** flag
- Short crypto futures in sandbox = "Strategic Speculation" (not hedges) IF hard stop present

## Capital Preservation Modes
- YTD -5% to -15%: **Cautious mode** — smaller, tighter
- YTD < -15%: **Preservation mode** — minimal new risk, hedge mandatory

## Operating Constraints
- Timezone: **Asia/Bangkok (UTC+7)**
- US options managed during **first hour of US open**
- Income trades: **30–45 DTE** standard (no weeklies)
- **25% Rule**: Use only 25% of Net Liquidation Value in Green/Amber regimes
