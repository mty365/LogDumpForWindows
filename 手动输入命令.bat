@echo off
PUSHD %~DP0 &TITLE �ֶ���������
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
IF %ERRORLEVEL% EQU 0  echo.& echo %date:~0,10% %time% W:adb.exe is already running>>debug\log.txt & echo. ���ڹر��������е�adb.exe & taskkill /f /im adb.exe & echo %date:~0,10% %time% adb.exe is killed successfully>>debug\log.txt & goto main1
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
echo. �״�ʹ�ã������Զ���װ���������Ժ��벻Ҫ�رմ���
echo. 
echo. ��װ�����п��ܻᵯ����ȫ��ʾ��������ʼ�հ�װ���������������
Rd "%WinDir%\system32\test_permissions" >NUL 2>NUL
Md "%WinDir%\System32\test_permissions" 2>NUL||(echo. &echo. ��װʧ�ܣ���ȡ����ԱȨ��ʧ�ܣ���رմ��ں�ͨ���Ҽ��˵���ѡ���Թ���Ա������С����ԡ�&&Pause >nul&&Exit)
if exist "%WinDir%\SysWOW64" goto DR2
echo.
echo. ���ڴ���1/3��
tools\DPInst.exe /PATH "%~dp0tools\Driver1" /F /LM /SW /SA
echo. ���ڴ���2/3��
tools\DPInst.exe /PATH "%~dp0tools\Driver2" /F /LM /SW /SA
echo. ���ڴ���3/3��
echo  Done by MTools-R V2.8.2 X86 %date:~0,10% %time%>%WinDir%\Drv-status.txt
echo %date:~0,10% %time% installing drivers 86 successfully>>debug\log.txt
goto main1
:DR2
%~d0
cd %~dp0
echo.
echo. ���ڴ���1/3��
tools\DPInst64.exe /PATH "%~dp0tools\Driver1" /F /LM /SW /SA
echo. ���ڴ���2/3��
tools\DPInst64.exe /PATH "%~dp0tools\Driver2" /F /LM /SW /SA
echo. ���ڴ���3/3��
echo  Done by MTools-R V2.8.2 X64 %date:~0,10% %time%>%WinDir%\Drv-status.txt
echo %date:~0,10% %time% installing drivers 64 successfully>>debug\log.txt
goto main1
:C
echo.
echo.  ��⵽�ؼ��ļ���ʧ�����Ų�ѹ�������ļ��Ƿ�ȫ����ѹ
pause >nul
exit
