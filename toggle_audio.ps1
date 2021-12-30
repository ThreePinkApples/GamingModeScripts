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
$ReceiverName = "DENON-AVR"
$HeadsetID = ""
$ReceiverID = ""

foreach($AudioDevice in Get-AudioDevice -List) {
    # echo $AudioDevice
    if ($AudioDevice.Type -eq "Playback") {
        if ($AudioDevice.Name -Match $HeadsetName) {
            $HeadsetID = $AudioDevice.ID
        }
        elseif ($AudioDevice.Name -Match $ReceiverName) {
            $ReceiverID = $AudioDevice.ID
        }
    }
}

$DefaultAudio = Get-AudioDevice -Playback
# -PlaybackOnly param was introduced with
# https://github.com/frgnca/AudioDeviceCmdlets/pull/48
# and will require building AudioDeviceCmdlets.dll from source until the PR has been merged and released.
# The parameter is only relevant for usecases where your default communication device is not the
# same as your default playback device.
if ($DefaultAudio.ID -eq $HeadsetID){
    echo "Switching to receiver"
    Set-AudioDevice -ID $ReceiverID -PlaybackOnly
}
else{
    echo "Switching to headset"
    Set-AudioDevice -ID $HeadsetID -PlaybackOnly
}
