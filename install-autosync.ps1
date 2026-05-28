# Run this once on each machine to install auto-sync.
# Works on any machine regardless of Windows username.

$WorkspaceDir = "C:\Users\$env:USERNAME\OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude"
$ScriptPath = "$WorkspaceDir\auto-sync.ps1"
$TaskName = "ClaudeWorkspaceSync"

Write-Host "Installing auto-sync for user: $env:USERNAME"
Write-Host "Workspace: $WorkspaceDir"
Write-Host ""

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""

$trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 30) -Once -At (Get-Date)

$settings = New-ScheduledTaskSettingsSet `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 5) `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable

Register-ScheduledTask `
    -TaskName $TaskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -RunLevel Highest `
    -Description "Auto-syncs Claude workspace to GitHub every 30 minutes" | Out-Null

Write-Host "Auto-sync installed successfully!" -ForegroundColor Green
Write-Host "Task name  : $TaskName"
Write-Host "Runs every : 30 minutes"
Write-Host "Log file   : $WorkspaceDir\sync-log.txt"
