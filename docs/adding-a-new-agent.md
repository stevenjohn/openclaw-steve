# Adding and Configuring OpenClaw Agents

## Prerequisites
- SSH access to `openclaw-v1`
- MacBook repo pulled and up to date (`git pull origin main`)

---

## Quick Reference — Valid `agents.list[]` Keys

These are the ONLY keys accepted inside an `agents.list[]` entry. **Any other key will crash the gateway.**

| Key | Type | Purpose |
|-----|------|---------|
| `id` | string | **Required.** Unique agent identifier |
| `name` | string | Display name |
| `default` | boolean | Mark as default agent (first `true` wins) |
| `workspace` | string | Absolute path to agent workspace |
| `agentDir` | string | Absolute path to agent runtime directory |
| `model` | string or object | Model override: `"provider/model"` or `{ primary, fallbacks }` |
| `skills` | string[] | Skill names to load from workspace `skills/` |
| `subagents` | object | Sub-agent config: `{ allowAgents, model, maxConcurrent, ... }` |
| `tools` | object | Tool restrictions: `{ allow, deny, sandbox, elevated }` |
| `sandbox` | object | Sandbox config: `{ mode, scope, workspaceAccess }` |
| `identity` | object | `{ name, theme, emoji, avatar }` |
| `groupChat` | object | `{ mentionPatterns }` |
| `heartbeat` | object | `{ every }` — set `{ "enabled": false }` to disable |

### Keys that DO NOT exist in `agents.list[]` (will crash gateway)

| Invalid Key | Where It Actually Goes |
|-------------|----------------------|
| ~~`systemPrompt`~~ | Use workspace `AGENTS.md` / `SOUL.md` files instead |
| ~~`channels`~~ | Use top-level `channels` config + `bindings[]` for routing |
| ~~`tools.subagents`~~ | Use global `tools.subagents` (top-level) for sub-agent tool policy |

---

## Quick Reference — Valid `subagents` Keys (inside `agents.list[]`)

```json
"subagents": {
    "allowAgents": ["agent-id-1", "agent-id-2"],  // or ["*"] for any
    "model": "provider/model-id",                  // override sub-agent model
    "maxConcurrent": 8,                            // per-agent concurrency
    "maxSpawnDepth": 1,                            // 1=no nesting, 2=one level
    "maxChildrenPerAgent": 5                       // max active children
}
```

**Critical:** `allowAgents` is the correct key — NOT `allow`.

---

## Quick Reference — Sub-Agent Tool Policy

Sub-agent tool restrictions go at the **global** `tools` level, NOT inside `agents.list[].tools`:

```json
// ✅ CORRECT — global level
{
    "tools": {
        "subagents": {
            "tools": {
                "allow": ["exec", "process", "read"]
            }
        }
    }
}

// ❌ WRONG — inside agent tools (crashes gateway)
{
    "agents": {
        "list": [{
            "tools": {
                "subagents": { ... }  // Unrecognized key!
            }
        }]
    }
}
```

**Warning:** Global `tools.subagents.tools` applies to ALL sub-agents across ALL agents. If your main agent also spawns sub-agents that need broader tools, you'll need to revisit this.

---

## Quick Reference — Model Priority for Sub-Agents

When a sub-agent is spawned, the model is resolved in this order (highest priority first):

1. **`sessions_spawn` tool parameter** — `model` param in the spawn call
2. **`agents.list[].subagents.model`** — on the parent agent
3. **`agents.defaults.subagents.model`** — global default
4. **Caller's model** — inherited from parent (this is the default!)

**Key insight:** If you define `agents.list[].model` on the sub-agent entry itself, it only applies when that agent handles **direct messages** (channels). When spawned as a sub-agent, it inherits the parent's model unless overridden via options 1-3 above.

In practice, the model defined on the parent's `subagents.model` may still be ignored — the most reliable approach is:
- Set `subagents.model` on the parent (belt)
- Set `model` on the sub-agent's `agents.list[]` entry (suspenders)
- Verify via `openclaw status` which model is actually running

---

## Quick Reference — Agent Bindings

Creating a Discord/Telegram/WhatsApp account does NOT automatically route messages to an agent. You need an explicit binding:

```json
"bindings": [
    {
        "agentId": "income-trader",
        "match": {
            "channel": "discord",
            "accountId": "income-trader"
        }
    }
]
```

