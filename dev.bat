@echo off
set cd_old=%cd%
cd %~dp0
start launcher.exe -dev %*
cd %cd_old%