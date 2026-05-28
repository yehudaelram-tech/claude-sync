# Claude Sync — Setup Guide

This folder is the single source of truth for your Claude workspace across all three computers.
It lives on OneDrive **and** GitHub, giving you two independent sync layers.

---

## What syncs automatically (nothing to do)

| What | How |
|------|-----|
| Claude.ai chats & Projects | Account-based — just stay logged in |
| Files in this folder | OneDrive syncs them automatically |
| Code & deliverables | GitHub (after setup below) |

---

## First-time setup on each machine

### Step 1 — Connect this folder in Cowork

1. Open the Claude desktop app
2. Click the folder icon to select a workspace
3. Navigate to: `OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude`
4. Select it — Cowork will now save all outputs here

### Step 2 — Connect GitHub (one-time, run in PowerShell)

On **Machine 1** (first time only — creates the repo):
```powershell
cd "C:\Users\Avi\OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude"
git init -b main
git add .
git commit -m "Initial sync setup"
# Create a repo at https://github.com/new called "claude-sync", then:
git remote add origin https://github.com/YOUR_USERNAME/claude-sync.git
git push -u origin main
```

On **Machines 2 & 3** (or if the folder is empty on a new machine):
```powershell
# Option A — folder already exists via OneDrive, just link it to git:
cd "C:\Users\Avi\OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude"
git init -b main
git remote add origin https://github.com/YOUR_USERNAME/claude-sync.git
git fetch origin
git reset --hard origin/main

# Option B — fresh clone (if OneDrive isn't set up yet):
cd "C:\Users\Avi\OneDrive - trapeznsm.com\Documents\Claude\Projects"
git clone https://github.com/YOUR_USERNAME/claude-sync.git "sync claude"
```

### Step 3 — Install auto-sync (runs every 30 minutes, no thinking required)

Right-click `install-autosync.ps1` → **Run with PowerShell**

That's it. It installs a Windows scheduled task that commits and pushes any changes
every 30 minutes while you're logged in. A `sync-log.txt` file will appear in this
folder so you can see exactly what synced and when.

Run this on each of your three machines.

---

## Per-machine setup (one-time, can't be synced)

These are tied to each machine and must be done once on each computer:

- **MCP connectors** (Gmail, Google Drive, Asana, etc.) — re-authorize in app settings
- **Scheduled tasks** — recreate any recurring tasks you set up on the original machine

---

## What lives in this folder

```
sync claude/
├── SETUP.md              ← this file
├── .gitignore
├── auto-sync.ps1         ← the sync script (runs automatically)
├── install-autosync.ps1  ← run this once per machine to install the task
├── sync-log.txt          ← created automatically; shows sync history
├── projects/             ← your code projects (put them here to sync via git)
├── notes/                ← anything you want Claude to remember cross-device
└── outputs/              ← deliverables Claude creates (docs, spreadsheets, etc.)
```

To add code projects to the sync: move them inside this folder (or a subfolder),
and they'll sync via both OneDrive and GitHub automatically.
