# Adding a New Agent

## Prerequisites
- SSH access to `openclaw-v1`
- MacBook repo pulled and up to date (`git pull origin main`)

## Step 1 — Update .gitignore first (one-time, already done)
The `.gitignore` whitelist uses `workspace*/` to track all workspace directories
and blacklists `workspace*/.openclaw/` for runtime state. Nothing to do here
unless this is a brand new install.

## Step 2 — Scaffold the agent on the server
```bash
ssh steve@openclaw-v1
openclaw agents add <agent-name> \
  --workspace ~/.openclaw/workspace-<agent-name> \
  --non-interactive
```

This does three things:
- Adds the agent entry to `~/.openclaw/openclaw.json`
- Seeds workspace files (SOUL.md, AGENTS.md, IDENTITY.md, USER.md, TOOLS.md, HEARTBEAT.md, BOOTSTRAP.md)
- Initializes a git repo in the workspace (unwanted — remove it next)

## Step 3 — Clean up openclaw's auto-init
```bash
rm -rf ~/.openclaw/workspace-<agent-name>/.git
rm -rf ~/.openclaw/workspace-<agent-name>/.openclaw
```

## Step 4 — Create symlinked skills
Only link the skills this agent actually needs. No extras.
```bash
mkdir -p ~/.openclaw/workspace-<agent-name>/skills
cd ~/.openclaw/workspace-<agent-name>/skills
ln -s /home/steve/.openclaw/workspace/skills/<skill-name> <skill-name>
# repeat for each required skill
```

## Step 5 — Commit everything from the server repo
```bash
cd ~/.openclaw
git add openclaw.json
git add workspace-<agent-name>/
git commit -m "Add <agent-name> agent scaffold and workspace files"
git push origin main
```

## Step 6 — Verify the deploy
```bash
# Wait a few seconds for webhook to fire, then:
openclaw gateway status
cat /var/log/openclaw-deploy.log
```

## Step 7 — Pull on MacBook
```bash
cd ~/Projects/openclaw-steve
git pull origin main
```

## Step 8 — Customise workspace files
Now edit the workspace files on MacBook to give the agent its identity:
- `SOUL.md` — persona, tone, boundaries
- `AGENTS.md` — operating instructions, memory rules
- `IDENTITY.md` — name, emoji, theme
- `USER.md` — who the user is
- `TOOLS.md` — tool usage guidance
- `HEARTBEAT.md` — heartbeat checklist (keep short)
- Delete `BOOTSTRAP.md` after first run or leave for ritual

Then add model config, channel bindings, and tool restrictions to the
`agents.list[]` entry in `openclaw.json`.

Commit and push from MacBook:
```bash
git add .
git commit -m "Configure <agent-name> agent identity and bindings"
git push origin main
```

## Gotchas
- Always remove `.git` and `.openclaw` from the new workspace before committing
- Never add skills via extraDirs — symlink only what the agent needs
- `openclaw agents add` writes absolute paths into `openclaw.json` — these are
  correct for the server and should not be changed
- Channel tokens for new Discord/Telegram bots must be added to `~/.openclaw/.env`
  on the server and referenced as `${VAR_NAME}` in `openclaw.json`