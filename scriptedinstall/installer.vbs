Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\BlackBerry\scr\installer.cmd" & Chr(34), 0
Set WinScriptHost = Nothing