---
name: things
description: Read and manage Steve's Things 3 task manager — projects, tasks, headings, and completion. All operations go via the things-fetcher sub-agent.
---

# Things Task Manager

You have access to Steve's personal task manager (Things 3) via the `things-fetcher` sub-agent.

## Critical Rules

- You do NOT call the Things API directly — you have no exec or curl access
- You MUST use `sessions_spawn things-fetcher` for all Things operations
- ALWAYS read the project structure before creating tasks under headings (heading UUIDs are required)
- NEVER guess or fabricate UUIDs — always fetch them first
- Completing or trashing tasks is irreversible — confirm with Steve before bulk operations

---

## When to Use Things

Use this skill when Steve asks you to:
- Review his task list or project status
- Capture decisions, actions, or follow-ups from a session
- Mark work as done
- Organise tasks under headings within a project
- Create new projects for new initiatives

---

## Spawning the Things Fetcher

```
/sessions_spawn things-fetcher
```

Then give it a plain-English instruction. It knows all the API endpoints and will return results as Markdown.

---

## Available Operations

### READ

**List all projects**
> "Fetch all projects"

Returns: project names + UUIDs

**Get tasks in a project** (including under headings)
> "Fetch project {UUID}"

Returns: all tasks with heading groupings, notes, schedule dates

**Get today's tasks**
> "Fetch today's tasks"

**Get inbox**
> "Fetch inbox"

---

### CREATE

**Create a task in a project**
> "Create task 'Review NVDA position' in project {UUID}"

Optional fields: note, when (today/anytime/someday), deadline (YYYY-MM-DD), scheduled (YYYY-MM-DD)

**Create a task under a heading**

You MUST fetch the project first to get the heading UUID, then:
> "Create task 'Review NVDA position' under heading {HEADING_UUID} in project {PROJECT_UUID}"

**Create a new project**
> "Create project 'Q2 Options Review'"

**Create a heading inside a project**
> "Create heading 'New Positions' in project {UUID}"

Returns the heading UUID — use it immediately to add tasks underneath.

**Batch create multiple tasks** (efficient — one HTTP call)
> "Batch create: task 'Task A' in project X, task 'Task B' under heading Y, complete task Z"

---

### UPDATE

**Update a task's note**
> "Update task {UUID} note to: {new note text}"

**Move a task to today**
> "Move task {UUID} to today"

**Edit task title or schedule**
> "Edit task {UUID} title to '{new title}', schedule anytime"

---

### COMPLETE / TRASH

**Complete a task**
> "Complete task {UUID}"

**Trash a task** (recoverable from Things trash)
> "Trash task {UUID}"

---

## Typical Session Workflow

When capturing actions from a trading session:

1. Spawn things-fetcher
2. Fetch the Portfolio project to see current structure and heading UUIDs
3. Batch create new tasks under the appropriate headings
4. Complete any tasks that were resolved in the session
5. Report back a summary of changes made

Example prompt to things-fetcher:
> "Fetch project 25W8tHzexBiztscMyp8S39, then batch create: 'Review PLTR stop loss' under heading Tfi7bY4toE3pR6GowCJWTc (Portfolio Actions), 'Monthly Banktivity update' under heading FNgaQgcg6SJ6oyBCicFN4q (Recurring Activities). Then complete task abc123."

---

## Known Project UUIDs

| Project | UUID |
|---------|------|
| Portfolio | `25W8tHzexBiztscMyp8S39` |

> Note: fetch `/projects` to get current full list — Steve adds projects over time.

## Known Heading UUIDs (Portfolio Project)

| Heading | UUID |
|---------|------|
| Portfolio Actions | `Tfi7bY4toE3pR6GowCJWTc` |
| Recurring Activities | `FNgaQgcg6SJ6oyBCicFN4q` |
| Positions | `6DaYPUUTL58jcYTsu4M8KH` |

> Always verify headings are current by fetching the project first — headings can be added/removed.

---

## If the Sub-Agent Fails

Report the failure to Steve. Do NOT attempt to:
- Call curl or exec directly
- Guess task UUIDs
- Fabricate a response