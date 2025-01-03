# PowerShell audio dll installed/downloaded from https://github.com/frgnca/AudioDeviceCmdlets

# Uncomment the following 4 lines if you chose to download the .dll instead of installing.
# New-Item "$($profile | split-path)\Modules\AudioDeviceCmdlets" -Type directory -Force
# Copy-Item "$((Get-Location).tostring())\AudioDeviceCmdlets.dll" "$($profile | split-path)\Modules\AudioDeviceCmdlets\AudioDeviceCmdlets.dll"
# Set-Location "$($profile | Split-Path)\Modules\AudioDeviceCmdlets"
# Get-ChildItem | Unblock-File
Import-Module AudioDeviceCmdlets

# Replace HeadsetName and ReceiverName with the name of your device as seen in Windows audio settings.
# The names do not have to be exact.
$HeadsetName = "Arctis 7 Game"
$ReceiverName = "LG TV SSCR2"
$HeadsetID = ""
$ReceiverID = ""

$Logfile = "${PSScriptRoot}\$(gc env:computername).log"

function LogWrite {
    param (
        [string]$logstring,
        [bool]$error = $false
    )

    $date = Get-Date -Format "o"
    if ($error) {
        Write-Error $logstring
        Add-content $Logfile -value "[${date}] [ERROR] ${logstring}"
    }
    else {
        Write-Output $logstring
        Add-content $Logfile -value "[${date}] [INFO] ${logstring}"
    }
}
LogWrite $PSVersionTable.PSVersion

foreach($AudioDevice in Get-AudioDevice -List) {
    # LogWrite $AudioDevice
    if ($AudioDevice.Type -eq "Playback") {
        if ($AudioDevice.Name -Match $HeadsetName) {
            $HeadsetID = $AudioDevice.ID
        }
        elseif ($AudioDevice.Name -Match $ReceiverName) {
            $ReceiverID = $AudioDevice.ID
        }
    }
}
if ($HeadsetID -eq "" -And $ReceiverID -eq "") {
    LogWrite "Couldn't find headset device or receiver device. Please verify that they are connected, or there might be a typo in the script." $true
    exit
} elseif ($HeadsetID -eq "") {
    LogWrite "Couldn't find headset device" $true
} elseif ($ReceiverID -eq "") {
    LogWrite "Couldn't find receiver device" $true
}

$DefaultAudio = Get-AudioDevice -Playback
# -DefaultOnly param was introduced with
# https://github.com/frgnca/AudioDeviceCmdlets/pull/51
# The parameter is only relevant for usecases where your default communication device is not the
# same as your default playback device.
if ($DefaultAudio.ID -eq $HeadsetID -Or $HeadsetID -eq "") {
    LogWrite "Switching to receiver"
    Set-AudioDevice -ID $ReceiverID -DefaultOnly
}
else {
    LogWrite "Switching to headset"
    Set-AudioDevice -ID $HeadsetID -DefaultOnly
}
