# Claude Workspace Auto-Sync
# Works on any machine regardless of Windows username

$WorkspaceDir = "C:\Users\$env:USERNAME\OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude"
$LogFile = "$WorkspaceDir\sync-log.txt"

function Log($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp  $msg"
    Add-Content -Path $LogFile -Value $line
    Write-Host $line
}

Set-Location $WorkspaceDir

$status = git status --porcelain 2>&1
if (-not $status) {
    Log "No changes to sync."
    exit 0
}

Log "Changes detected - syncing..."

git pull --rebase origin main 2>&1 | ForEach-Object { Log $_ }
git add -A 2>&1 | ForEach-Object { Log $_ }

$commitMsg = "Auto-sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git commit -m $commitMsg 2>&1 | ForEach-Object { Log $_ }

git push origin main 2>&1 | ForEach-Object { Log $_ }

Log "Sync complete."
