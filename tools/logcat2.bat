@echo off
echo.
echo. �������logcat����Լ��Ҫ1���ӣ����ظ����Ը��������������⣬ʱ�䵽����Զ��رոô��ڣ��벻Ҫ�ֶ��رգ��������豸�����ȶ�����ĻΪ�����ѽ���״̬
ping -n 35 127.1>nul
echo.
echo. ����Ҫ30s
ping -n 20 127.1>nul
echo.
echo. ����Ҫ10s
ping -n 10 127.1>nul
taskkill /f /im adb.exe
exit