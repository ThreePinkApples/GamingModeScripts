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
# The Bounds.Width/.Height are not as simple as the resolution, but the scaled values after using scaling. So on a 4K screen with 125% scaling Width is 3072, not 3840.
# If you use even higher scaling, such as 150%, this check will not work and you should hardcode the values
$tv = $screens | Where-Object {$_.Bounds.Width -gt 2560 -And $_.Bounds.Height -gt 1440}
if ($tv -eq $null) {
    # You should change this value to match your TV and scaling combination. Run MultiMonitorTool, select your TV, and look for "Window Size" on the "Microsoft Text Input Application" row. That should be the Bounds.
    # If your TV and PC monitor has the same resolution you could try checking for refresh rate.
    $tv = $screens | Where-Object {$_.Bounds.Width -eq 1920 -And $_.Bounds.Height -eq 1080}
}
# This is the "Short Monitor ID" found by running MultiMonitorTool.exe
$primaryGamingMonitorId = "ACR0490"
if ($primary.DeviceName -eq $tv.DeviceName) {
    & $multiMonitor /SetPrimary $primaryGamingMonitorId
}
else {
    & $multiMonitor /SetPrimary $tv.DeviceName
}