**Without a binding**, all messages fall back to the default agent (usually `main`), which means your agent-specific tool restrictions are completely bypassed.

The correct `match` key for the channel type is `channel` — NOT `provider`.

---

## Step 1 — Update .gitignore first (one-time, already done)

The `.gitignore` whitelist uses `workspace*/` to track all workspace directories and blacklists `workspace*/.openclaw/` for runtime state. Nothing to do here unless this is a brand new install.

---

## Step 2 — Scaffold the agent on the server

```bash
ssh steve@openclaw-v1
openclaw agents add  \
  --workspace ~/.openclaw/workspace- \
  --non-interactive
```

This does three things:
- Adds the agent entry to `~/.openclaw/openclaw.json`
- Seeds workspace files (SOUL.md, AGENTS.md, IDENTITY.md, USER.md, TOOLS.md, HEARTBEAT.md, BOOTSTRAP.md)
- Initializes a git repo in the workspace (unwanted — remove it next)

---

## Step 3 — Clean up OpenClaw's auto-init

```bash
rm -rf ~/.openclaw/workspace-/.git
rm -rf ~/.openclaw/workspace-/.openclaw
```

---

## Step 4 — Create symlinked skills

Only link the skills this agent actually needs. No extras.

```bash
mkdir -p ~/.openclaw/workspace-/skills
cd ~/.openclaw/workspace-/skills
ln -s /home/steve/.openclaw/workspace/skills/ 
# repeat for each required skill
```

**Warning about skill content:** If a skill contains instructions like endpoint URLs, auth headers, or tool-specific commands, make sure those instructions are appropriate for the agent. If an agent should NOT have direct access to certain endpoints, create a sanitized version of the skill in the agent's own workspace instead of symlinking.

---

## Step 5 — Commit everything from the server repo

```bash
cd ~/.openclaw
git add openclaw.json
git add workspace-/
git commit -m "Add  agent scaffold and workspace files"
git push origin main
```

---

## Step 6 — Verify the deploy

```bash
# Wait a few seconds for webhook to fire, then:
openclaw gateway status
cat /var/log/openclaw-deploy.log
```

---

## Step 7 — Pull on MacBook

```bash
cd ~/Projects/openclaw-steve
git pull origin main
```

---

## Step 8 — Customise workspace files

Edit the workspace files on MacBook to give the agent its identity:

| File | Purpose | Notes |
|------|---------|-------|
| `SOUL.md` | Persona, tone, boundaries, operating principles | **Critical:** Content here bleeds into sub-agent context. Never put tool-specific restrictions here (e.g., "no exec") — sub-agents will inherit and obey them. |
| `AGENTS.md` | Operating instructions, memory rules, session init | This is the primary instruction file loaded every session |
| `IDENTITY.md` | Name, emoji, theme | Display identity |
| `USER.md` | Who the user is, preferences | User context |
| `TOOLS.md` | Tool usage guidance | Local tool notes |
| `HEARTBEAT.md` | Heartbeat checklist | Keep short to limit token burn |
| `BOOTSTRAP.md` | First-run ritual | Delete after first run or leave for ritual |

Then add model config, channel bindings, and tool restrictions to the `agents.list[]` entry in `openclaw.json`.

Commit and push from MacBook:

```bash
git add .
git commit -m "Configure  agent identity and bindings"
git push origin main
```

---

## Step 9 — Post-deploy verification

After every config push:

```bash
# Check gateway started cleanly
openclaw gateway status

# Verify agent config loaded
openclaw config get agents.list --json

# Check channel routing
openclaw channels list --json

# Check bindings
openclaw config get bindings --json

# Check effective tool policy
openclaw sandbox explain --agent 

# Check sessions and model assignment
openclaw status
```

---

## Step 10 — Wipe sessions after config changes

**Always wipe sessions after changing agent config** — especially tool policies, model assignments, or workspace files. Cached session state will replay old context and ignore new config.

```bash
ssh steve@openclaw-v1
rm -rf ~/.openclaw/agents//sessions/
rm -rf ~/.openclaw/agents//memory/
# Also wipe sub-agent sessions if applicable:
rm -rf ~/.openclaw/agents//sessions/
rm -rf ~/.openclaw/agents//memory/
systemctl --user restart openclaw-gateway
```

**Note:** Session directories live at `~/.openclaw/agents/<id>/sessions/`, NOT `~/.openclaw/agents/<id>/agent/sessions/`. The `agent/` subdirectory is for auth and runtime config.

