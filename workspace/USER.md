# USER.md - Who Steve Is

**Name:** Steve
**Location:** Bangkok, Thailand (UTC+7)
**Role:** Runs a private trading fund (~$1.6M AUM)

## Working Style
- Pings can be anything: quick sanity check, deep strategy session, thinking out loud
- On uncertainty: **stop and ask** — don't flag-and-proceed
- Morning person — brain is sharp early
- Direct, analytical — wants honest pushback, no flattery

## Trading Philosophy

### Primary Edge: Risk Management Architecture
- Multi-layered hedging (VIX calls, protective puts, collars)
- Systematic position sizing via bucket framework (B0-B3)
- Real-time leverage monitoring across 7 accounts with hard limits
- Options income as "volatility tax" — harvest premium systematically

### Secondary Edge: Conviction + Patience
- Concentrated thesis investing (AI/semis, crypto)
- Structural over cyclical — multi-decade demand drivers
- Waits for setups, willing to hold cash

### Explicit Weaknesses (Self-Identified)
- **Timing** — hence the automation focus
- Not a scalper or flow trader
- Retail participant, no information edge

### The System
Options income funds drawdown protection + hedged concentration captures regime shifts. Edge is *surviving to compound*, not hitting home runs.

## Technical Infrastructure
- n8n automation workflows (separate DigitalOcean droplet)
- PostgreSQL database for trading data
- MCP integrations between Claude and n8n
- Multiple accounts: SafePal, Trezor, ByBit, OKX, ToS

## Current Focus: The Boss Protocol

AI-enforced trading discipline system acting as "Fund Manager oversight."

**What it does:**
- Evaluates trades against hard rules (concentration limits, bucket targets, options protocols, market regime gates)
- 7-section rule hierarchy
- MCP integration for real-time data, positions, options analytics, investment journal

**Current state:** Semi-automated "consultant" mode — Steve brings trades for validation, rules are systematic but invocation is manual.

**The gap:** Needs to transition from advisory → mandatory checkpoint. Potential n8n workflow requiring Boss approval before executing certain trades (>$5k new positions, Tier 2/3 spreads, bucket violations).

## What Steve Needs From Me
- Strategic architecture advice
- Trading analysis and portfolio oversight
- Systems thinking on infrastructure decisions
- Someone who challenges assumptions
- Help closing the Boss Protocol gap
