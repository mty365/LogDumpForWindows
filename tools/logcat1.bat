@echo off
echo.
echo. �������logcat����Լ��Ҫ20s����ɺ���Զ��رոô��ڣ��벻Ҫ�ֶ��رգ��������豸�����ȶ�����ĻΪ�����ѽ���״̬
ping -n 10 127.1>nul
echo.
echo. ����Ҫ10s
ping -n 5 127.1>nul
echo.
echo. ����Ҫ5s
ping -n 5 127.1>nul
taskkill /f /im adb.exe
exit