# PowerShell audio dll downloaded from https://github.com/frgnca/AudioDeviceCmdlets
New-Item "$($profile | split-path)\Modules\AudioDeviceCmdlets" -Type directory -Force
Copy-Item "$((Get-Location).tostring())\AudioDeviceCmdlets.dll" "$($profile | split-path)\Modules\AudioDeviceCmdlets\AudioDeviceCmdlets.dll"
Set-Location "$($profile | Split-Path)\Modules\AudioDeviceCmdlets"
Get-ChildItem | Unblock-File
Import-Module AudioDeviceCmdlets

# Replace HeadsetName and ReceiverName with the name of your device as seen in Windows audio settings.
# The names do not have to be exact.
$HeadsetName = "Arctis 7 Game"
$ReceiverName = "DENON-AVR"
$HeadsetID = ""
$ReceiverID = ""

foreach($AudioDevice in Get-AudioDevice -List){
    # echo $AudioDevice
    # It might be necessary to also match on Earphone so that
    # it doesn't pick the microphone (if the headset has a microphone).
    # if (($AudioDevice.Name -Match $HeadsetName) -and
    #     ($AudioDevice.Name -Match "Earphone")){
    if ($AudioDevice.Name -Match $HeadsetName){
        $HeadsetID = $AudioDevice.ID
    }
    elseif ($AudioDevice.Name -Match $ReceiverName){
        $ReceiverID = $AudioDevice.ID
    }
}

$DefaultAudio = Get-AudioDevice -Playback
if ($DefaultAudio.ID -eq $HeadsetID){
    echo "Switching to receiver"
    Set-AudioDevice -ID $ReceiverID
}
else{
    echo "Switching to headset"
    Set-AudioDevice -ID $HeadsetID
}
