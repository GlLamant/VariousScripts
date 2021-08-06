chcp 65001

set /p msg=Would you like to continue(Y/N)?:
echo off
if %msg% == Y goto start
if %msg% == N goto stop

:start
echo start service
goto end

:stop
echo stop service
goto end

:end
echo That's it.

pause