# MultiMonitorTool downloaded from https://www.nirsoft.net/utils/multi_monitor_tool.html
$multiMonitor = (Get-Location).tostring() + "\MultiMonitorTool\MultiMonitorTool.exe"
Add-Type -AssemblyName System.Windows.Forms
$res = [System.Windows.Forms.Screen]::AllScreens | Where-Object {$_.Primary -eq 'True'} | Select-Object WorkingArea
# My PC monitor has a resolution of 2560x1440, so that's what I'm checking for here.
# You should change this value to match your PC monitor.
# If your TV and PC monitor has the same resolution you could try checking for refresh rate.
if ($res.WorkingArea.Width -eq 2560){
    # The numbers here comes from MultiMonitorTool.exe
    # You can run MultiMonitorTool.exe manually to get a window so you can see which number the monitors have
    & $multiMonitor /SetPrimary 3
}
else {
    & $multiMonitor /SetPrimary 2
}
