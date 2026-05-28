# Run this ONCE on each machine to install the auto-sync scheduled task.
# It will sync your Claude workspace to GitHub every 30 minutes while you're logged in.
#
# Usage: Right-click this file → "Run with PowerShell"
# (or: powershell -ExecutionPolicy Bypass -File install-autosync.ps1)

$WorkspaceDir = "C:\Users\Avi\OneDrive - trapeznsm.com\Documents\Claude\Projects\sync claude"
$ScriptPath   = "$WorkspaceDir\auto-sync.ps1"
$TaskName     = "ClaudeWorkspaceSync"

# Remove existing task if present
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

$action  = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$ScriptPath`""

# Run every 30 minutes, indefinitely
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
    -Description "Auto-syncs Claude workspace folder to GitHub every 30 minutes" | Out-Null

Write-Host ""
Write-Host "✓ Auto-sync task installed!" -ForegroundColor Green
Write-Host "  Task name : $TaskName"
Write-Host "  Runs every: 30 minutes"
Write-Host "  Script    : $ScriptPath"
Write-Host ""
Write-Host "To check status: Open Task Scheduler and look for '$TaskName'"
Write-Host "To uninstall  : Unregister-ScheduledTask -TaskName '$TaskName' -Confirm:`$false"
Write-Host ""
