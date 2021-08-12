@echo off

rem Install alternately apk to difference machine.

:: Todo: Check out if the input params are valid.

:: Variables defined by myself.
set package_name=cn.closeli.rtc

:: Parse input params
set ip_list_file=%1
set apk_file=%2

:: 
for /f %%i in (%ip_list_file%) do (
	echo Perform machine[%%i]
	adb connect %%i
	adb -s %%i uninstall %package_name%
	adb -s %%i install %apk_file%
	adb -s %%i shell am start %package_name%
	adb disconnect
)

:End
echo done.