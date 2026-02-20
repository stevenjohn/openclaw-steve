---
name: github-pm
description: GitHub project management via CLI. Create/update/comment on issues, manage labels, track tasks in Projects kanban. Load when discussing todos, project management, or task tracking.
---

# GitHub Project Management

## Two Repos — Pick the Right One

### `stevenjohn/openclaw-ops` → "OpenClaw Ops" board
**Use for:** AI system work — skills, infrastructure, n8n endpoints, data pipelines, Boss Protocol, OpenClaw config, protocol changes.

Labels: `skill`, `trading-rules`, `infrastructure`, `data`, `hedging`, `crypto`, `options`, `urgent`

### `stevenjohn/trade_ops` → "Portfolio/Investment Tasks" board
**Use for:** Investing/trading decisions — asset grades, entry zones, bucket allocation, position plans, trim plans, trade decisions, TSLA/MSTR/crypto actions.

Labels: `B1`, `B2`, `B3`, `portfolio`, `urgent`

**Decision rule:** Is this about the AI system? → `openclaw-ops`. Is this about what to buy/sell/grade? → `trade_ops`.

---

## Project Columns (both boards)
- **Todo** - Not started
- **In Progress** - Actively working
- **Done** - Completed

---

## Common Operations

### Create Issue
```bash
# System/AI task
gh issue create --repo stevenjohn/openclaw-ops \
  --title "Task title" --body "Description" --label "skill"

# Trading/investment task
gh issue create --repo stevenjohn/trade_ops \
  --title "Task title" --body "Description" --label "B2,urgent"
```

### Comment, Edit, Close
```bash
gh issue comment N --repo REPO --body "Update"
gh issue edit N --repo REPO --add-label "urgent"
gh issue close N --repo REPO --comment "Completed: summary"
```

### List Issues
```bash
gh issue list --repo stevenjohn/openclaw-ops --state open
gh issue list --repo stevenjohn/trade_ops --state open
gh issue list --repo stevenjohn/trade_ops --label "urgent" --state open
```

---

## Best Practices
- **Titles**: Concise, action-oriented
- **Body**: Context, what decision is needed, how to action it (commands if relevant)
- **Checklists**: Use `- [ ]` for multi-step tasks
- **Labels**: 1-2 per issue, don't over-label
- **Urgent**: True blockers or time-sensitive only

## Notes
- All issues show Steve (stevenjohn) as creator — uses his auth
- Project board API requires extra OAuth scope — issues won't auto-add to board; Steve adds manually from issue sidebar
- Memory files (MEMORY.md, memory/) are gitignored — never try to commit them
- After any change to `openclaw-ops` tracked files → `bash scripts/auto-commit.sh "msg"`
