# Claude Workspace Auto-Sync
# Runs automatically — commits and pushes any changes to GitHub

$WorkspaceDir = "C:\Users\Avi\OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude"
$LogFile = "$WorkspaceDir\sync-log.txt"

function Log($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp  $msg" | Tee-Object -FilePath $LogFile -Append
}

Set-Location $WorkspaceDir

# Check if there's anything to commit
$status = git status --porcelain 2>&1
if (-not $status) {
    Log "No changes to sync."
    exit 0
}

Log "Changes detected — syncing..."

# Pull latest first (avoid conflicts)
git pull --rebase origin main 2>&1 | ForEach-Object { Log $_ }

# Stage all changes
git add -A 2>&1 | ForEach-Object { Log $_ }

# Commit with timestamp
$commitMsg = "Auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $commitMsg 2>&1 | ForEach-Object { Log $_ }

# Push
git push origin main 2>&1 | ForEach-Object { Log $_ }

Log "Sync complete."
