---
name: crypto-trading
description: Crypto-specific trading rules, sandbox protocols, and position management. Load when discussing BTC, ETH, on-chain holdings, exchange trades, or crypto allocation.
---

# Crypto Trading Engine

## Sandbox Rules
- **ByBit / OKX** = "Sandbox" accounts for speculation
- Sandbox balance > **$50,000** → **Red Flag** → Mandate Sweep to Vault (SafePal/Trezor)
- Sandbox = isolated margin only, never cross-margin on full account

## Leverage Limits
- Crypto leverage > **1× net long** → Red Flag
- Exception: Sandbox accounts with **isolated margin + hard stop** may use up to **10×**
- Short futures in sandbox = "Strategic Speculation" (not hedges) IF hard stop present

## Concentration
- Single crypto > **50%** of total crypto value → **Amber Flag**
- BTC cycle proxies (IBIT, MSTR, COIN) count as correlated BTC exposure

## Position Management
- Core crypto holdings (BTC/ETH) in cold storage (SafePal/Trezor)
- Trading positions only in exchange accounts
- Regular sweep: profits above threshold → vault

## Areas to Develop (Ongoing)
- Entry/exit frameworks for crypto swing trades
- DCA protocols for accumulation phases
- On-chain analytics integration
- Cycle-based allocation adjustments

_This skill will be refined as Steve and I develop crypto-specific trading rules over time._
