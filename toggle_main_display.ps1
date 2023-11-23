# MultiMonitorTool downloaded from https://www.nirsoft.net/utils/multi_monitor_tool.html
param(
    [string]$MonitorId = ""
)
$multiMonitor = (Get-Location).tostring() + "\MultiMonitorTool\MultiMonitorTool.exe"
if ($MonitorId -ne "") {
    & $multiMonitor /SetPrimary $MonitorId
    exit;
}
Add-Type -AssemblyName System.Windows.Forms
$screens = [System.Windows.Forms.Screen]::AllScreens
$primary = $screens | Where-Object {$_.Primary -eq 'True'}
$tv = $screens | Where-Object {$_.Bounds.Width -eq 3840 -And $_.Bounds.Height -eq 2160}
# This is the "Short Monitor ID" found by running MultiMonitorTool.exe
$primaryGamingMonitorId = "ACR0490"
if ($tv -eq $null) {
    # My TV has a resolution of 3840x2160, but with UI scaling set to 200%, so that's what I'm checking for here.
    # (My monitors are both 2560x1440)
    # You should change this value to match your TV and scaling combination. Run MultiMonitorTool, select your TV, and look for "Window Size" on the "Microsoft Text Input Application" row. That should be the Bounds.
    # If your TV and PC monitor has the same resolution you could try checking for refresh rate.
    $tv = $screens | Where-Object {$_.Bounds.Width -eq 1920 -And $_.Bounds.Height -eq 1080}
}

if ($primary.DeviceName -eq $tv.DeviceName) {
    & $multiMonitor /SetPrimary $primaryGamingMonitorId
}
else {
    & $multiMonitor /SetPrimary $tv.DeviceName
}
