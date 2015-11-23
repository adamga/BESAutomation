@echo off
rem wait 5 seconds...
ping 127.0.0.1 -n 4 > nul


rem clean up scheduled task

SchTasks /Delete /TN "BES First Run" /F

start /max iexplore.exe http://aka.ms/bes123readme



