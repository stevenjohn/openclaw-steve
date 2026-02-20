# Workflow Shortcuts

Quick commands for common workflows. Recognize these patterns and execute without asking.

---

## /journal

**Trigger:** User says "/journal" or "journal this" or "journal what we agreed"

**Action:**
1. Review the last 5-10 messages for key decisions, agreements, plans
2. Identify:
   - What was decided
   - Why (rationale/context)
   - Action items (immediate, deferred, conditional)
   - Key principles or constraints
3. Write structured summary to `memory/YYYY-MM-DD.md`
4. Confirm what was documented

**Format for memory file:**
```markdown
## [Topic/Decision Name] (Date)

**Context:**
- Brief background

**AGREED DECISION:**
- Clear statement of what was decided

**Rationale:**
1. Key reason 1
2. Key reason 2

**DEFERRED/APPROVED Actions:**
- ❌ Don't do X (reason)
- ✅ Do Y (timing/conditions)
- ⏸️ Wait for Z

**Trigger Conditions:**
- Act when [condition]

**Key Principle:**
One-line takeaway
```

**Respond with:** "✅ Journaled to memory/YYYY-MM-DD.md: [1-line summary]"

---

## /tv

**Trigger:** User says "/tv" or "give me a TradingView summary"

**Action:**
1. Extract the core trading plan from recent conversation (last 2-3 messages)
2. Distill into 300-400 character summary
3. Focus on: Symbol, setup, action, reasoning, conditions
4. Format as plain text wrapped in code block for easy copy/paste

**Format:**
```
[SYMBOL] [Strategy/Action]
Entry: [condition/level]
Target: [goal]
Stop/Risk: [management rule]
Rationale: [1-2 sentence why]
```

**Constraints:**
- Max 400 characters
- Plain text (no markdown formatting inside block)
- Actionable and concise
- Easy to paste into TradingView chart notes

**Example output:**
```
RUT 2350/2450 BPS - WAIT
Entry: Wait for bounce to 2650+ or VIX < 18
Target: 50% TP, 42 DTE
Risk: Pullback may not be done, small caps leading weakness
Plan: Let RUT show support hold at 2600 before entering. Patience > FOMO in Amber zone.
```

**Respond with:** Code block only (no extra text before/after)

---

## /grade

**Trigger:** User says "/grade" followed by symbol and grade (and optionally entry zone / invalidation)

**Format Steve sends:**
```
/grade NVDA 2
/grade NVDA 2 entry 115-140 inv 100
/grade NVDA 2 entry 115-140
```

**Action:**
1. Parse: symbol, grade (1-5), optional entry_zone_low/high, optional invalidation_price
2. Validate: grade 1-5, symbol uppercase
3. Call instrument-update immediately — no confirmation needed
4. If grade=1 or 2 AND no entry zone set → note it: "Grade 2 set. No entry zone yet — add one when you know the levels."
5. If grade=5 → also flag: "Grade 5 — should this be deactivated from watchlist?"

**Grade Scale:**
- 1: Screaming Buy — Buy Now
- 2: Accumulate — Buy on Dips
- 3: Hold — Do Nothing
- 4: Watch — Keep an Eye
- 5: Ignore/Sell — Sell or Remove

**Batch format** (for triage sessions):
```
/grade TSLA 3 NVDA 2 TSM 3 AVGO 2
```
Parse multiple symbols in one message and batch-update all.

**When presenting assets for grading**, ALWAYS render a copy-paste list in this format — one per line, colon + space so Steve can fill in inline:

```
VST: 
MP: 
FCX: 

1: Screaming Buy — Buy Now
2: Accumulate — Buy on Dips
3: Hold — Do Nothing
4: Watch — Keep an Eye
5: Ignore/Sell — Sell or Remove
```

**Respond with:** Confirmation of what was updated, one line per asset. Flag any 1s/2s missing entry zones.

---

## Usage Notes

- `/journal` = long-term memory (comprehensive, structured)
- `/tv` = quick reference (concise, actionable, chart-ready)
- `/grade` = instant DB update for asset grades and entry zones

All execute automatically when triggered - no confirmation needed.
