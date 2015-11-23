@echo off

rem Remove Scheduled Task
SchTasks /Delete /TN "Firstboot" /F


rem call besconfig
call BESConfig.exe

rem call go.cmd
go.cmd


