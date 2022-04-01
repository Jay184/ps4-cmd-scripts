:: ___
:: Jay
:: ___

@echo off
@setlocal enabledelayedexpansion

@pushd .
@cd /d %~dp0


@if "%1" == "" (
   @echo Provide a pkg file. Usage: %~nx0 (PKG_FILE^)
   @exit /b 1
)


@set filename=%~1
@for %%a in ("%filename%") do (
   @set folder=%%~dpa
   @set name=%%~nxa
)


:: Add remove trailing "\", otherwise node won't serve any files.
@if {%folder:~-1,1%} == {\} (set folder=%folder:~0,-1%)


:: Install node HTTP server if not installed
@call nodejs\npm config set prefix %~dp0\nodejs --global
@call nodejs\npm config set update-notifier false --global

@for /f "tokens=* usebackq" %%a in (`call nodejs\npm ls http-server -g --depth=0 --parseable`) do @set server_installed=%%a
@if "%server_installed%" == "" (
   @echo Installing node http-server
   @call nodejs\npm install -g --silent http-server
)


:: Generate node HTTP server wrapper script
@if not exist "http_server.cmd" (
   @echo @echo Keep this running until you are done installed PKG files! > http_server.cmd
   @echo @nodejs\http-server %%* >> http_server.cmd
)


:: Create network settings if they don't exist
@if not exist "PS4_IP.txt" (
   @set /p ip_ps4="Enter IP (PS4): "
   @echo | set /p="!ip_ps4!" > PS4_IP.txt
)

@if not exist "SERVER_IP.txt" (
   @for /f "tokens=2 delims=[]" %%a in ('ping -4 -n 1 %ComputerName% ^| findstr [') do @set ip_server=%%a
   @echo | set /p="!ip_server!:8080" > SERVER_IP.txt
)


:: Load saved network settings
@set /p ip_ps4=<PS4_IP.txt
@set /p ip_server=<SERVER_IP.txt


:: Start http server if not running
@for /f "tokens=* usebackq" %%a in (`curl -s -o NUL -w "%%{http_code}" "http://%ip_server%/"`) do @set response_code=%%a
@if "%response_code%" == "000" (
   @echo Starting HTTP server ("http://%ip_server%/"^)
   @start http_server %folder%
)


:: Send download instruction to PS4
@curl/curl -s http://%ip_ps4%:12800/api/install --data {"""type""":"""direct""","""packages""":["""http://%ip_server%/%name%"""]}
@echo Done.

@popd
