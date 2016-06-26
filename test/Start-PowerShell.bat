@echo off
setlocal
set PSModulePath=%~dp0..\src;%PsModulePath%
start /max PowerShell.exe -NoLogo -ExecutionPolicy Bypass -NoExit -File "%~dp0init.ps1"