---

## Adding a Sub-Agent (Spawned by Another Agent)

Sub-agents are agents that are spawned by a parent agent via `sessions_spawn`. They need their own workspace, skills, and instructions but are never directly messaged.

### Sub-agent in `agents.list[]`

Sub-agents MUST be defined as full entries in `agents.list[]` to have their own workspace and skills loaded:

```json
{
    "id": "data-fetcher",
    "name": "Data Fetcher",
    "workspace": "/home/steve/.openclaw/workspace-data-fetcher",
    "agentDir": "/home/steve/.openclaw/agents/data-fetcher/agent",
    "model": {
        "primary": "google/gemini-2.5-flash-lite",
        "fallbacks": ["google/gemini-2.5-flash"]
    },
    "skills": ["n8n-webhooks"],
    "tools": {
        "allow": ["exec", "process", "read"]
    }
}
```

### Parent agent sub-agent config

The parent must explicitly allow spawning and optionally override the model:

```json
{
    "id": "income-trader",
    "subagents": {
        "allowAgents": ["data-fetcher"],
        "model": "google/gemini-2.5-flash-lite"
    }
}
```

### Sub-agent workspace setup

The sub-agent workspace needs:

1. **`AGENTS.md`** — focused instructions for the sub-agent's specific job (NOT the default boilerplate)
2. **`skills/<skill-name>/SKILL.md`** — the actual skill files with endpoints, auth, etc.
3. **No** `SOUL.md` with personality/restrictions from the parent — sub-agents inherit parent context at spawn time

### Critical: Context bleed between parent and sub-agent

When a parent spawns a sub-agent, the parent's workspace files (SOUL.md, AGENTS.md) can bleed into the sub-agent's context via the spawn task. This means:

- If parent SOUL.md says "You have NO exec access" → sub-agent thinks exec is forbidden
- If parent SOUL.md says "Never use curl" → sub-agent won't use curl even if it has exec
- If parent SOUL.md says "Never scrape websites" → sub-agent also avoids scraping (good)

**Rule:** Parent workspace files should describe WHAT the parent cannot do, not HOW tools work. Let the sub-agent's own workspace files handle tool-specific instructions.

**Good parent SOUL.md:**
```markdown
## Data Access
You cannot fetch market data yourself.
Spawn the `data-fetcher` sub-agent and describe WHAT data you need.
The data-fetcher has its own tools and instructions.
```

**Bad parent SOUL.md:**
```markdown
## Data Access
You have NO exec, curl, or shell access. Do NOT attempt workarounds.
<!-- Sub-agent reads this and thinks exec/curl are forbidden -->
```

---

## Adding a Discord Bot for a New Agent

### 1. Create the Discord bot
- Go to Discord Developer Portal
- Create a new application and bot
- Enable Message Content Intent
- Generate a bot token
- Invite to your server

### 2. Add token to server `.env`

```bash
ssh steve@openclaw-v1
echo 'DISCORD_BOT_TOKEN_=' >> ~/.openclaw/.env
```

### 3. Add Discord account in `openclaw.json`

```json
"channels": {
    "discord": {
        "accounts": {
            "": {
                "enabled": true,
                "token": "${DISCORD_BOT_TOKEN_}",
                "dmPolicy": "allowlist",
                "allowFrom": ["395896147123765248"],
                "dm": { "enabled": true }
            }
        }
    }
}
```

### 4. Add binding to route messages

```json
"bindings": [
    {
        "agentId": "",
        "match": {
            "channel": "discord",
            "accountId": ""
        }
    }
]
```

### 5. Verify routing

```bash
openclaw channels list --json
openclaw config get bindings --json
```

---

## Tool Policy Reference

### Allow-only whitelist (recommended for restricted agents)

```json
"tools": {
    "allow": ["read", "image", "sessions_spawn"]
}
```

If `tools.allow` is non-empty, everything NOT in the list is blocked. This is safer than deny lists.

### Deny list (for broad access with specific restrictions)

```json
"tools": {
    "deny": ["exec", "write", "browser"]
}
```

### Disabling elevated mode

```json
"tools": {
    "elevated": { "enabled": false }
}
```

### Tool groups

Use `group:*` for convenience:
- `group:openclaw` — all built-in tools
- `group:web` — web_search, web_fetch

### What WON'T work (invalid schemas)

