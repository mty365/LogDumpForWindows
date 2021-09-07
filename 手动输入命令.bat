@echo off
PUSHD %~DP0 &TITLE 手动输入命令
:main
if not exist feedback MD feedback & MD feedback\log_pro\log_pro
if not exist debug MD debug
if not exist log MD log
echo %date:~0,10% %time% manual bat started,ver 2.8.2>>debug\log.txt
if not exist "%WinDir%\Drv-status.txt" goto DR
if not exist tools\fastboot.exe echo %date:~0,10% %time% W:tools\fastboot.exe is not exist>>debug\log.txt & goto C
if not exist tools\adb.exe echo %date:~0,10% %time% W:tools\adb.exe is not exist>>debug\log.txt & goto C
if not exist tools\AdbWinApi.dll echo %date:~0,10% %time% W:tools\AdbWinApi.dll is not exist>>debug\log.txt & goto C
if not exist tools\AdbWinUsbApi.dll echo %date:~0,10% %time% W:tools\AdbWinUsbApi.dll is not exist>>debug\log.txt & goto C
echo %date:~0,10% %time% All files are existed,show main>>debug\log.txt
tasklist>debug\tasklist.txt
findstr /c:"adb.exe" debug\tasklist.txt
IF %ERRORLEVEL% EQU 0  echo.& echo %date:~0,10% %time% W:adb.exe is already running>>debug\log.txt & echo. 正在关闭正在运行的adb.exe & taskkill /f /im adb.exe & echo %date:~0,10% %time% adb.exe is killed successfully>>debug\log.txt & goto main1
:main1
cd %~dp0tools
start
exit
:DR
%~d0
cd %~dp0
if not exist tools\Driver1 echo %date:~0,10% %time% W:tools\Driver1 is not exist>>debug\log.txt & goto C
if not exist tools\Driver2 echo %date:~0,10% %time% W:tools\Driver2 is not exist>>debug\log.txt & goto C
echo.
echo. 首次使用，正在自动安装驱动，请稍候，请不要关闭窗口
echo. 
echo. 安装过程中可能会弹出安全提示，请点击“始终安装此驱动程序软件”
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(echo. &echo. 安装失败，获取管理员权限失败，请关闭窗口后通过右键菜单，选择“以管理员身份运行”尝试。&&Pause >nul&&Exit)
if exist "%WinDir%\SysWOW64" goto DR2
echo.
echo. 正在处理（1/3）
tools\DPInst.exe /PATH "%~dp0tools\Driver1" /F /LM /SW /SA
echo. 正在处理（2/3）
tools\DPInst.exe /PATH "%~dp0tools\Driver2" /F /LM /SW /SA
echo. 正在处理（3/3）
echo  Done by MTools-R V2.8.2 X86 %date:~0,10% %time%>%WinDir%\Drv-status.txt
echo %date:~0,10% %time% installing drivers 86 successfully>>debug\log.txt
goto main1
:DR2
%~d0
cd %~dp0
echo.
echo. 正在处理（1/3）
tools\DPInst64.exe /PATH "%~dp0tools\Driver1" /F /LM /SW /SA
echo. 正在处理（2/3）
tools\DPInst64.exe /PATH "%~dp0tools\Driver2" /F /LM /SW /SA
echo. 正在处理（3/3）
echo  Done by MTools-R V2.8.2 X64 %date:~0,10% %time%>%WinDir%\Drv-status.txt
echo %date:~0,10% %time% installing drivers 64 successfully>>debug\log.txt
goto main1
:C
echo.
echo.  检测到关键文件丢失，请排查压缩包内文件是否全部解压
pause >nul
exit
