# MultiMonitorTool downloaded from https://www.nirsoft.net/utils/multi_monitor_tool.html
param(
    [string]$MonitorId = ""
)
# This is the "Short Monitor ID" found by running MultiMonitorTool.exe
$primaryGamingMonitorId = "AUS32F2"
$tvMonitorId = "GSM81CD"
Add-Type -AssemblyName System.Windows.Forms
$screens = [System.Windows.Forms.Screen]::AllScreens
$primary = $screens | Where-Object {$_.Primary -eq 'True'}

function Set-Primary {
    param (
        [string]$MonitorId,
        [boolean]$Enable,
        [boolean]$SetPosition,
        [int]$PositionX,
        [int]$PositionY
    )
    # My TV can for some reason be set to disconnected in Windows and will thus require enabling before
    # setting it as primary
    if ($Enable) {
        echo "Enabling ${MonitorId}"
        & $multiMonitor /enable $MonitorId | Wait-Process
        # Some delay is required for the monitor to connect properly. Increase this if
        # /SetPrimary fails to set the correct monitor
        #Start-Sleep -Milliseconds 6200
    }
    # After enabling the monitor its position is not what it should be in my case, so
    # it needs to be changed before setting primary.
    if ($SetPosition) {
        echo "Setting possition on ${MonitorId} to ${PositionX} ${PositionY}"
        & $multiMonitor /SetMonitors "Name=${MonitorId} PositionX=${PositionX} PositionY=${PositionY}" | Wait-Process
        # Some delay is required for this to be processed before /SetPrimary changes the Position values
        #Start-Sleep -Milliseconds 2500
    }
    echo "Setting ${MonitorId} as primary"
    & $multiMonitor /SetPrimary $MonitorId | Wait-Process
}

$tvPositionX = 6400
$multiMonitor = (Get-Location).tostring() + "\MultiMonitorTool\MultiMonitorTool.exe"
if ($MonitorId -ne "") {
    $Enable = ($MonitorId -eq $tvMonitorId)
    Set-Primary -MonitorId $MonitorId -Enable $Enable -SetPosition $false -PositionX $tvPositionX -PositionY 0
    exit;
}
# The Bounds.Width/.Height are not as simple as the resolution, but the scaled values after using scaling. So on a 4K screen with 125% scaling Width is 3072, not 3840.
# If you use even higher scaling, such as 150%, this check will not work and you should hardcode the values
$tv = $screens | Where-Object {$_.Bounds.Width -eq 3840 -And $_.Bounds.Height -eq 2160 }
if ($tv -eq $null) {
    # Fallback for 200% scaling
    $tv = $screens | Where-Object {$_.Bounds.Width -eq 1920 -And $_.Bounds.Height -eq 1080}
}
#echo "TV: ${tv}"
#echo "Primary: ${primary}"
if ($primary.DeviceName -eq $tv.DeviceName) {
    Set-Primary -MonitorId $primaryGamingMonitorId -Enable $false -SetPosition $false
}
else {
    $Enable = ($tv -eq $null)
    Set-Primary -MonitorId $tvMonitorId -Enable $Enable -SetPosition $false -PositionX $tvPositionX -PositionY 0
}
