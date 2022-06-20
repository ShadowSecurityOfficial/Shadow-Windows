echo OFF

AT > NUL
IF %ERRORLEVEL% EQU 0 (
    ECHO you are Administrator
) ELSE (
    ECHO you are NOT Administrator. Exiting...
    PING 127.0.0.1 > NUL 2>&1
    EXIT /B 1
)

set "IPADDRESS=8.8.8.8"

:TestNetworkConnection
ping -n 1 %IPADDRESS% | find "TTL=" >nul
if errorlevel 1 (
    goto Retry
) else (
    goto ExecTask
)

:Retry
echo "Connection to %IPADDRESS% FAILED, PLEASE INSTALL NETWORK DRIVERS OR CONNECT TO THE INTERNET."
ping 127.0.0.1 -n 6 >nul REM wait for 5 seconds (-n %SECONDS%+1)
goto :TestNetworkConnection

:ExecTask
echo "Connection to %IPADDRESS% is OK."
pause
