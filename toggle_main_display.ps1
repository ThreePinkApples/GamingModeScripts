# MultiMonitorTool downloaded from https://www.nirsoft.net/utils/multi_monitor_tool.html
$multiMonitor = (Get-Location).tostring() + "\MultiMonitorTool\MultiMonitorTool.exe"
Add-Type -AssemblyName System.Windows.Forms
$screens = [System.Windows.Forms.Screen]::AllScreens
$primary = $screens | Where-Object {$_.Primary -eq 'True'}
# My TV has a resolution of 3840x2160, but with UI scaling set to 200%, so that's what I'm checking for here.
# (My monitors are both 2560x1440)
# You should change this value to match your TV and scaling combination. Run MultiMonitorTool, select your TV, and look for "Window Size" on the "Microsoft Text Input Application" row. That should be the Bounds.
$tv = $screens | Where-Object {$_.Bounds.Width -eq 1920 -And $_.Bounds.Height -eq 1080}

# If your TV and PC monitor has the same resolution you could try checking for refresh rate.

if ($primary.DeviceName -eq $tv.DeviceName) {
    # The numbers here comes from MultiMonitorTool.exe
    # You can run MultiMonitorTool.exe manually to get a window so you can see which number the monitors have
    # AllScreens doesn't provide refresh rate info, so when there are multiple monitors with the same resolution you just have to hardcode the index.
    # This index might change when disconnecting and reconnecting monitors, or when you buy a new monitor.
    & $multiMonitor /SetPrimary 3
}
else {
    & $multiMonitor /SetPrimary $tv.DeviceName
}