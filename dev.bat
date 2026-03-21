@echo off
set cd_old=%cd%
cd %~dp0
start launcher.exe -dev +set lua_nocompile 1 %*
cd %cd_old%