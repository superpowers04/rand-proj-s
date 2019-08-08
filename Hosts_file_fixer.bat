@echo off
setlocal enabledelayedexpansion

set WorkDir=%windir%\system32\drivers\etc
set hosts=%windir%\system32\drivers\etc\hosts
set imputFile=%WorkDir%\hosts.mclrem.bak
if exist %imputFile% goto restore

:clear
cls
echo This batch file will modify the hosts file
echo WE ARE NOT RESPONSIBLE FOR ANY DAMAGES CAUSED BY THIS FILE
pause

move %hosts% %imputFile%
for /f "delims=" %%A in ('findstr /i /v "mojang" %imputFile%') do (
 echo %%A >>%hosts%
)
pause
cls
echo All done, Try to sign in, if it works then reset your password, 
echo otherwise please go back to the minecraft discord server for more support
pause
exit

:restore error
cls
echo Please type yes or no and press enter(lowercase)
goto restore

:restore

echo Found hosts.mclrem.bak in %WorkDir%
set /p input= Do you want to restore backup?(yes or no?):
if %input%==n goto clear
if %input%==y goto restore2
if %input%==no goto clear
if %input%==yes goto restore2
if %input%==nah goto clear
if %input%==yea goto restore2
if %input%==ye goto restore2
if %input%==ofc goto restore2
if %input%==N goto clear
if %input%==Y goto restore2

goto restore
:restore2
cls
move %imputFile% %hosts%

echo All done restoring.
pause
exit
