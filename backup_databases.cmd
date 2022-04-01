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


:: Download file
@echo open %ip_ps4% 2121 > ftpscript.txt
@echo user >> ftpscript.txt
@echo pass >> ftpscript.txt
@echo lcd %~dp0
@echo get "/system_data/priv/mms/addcont.db" "addcont_%timestamp%.db" >> ftpscript.txt
@echo get "/system_data/priv/mms/app.db" "app_%timestamp%.db" >> ftpscript.txt
@echo get "/system_data/priv/mms/av_content_bg.db" "av_content_bg_%timestamp%.db" >> ftpscript.txt
@echo get "/system_data/priv/mms/notification.db" "notification_%timestamp%.db" >> ftpscript.txt
@echo quit >> ftpscript.txt

@ftp -v -s:ftpscript.txt
@del ftpscript.txt

@echo Done.
@popd
