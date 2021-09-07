@echo off
PUSHD %~DP0 &TITLE CacheDump �汾��2.8.2
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
IF %ERRORLEVEL% EQU 0  echo.& echo %date:~0,10% %time% W:adb.exe is already running>>debug\log.txt & echo. ���ڹر��������е�adb.exe & taskkill /f /im adb.exe & echo %date:~0,10% %time% adb.exe is killed successfully>>debug\log.txt & goto main
:main
CLS
echo.
echo. ��ϵͳ���ֿ�������������ʱ�������������°汾�󣩣���ͨ���˹��ܻ�ȡ�ֻ�cacheĿ¼���ݣ���������ͽ������
echo.
echo. *�˹��ܽ����ڿ�������û�������Ӧ������Ա��������ʹ��
echo. *�˹��ܲ�������д���˷ǹٷ�Recovery���豸
echo.
echo. �Ⱦ�������׼����
echo. 1.�ֻ�������������������֮���޷��������������⣬��������ֺ�δ���й�������ݻ�ˢ���Ĳ���������ǳ���Ҫ��
echo. 2.�ֻ������ӵ�����
echo. 3.�ֻ����� Recovery ģʽ����������ע����ͨ���������¼�ѡ������С�����֡�ѡ��󣬵����Դ��ȷ��
echo. 4.ͨ�������߽��豸�͵��Խ�������
echo.
echo. ��ע��
echo. 1.�ֻ��ػ�״̬�»���Fastbootģʽ��ͬʱ����Դ��+�����ϼ����Խ��� Recovery ģʽ��
echo. 2.�ֻ���������������ֱ�Ӱ������Ͻ�Ҳ���Խ��� Recovery ģʽ
echo.
echo. ���������ʼ������־
echo %date:~0,10% %time% waiting for user to preess a key>>debug\log.txt
pause >nul
echo.
echo %date:~0,10% %time% waiting for user to int contact>>debug\log.txt
set /p Q= ������������ϵ��ʽ��������ɺ󰴻س�:
echo.
echo %date:~0,10% %time% log dump started>>debug\log.txt
echo. ���ڻ�ȡ��־...�뱣���豸�����ȶ�
tools\adb.exe pull /cache/ feedback\cache >debug\adb_tmp_.txt
tools\adb.exe pull /tmp/recovery.log feedback >debug\adb_tmp_.txt
findstr /c:"no devices/emulators found" debug\adb_tmp_.txt
IF %ERRORLEVEL% EQU 0 echo %date:~0,10% %time% W:warning in no devices found>>debug\log.txt & echo.& echo. ִ��ʧ�ܣ����������豸�������豸�����Լ��豸����ģʽ &echo. &echo. ���ܵ�ԭ��&echo. ���ȼ���豸�Ƿ������ӵ����ԣ��Ų���������ͨ�ԣ������豸���������ܷ񿴵���һ�Android Phone���豸�����û�У��������°�װ������&echo.&echo. �����Ų��豸�Ƿ���Recoveryģʽ�������Ѿ����롰����С�����֡�״̬&echo. & echo. �������������������־�Թ����� & pause >nul & goto D
findstr "error" debug\adb_tmp_.txt
IF %ERRORLEVEL% EQU 0 echo.& echo %date:~0,10% %time% W:warning in adb>>debug\log.txt & echo. ִ��ʧ�ܣ������豸�Ƿ����������������̨���г��������Ƿ�����ִ�У��Լ��豸�����Ƿ�ɿ� &echo. &echo. ���ܵ�ԭ��&echo. ���������ʱ�������Ų��Ƿ�����������ռ��USB�˿ڣ��Ƿ�������������ռ��adbָ��ͨ�������������������ǿͣadb.exe����һ�Σ��ڡ��豸������������鲢���ִ�й����У��豸����ͻȻ����������������Ų��豸�����ȶ��Լ�������ͻ�����Ƿ���ڡ�&echo.  & echo. �������������������־�Թ����� & pause >nul & goto D
if exist debug\adb_tmp_.txt del debug\adb_tmp_.txt
echo %date:~0,10% %time% pulling cache files successfully>>debug\log.txt
echo Time=%date:~0,10% %time%, >>feedback\summary.txt
echo.C=%Q% >>feedback\summary.txt
echo.
echo. ����ѹ����־...
tools\7za.exe a log\cache%date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%.zip feedback  >debug\logz.txt
findstr /c:"Everything is Ok" debug\logz.txt
IF %ERRORLEVEL% NEQ 0  echo.& echo %date:~0,10% %time% W:warning zipping files>>debug\log.txt & echo. �����ļ�ѹ��ʧ�� & echo. ����ϵ���߿�����Ա &echo. & echo. �������������������־�Թ����� & pause >nul & goto D
if exist feedback RD /q /s feedback & MD feedback & MD feedback\log_pro
echo %date:~0,10% %time% zipping cache files successfully>>debug\log.txt
echo.
echo. ��־��ȡ��ɣ��ѽ����ļ�����Ŀ¼���뽫�����ԡ�cache+��ǰʱ��.zip����ʽ���Ƶ��ļ�������Ӧ��Ա��
explorer log
echo. ��������˳�
pause >nul
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
goto main
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
goto main
:C
echo.
echo.  ��⵽�ؼ��ļ���ʧ�����Ų�ѹ�������ļ��Ƿ�ȫ����ѹ
pause >nul
exit
:D
if exist log\debug.zip del log\debug.zip
echo Time=%date:~0,10% %time%, >>debug\summary.txt
echo.C=%Q% >>debug\summary.txt
if exist %WinDir%\Drv-status.txt copy %WinDir%\Drv-status.txt debug
if exist %WinDir%\DPINST.LOG copy %WinDir%\DPINST.LOG debug
echo.
echo. ����ѹ����־...
tools\7za.exe a log\Debug.zip debug
if exist feedback RD /q /s feedback & MD feedback & MD feedback\log_pro
if exist debug RD /q /s debug & MD debug
echo.
echo. ��־��ȡ��ɣ��ѽ����ļ�����Ŀ¼���뽫Debug.zip������Ӧ��Ա��
explorer log
echo. ��������˳�
pause >nul
exit