```json
// ❌ All of these crash the gateway
"tools": { "exec": { "enabled": false } }     // "enabled" not a valid key
"tools": { "exec": false }                     // boolean not accepted
"tools": { "exec": { "security": "none" } }   // "none" not a valid option
"tools": { "exec": { "security": "deny" } }   // valid syntax but NOT enforced at runtime
"tools": { "subagents": { ... } }              // inside agents.list[] — invalid location
```

---

## Debugging Commands

```bash
# Gateway status
openclaw gateway status

# Full status with sessions and models
openclaw status

# Deep status with probes
openclaw status --deep

# View agent config
openclaw config get agents.list --json

# View bindings
openclaw config get bindings --json

# View sub-agent tool policy
openclaw config get tools.subagents --json

# View effective sandbox/tool policy for an agent
openclaw sandbox explain --agent 

# Channel status
openclaw channels list --json

# Live logs
journalctl --user -u openclaw-gateway.service -f

# Recent logs
journalctl --user -u openclaw-gateway.service -n 200 --no-pager

# Filter logs for specific agent/model
journalctl --user -u openclaw-gateway.service -n 50 --no-pager | grep -i "xai\|grok\|model\|exec\|curl"

# Read sub-agent session transcript (find latest)
ls -lt ~/.openclaw/agents//sessions/
# Read it (may be .jsonl or .jsonl.deleted.*)
tail -100 ~/.openclaw/agents//sessions/

# Deploy log
cat /var/log/openclaw-deploy.log
```

---

## Post-Deploy Checklist

Run after every `git push`:

- [ ] `openclaw gateway status` — gateway running, no config errors
- [ ] `openclaw status` — correct models assigned per agent/session
- [ ] `openclaw config get agents.list --json` — agent config looks correct
- [ ] `openclaw config get bindings --json` — routing rules in place
- [ ] Sessions wiped if tool/model config changed
- [ ] Test the agent via its channel (Discord DM, Telegram, etc.)

---

## Fix: File Permissions Reset on Deploy

The deploy script (`/opt/openclaw-deploy.sh`) does `git reset --hard` which restores file permissions from git. Add a post-deploy chmod:

```bash
# Add to /opt/openclaw-deploy.sh after the git reset --hard line:
chmod 600 /home/steve/.openclaw/openclaw.json
```

This prevents the `CRITICAL: Config file is world-readable` security warning.

---

## Common Gotchas

### Configuration
- Always remove `.git` and `.openclaw` from new workspaces before committing
- Never add skills via `extraDirs` — symlink only what the agent needs
- `openclaw agents add` writes absolute paths into `openclaw.json` — these are correct for the server
- Channel tokens must be added to `~/.openclaw/.env` on the server and referenced as `${VAR_NAME}`
- The `Both GOOGLE_API_KEY and GEMINI_API_KEY are set` log message fires on every LLM call regardless of provider — it's an env warning, not proof Google is being used

### Sub-agents
- `subagents/` directory files (e.g., `subagents/data-fetcher/agent.json`) are for runtime state tracking only — they are NOT config files and are ignored for model/tool/skill loading
- Sub-agents inherit the parent's model by default — override via `subagents.model` on parent
- Sub-agent tool policy goes at global `tools.subagents.tools`, not inside agent config
- Parent workspace content (SOUL.md) bleeds into sub-agent context — avoid tool-specific restrictions in parent files
- Always wipe both parent AND sub-agent sessions after config changes

### Sessions
- Sessions live at `~/.openclaw/agents/<id>/sessions/`, NOT `~/.openclaw/agents/<id>/agent/sessions/`
- Auto-archived sub-agent transcripts have `.deleted.<timestamp>` suffix
- Cached session context will replay old failures even after config fixes — wipe sessions
- The `agent/` subdirectory under each agent is for auth profiles and runtime config

### Tooling
- `tools.allow` whitelist is safer than `tools.deny` blacklist
- If `tools.allow` is non-empty, everything not listed is blocked
- `tools.elevated.enabled: false` disables elevated escape hatch
- Global `tools.exec.security: "full"` applies to all agents unless overridden

### Models
- Verify actual model in use via `openclaw status` sessions table
- Sub-agent model in `agents.list[].model` only applies to direct messages, not spawned runs
- The `sessions_spawn` model parameter has highest priority (can be set in SOUL.md spawn instructions, but this is discouraged — use config instead)