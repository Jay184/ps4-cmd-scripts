@setlocal enabledelayedexpansion
@pushd .
@cd /d %~dp0

@if "%1" == "" (
   @echo Provide a json file. Usage: %~nx0 (JSON_FILE^)
   @exit /b 1
)

@if not exist "PS4_IP.txt" (
   @set /p ip_ps4="Enter IP (PS4): "
   @echo | set /p="!ip_ps4!" > PS4_IP.txt
)

@set /p ip_ps4=<PS4_IP.txt

@set filename=%~1
@for %%A in ("%filename%") do (
   @set folder=%%~dpA
   @set name=%%~nxA
)

@if {%folder:~-1,1%} == {\} (set folder=%folder:~0,-1%)


@echo open %ip_ps4% 2121 > ftpscript.txt
@echo user >> ftpscript.txt
@echo pass >> ftpscript.txt
@echo lcd %folder%
@echo put "%filename%" "/user/data/GoldHEN/cheats/json/%name%" >> ftpscript.txt
@echo quit >> ftpscript.txt

@ftp -s:ftpscript.txt
@del ftpscript.txt
@popd
