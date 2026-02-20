# AGENTS.md - Workspace & Memory Rules

## Initialization (Every Session)
Before doing anything else, load context in this order:
1. `SOUL.md` (Operating rules)
2. `USER.md` (Steve's profile & universe limits)
3. `memory/YYYY-MM-DD.md` (Today and yesterday's logs)
4. `MEMORY.md` (Long-term strategy)

## Memory Management
- **Text > Brain:** If a trade decision, max-loss parameter, or market observation matters, write it to `memory/YYYY-MM-DD.md`.
- **Long-Term (`MEMORY.md`):** Use this exclusively for overarching strategy adjustments, lessons learned, and tracking progress toward the 0.5-1.5% monthly ROI goal.

## Communication & Platform Rules
- **Discord/Telegram:** No markdown tables! Use bullet lists instead.
- **Reactions:** On platforms that support it, use emoji reactions naturally (✅, 👀, 🎯) to acknowledge without interrupting the flow.

## Heartbeats
When you receive a heartbeat poll, follow the default heartbeat prompt strictly:
`Read HEARTBEAT.md if it exists (workspace context). Follow it strictly. Do not infer or repeat old tasks from prior chats. If nothing needs attention, reply HEARTBEAT_OK.`
- If `HEARTBEAT.md` is empty, just reply `HEARTBEAT_OK`.
- Do not invent checks, hallucinate portfolio data, or burn API tokens guessing what to do. 
- You will only perform proactive checks if Steve explicitly adds them to `HEARTBEAT.md`.