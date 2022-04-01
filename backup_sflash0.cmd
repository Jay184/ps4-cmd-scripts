@setlocal enabledelayedexpansion
@pushd .
@cd /d %~dp0


:: Get PS4 IP address
@if not exist "PS4_IP.txt" (
   @set /p ip_ps4="Enter IP (PS4): "
   @echo | set /p="!ip_ps4!" > PS4_IP.txt
)

@set /p ip_ps4=<PS4_IP.txt


:: Format name
@set str_date=%date:.=_%
@set str_time=%time::=_%
@set str_time=%str_time:,=_%
@set timestamp=%str_date%_%str_time%
@set filename=sflash0_%timestamp%


:: Download file
@echo open %ip_ps4% 2121 > ftpscript.txt
@echo user >> ftpscript.txt
@echo pass >> ftpscript.txt
@echo lcd %~dp0
@echo get "/dev/sflash0" "%filename%" >> ftpscript.txt
@echo quit >> ftpscript.txt

@ftp -v -s:ftpscript.txt
@del ftpscript.txt


:: Check file size for validity
@for /f "usebackq" %%a in ('%filename%') do @set filesize=%%~za
@if not "%filesize%" == "33554432" (
   @echo sflash0 file is corrupted!
   @del %filename%
)

@echo Done.
@popd
