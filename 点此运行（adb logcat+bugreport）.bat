@echo off
PUSHD %~DP0 &TITLE adb logcat/bugreport 版本：2.8.2
mode con cols=90 lines=30
:A
if not exist feedback MD feedback & MD feedback\log_pro\log_pro
if not exist debug MD debug
if not exist log MD log
echo %date:~0,10% %time% logcat bat started,ver 2.8.2>>debug\log.txt
echo %date:~0,10% %time% start to search files>>debug\log.txt
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
echo. 本功能可以获取系统运行日志（adb logcat/bugreport），帮助调查和解决问题
echo.
echo. *此功能建议在开发组或用户反馈相应管理人员的引导下使用
echo.
echo. 先决条件和准备：
echo. 1.手机出现卡米（但屏幕下方有三个点在跑），且问题出现后未进行过清除数据或刷机的操作（此项非常重要）；或者其他特殊获取日志的需求
echo. 2.手机端“设置-更多设置-开发者选项-USB调试”功能开启；通过数据线将设备和电脑进行连接，插入电脑后通知栏的选择USB用途通知点击后的对话框应选择“传输文件（MTP）”，或已经显示“已开启USB文件传输模式”通知
echo.
echo. 按任意键开始导出日志
echo %date:~0,10% %time% waiting for user to preess a key>>debug\log.txt
pause >nul
echo.
echo %date:~0,10% %time% waiting for user to int contact>>debug\log.txt
set /p Q= 请输入您的联系方式，输入完成后按回车:
echo.
if exist debug\adb_tmp_.txt del debug\adb_tmp_.txt
echo %date:~0,10% %time% log dump started>>debug\log.txt
echo. 正在检查设备连接...
echo. 请把手机保持亮屏已解锁屏状态，若手机端弹出USB授权弹窗，请勾选“一律允许这台计算机进行调试”并点击“确定”
tools\adb.exe pull /cache/ feedback\cache >debug\adb_tmp_.txt
findstr /c:"no devices/emulators found" debug\adb_tmp_.txt
IF %ERRORLEVEL% EQU 0 echo %date:~0,10% %time% W:warning in no devices found>>debug\log.txt & echo.& echo. 执行失败，无已连接设备，请检查设备连接以及设备所处模式 &echo. &echo. 可能的原因：&echo. 首先检查设备是否已连接到电脑，排查数据线连通性；进入设备管理器，能否看到第一项“Android Phone”设备，如果没有，建议重新安装驱动。&echo.&echo. （1）如手机无法开机的情况下，排查设备是否处于Recovery模式，并且已经进入“连接小米助手”状态；&echo.&echo. （2）如手机可以正常开机，请排查手机端“设置-更多设置-开发者选项-USB调试”功能是否开启，通知栏的选择USB用途通知点击后的对话框应选择“传输文件（MTP）”，或已经显示“已开启USB文件传输模式”通知 &echo.& echo. 如不了解具体操作，可联系对应负责人员或查看操作说明文档。&tools\adb.exe devices >debug\adb.txt &echo.& echo. 按任意键可以输出诊断日志以供分析 & pause >nul & goto D
findstr /c:"unauthorized" debug\adb_tmp_.txt
IF %ERRORLEVEL% EQU 0 echo %date:~0,10% %time% W:warning in device is not unauthorized>>debug\log.txt & echo.& echo. 执行失败，设备未授权。请检查手机端的USB授权弹窗已经勾选“一律允许这台计算机进行调试”并点击“确定”&tools\adb.exe devices >debug\adb.txt &echo.& echo. 按任意键可以输出诊断日志以供分析 & pause >nul & goto D
:SM
echo %date:~0,10% %time% waiting for user to int mode>>debug\log.txt
echo.
echo. 选择日志抓取方式
echo.
echo. 导出现有日志----1
echo.
echo. 导出现有日志并录制新日志1分钟----2
echo.
echo. 导出现有日志（bugreport）----3
echo.
set /p xz=  输入数字按回车：
if /i "%xz%"=="1" goto MO1
if /i "%xz%"=="2" goto MO2
if /i "%xz%"=="3" goto MO3
echo.
echo %date:~0,10% %time% mode is not exist>>debug\log.txt
echo  选择无效，请重新输入
ping -n 2 127.1>nul 
goto SM
:MO1
echo %date:~0,10% %time% user choose mode1>>debug\log.txt
start tools\logcat1.bat
goto MO
:MO2
echo %date:~0,10% %time% user choose mode2>>debug\log.txt
echo StartTime=%date:~0,10% %time%, >>feedback\summary.txt
start tools\logcat2.bat
goto MO
:MO
echo.
echo. 正在输出logcat，大约需要一段时间，期间会弹出新窗口，完成后会自动关闭，请不要手动关闭，并保持设备连接稳定
tools\adb.exe logcat >feedback\logcat.txt
echo %date:~0,10% %time% pulling logcat successfully>>debug\log.txt
echo EndTime=%date:~0,10% %time%, >>feedback\summary.txt
echo.C=%Q% >>feedback\summary.txt
echo.
echo. 正在压缩日志...
tools\7za.exe a log\logcat%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.zip feedback  >debug\logz.txt
findstr /c:"Everything is Ok" debug\logz.txt
IF %ERRORLEVEL% NEQ 0  echo.& echo %date:~0,10% %time% W:warning zipping files>>debug\log.txt & echo. 错误：文件压缩失败 & echo. 可联系工具开发人员 &echo. & echo. 按任意键可以输出诊断日志以供分析 & pause >nul & goto D
if exist feedback RD /q /s feedback & MD feedback & MD feedback\log_pro
echo %date:~0,10% %time% zipping logcat successfully>>debug\log.txt
echo.
echo. 日志获取完成，已进入文件所在目录，请将其中以“logcat+当前时间.zip”格式名称的文件发给对应人员。
explorer log
echo. 按任意键退出
pause >nul
exit
:MO3
echo.
echo. 正在输出bugreport，大约需要一段时间，请保持设备连接稳定并为亮屏已解锁状态
echo.
tools\adb.exe bugreport log\bugreport%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.zip
echo %date:~0,10% %time% pulling bugreport successfully>>debug\log.txt
if exist feedback RD /q /s feedback & MD feedback & MD feedback\log_pro
echo.
echo. 日志获取完成，已进入文件所在目录，请将其中以“bugreport+当前时间.zip”格式名称的文件发给对应人员。
explorer log
echo. 按任意键退出
pause >nul
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