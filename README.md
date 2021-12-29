# Gaming mode scripts

A simple set of script for switching between "PC Monitor" and "TV" gaming modes.
The real life setup here is that you have your PC hooked up to a gaming monitor and your TV, and you switch between which you use depending on the game you're playing.

It uses [AutoHotkey](https://www.autohotkey.com/) to create the keyboard shortcuts to switch between the modes, PowerShell to do the actual switching, and some external libraries to help out with changing audio device and main monitor.

## How to use
You can edit the shortcuts yourself in `auto_hot_keys.ahk`, but this are the current shortcuts:

1. `Windows logo key + Ctrl + S` to toggle between TV and PC monitor
2. `Windows logo key + Ctrl + A` to toggle between TV/Reciever audio and Headset audio
3. `Windows logo key + Ctrl + G` to toggle both.

## How to install
1. Clone/Download this repo.
	1. If downloaded as zip, remember to extract it.
2. Download and install [AutoHotKey][1]
3. (Recommended) Install [AudioDeviceCmdlets][2].
	1. (Alternative, old method) Download the .dll file and move it into the same folder as this file.
4. Download [MultiMonitorTool][3] for x64 systems
	1. Extract the contents into the same folder as this file.
5. Edit `toggle_audio.ps1` and replace the names of the audio devices to your own (instructions are in the file)
6. Edit `toggle_main_display.ps1` and replace the monitor numbers with your own (instructions are in the file)
7. Run the auto_hot_keys.ahk file.
	1. In your system tray (bottom right corner) you should now see the AutoHotKey icon
8. Test it out by pressing the shortcuts

#### Set to start with Windows
After the above steps, you can set the auto_hot_keys.ahk file to start with Windows so that you'll always have the shortcuts available

1. Right click on `auto_hot_keys.ahk` and click "Create shortcut".
2. Press `Windows logo key + R`, type `shell:startup`, and hit enter. This opens up the Start-up folder
3. Move the shortcut you created in step 1 into the Start-up folder.

## Dependencies
- [AutoHotKey][1]
- [AudioDeviceCmdlets][2]
- [MultiMonitorTool][3]

[1]: https://www.autohotkey.com/
[2]: https://github.com/frgnca/AudioDeviceCmdlets
[3]: https://www.nirsoft.net/utils/multi_monitor_tool.html