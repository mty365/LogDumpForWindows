@echo off
%~d0
cd %~dp0
echo. ���ڴ���1/3��
tools\DPInst64.exe /U "%~dp0tools\Driver1\android_winusb.inf" /F /SW
echo. ���ڴ���2/3��
tools\DPInst64.exe /U "%~dp0tools\Driver2\qcser.inf" /F /SW
echo. ���ڴ���3/3��
if exist %WinDir%\Drv-status.txt del %WinDir%\Drv-status.txt
echo. 
echo. ж�����
pause