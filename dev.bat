@echo off
setlocal
set cd_old=%cd%
cd %~dp0
if EXIST launcher_win.exe (
start launcher_win.exe -dev +set lua_nocompile 1 %*
) ELSE (
echo Error: launcher_win.exe not found in this bat's directory.
echo Press any key to exit . . .
pause > nul
)
cd %cd_old%
endlocal