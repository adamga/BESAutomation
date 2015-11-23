Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\BlackBerry\scr\firstboot.cmd" & Chr(34), 0
Set WinScriptHost = Nothing