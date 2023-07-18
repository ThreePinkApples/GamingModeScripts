#SingleInstance force
Persistent

^#a::
{
	toggleSound()
}

^#s::
{
	toggleMainDisplay()
}

^#g::
{
	toggleSound()
	toggleMainDisplay()
}

toggleMainDisplay()
{
	runPowershell(A_WorkingDir "\toggle_main_display.ps1")
}

toggleSound()
{
	runPowershell(A_WorkingDir "\toggle_audio.ps1")
}

runPowershell(scriptPath)
{
	RunWait "PowerShell.exe -ExecutionPolicy Bypass -Command " . scriptPath
}