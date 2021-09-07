@echo off
PUSHD %~DP0 &TITLE CacheDump 版本：2.8.2
mode con cols=90 lines=30
:A
if not exist feedback MD feedback & MD feedback\log_pro\log_pro
if not exist debug MD debug
if not exist log MD log
echo %date:~0,10% %time% cache bat started,ver 2.8.2>>debug\log.txt
if not exist "%WinDir%\Drv-status.txt" goto DR
if not exist tools\7za.exe echo %date:~0,10% %time% W:tools\7za.exe is not exist>>debug\log.txt & goto C
if not exist tools\adb.exe echo %date:~0,10% %time% W:tools\adb.exe is not exist>>debug\log.txt & goto C
if not exist tools\AdbWinApi.dll echo %date:~0,10% %time% W:tools\AdbWinApi.dll is not exist>>debug\log.txt & goto C
if not exist tools\AdbWinUsbApi.dll echo %date:~0,10% %time% W:tools\AdbWinUsbApi.dll is not exist>>debug\log.txt & goto C
echo %date:~0,10% %time% All files are existed,show main>>debug\log.txt
tasklist>debug\tasklist.txt
findstr /c:"adb.exe" debug\tasklist.txt
IF %ERRORLEVEL% EQU 0  echo.& echo %date:~0,10% %time% W:adb.exe is already running>>debug\log.txt & echo. 正在关闭正在运行的adb.exe & taskkill /f /im adb.exe & echo %date:~0,10% %time% adb.exe is killed successfully>>debug\log.txt & goto main
:main
CLS
echo.
echo. 当系统出现开机故障类问题时（尤其是升级新版本后），可通过此功能获取手机cache目录内容，帮助调查和解决问题
echo.
echo. *此功能建议在开发组或用户反馈相应管理人员的引导下使用
echo. *此功能不适用于写入了非官方Recovery的设备
echo.
echo. 先决条件和准备：
echo. 1.手机出现无限重启、卡米之类无法正常开机的问题，且问题出现后未进行过清除数据或刷机的操作（此项非常重要）
echo. 2.手机可连接到电脑
echo. 3.手机进入 Recovery 模式（方法见备注），通过音量上下键选择“连接小米助手”选项后，点击电源键确认
echo. 4.通过数据线将设备和电脑进行连接
echo.
echo. 备注：
echo. 1.手机关机状态下或者Fastboot模式下同时按电源键+音量上键可以进入 Recovery 模式；
echo. 2.手机无限重启过程中直接按音量上健也可以进入 Recovery 模式
echo.
echo. 按任意键开始导出日志
echo %date:~0,10% %time% waiting for user to preess a key>>debug\log.txt
pause >nul
echo.
echo %date:~0,10% %time% waiting for user to int contact>>debug\log.txt
set /p Q= 请输入您的联系方式，输入完成后按回车:
echo.
echo %date:~0,10% %time% log dump started>>debug\log.txt
echo. 正在获取日志...请保持设备连接稳定
tools\adb.exe pull /cache/ feedback\cache >debug\adb_tmp_.txt
tools\adb.exe pull /tmp/recovery.log feedback >debug\adb_tmp_.txt
findstr /c:"no devices/emulators found" debug\adb_tmp_.txt
IF %ERRORLEVEL% EQU 0 echo %date:~0,10% %time% W:warning in no devices found>>debug\log.txt & echo.& echo. 执行失败，无已连接设备，请检查设备连接以及设备所处模式 &echo. &echo. 可能的原因：&echo. 首先检查设备是否已连接到电脑，排查数据线连通性；进入设备管理器，能否看到第一项“Android Phone”设备，如果没有，建议重新安装驱动。&echo.&echo. 另外排查设备是否处于Recovery模式，并且已经进入“连接小米助手”状态&echo. & echo. 按任意键可以输出诊断日志以供分析 & pause >nul & goto D
findstr "error" debug\adb_tmp_.txt
IF %ERRORLEVEL% EQU 0 echo.& echo %date:~0,10% %time% W:warning in adb>>debug\log.txt & echo. 执行失败，请检查设备是否已正常开机，或后台运行程序及驱动是否会干扰执行，以及设备连接是否可靠 &echo. &echo. 可能的原因：&echo. 此问题出现时，建议排查是否有其他程序占用USB端口，是否有其他程序在占用adb指令通道，建议在任务管理器强停adb.exe再试一次；在“设备管理器”，检查并监控执行过程中，设备有无突然断连的情况，建议排查设备连接稳定性及驱动冲突问题是否存在。&echo.  & echo. 按任意键可以输出诊断日志以供分析 & pause >nul & goto D
if exist debug\adb_tmp_.txt del debug\adb_tmp_.txt
echo %date:~0,10% %time% pulling cache files successfully>>debug\log.txt
echo Time=%date:~0,10% %time%, >>feedback\summary.txt
echo.C=%Q% >>feedback\summary.txt
echo.
echo. 正在压缩日志...
tools\7za.exe a log\cache%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.zip feedback  >debug\logz.txt
findstr /c:"Everything is Ok" debug\logz.txt
IF %ERRORLEVEL% NEQ 0  echo.& echo %date:~0,10% %time% W:warning zipping files>>debug\log.txt & echo. 错误：文件压缩失败 & echo. 可联系工具开发人员 &echo. & echo. 按任意键可以输出诊断日志以供分析 & pause >nul & goto D
if exist feedback RD /q /s feedback & MD feedback & MD feedback\log_pro
echo %date:~0,10% %time% zipping cache files successfully>>debug\log.txt
echo.
echo. 日志获取完成，已进入文件所在目录，请将其中以“cache+当前时间.zip”格式名称的文件发给对应人员。
explorer log
echo. 按任意键退出
pause >nul
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
goto main
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
goto main
:C
echo.
echo.  检测到关键文件丢失，请排查压缩包内文件是否全部解压
pause >nul
exit
:D
if exist log\debug.zip del log\debug.zip
echo Time=%date:~0,10% %time%, >>debug\summary.txt
echo.C=%Q% >>debug\summary.txt
if exist %WinDir%\Drv-status.txt copy %WinDir%\Drv-status.txt debug
if exist %WinDir%\DPINST.LOG copy %WinDir%\DPINST.LOG debug
echo.
echo. 正在压缩日志...
tools\7za.exe a log\Debug.zip debug
if exist feedback RD /q /s feedback & MD feedback & MD feedback\log_pro
if exist debug RD /q /s debug & MD debug
echo.
echo. 日志获取完成，已进入文件所在目录，请将Debug.zip发给对应人员。
explorer log
echo. 按任意键退出
pause >nul
exit