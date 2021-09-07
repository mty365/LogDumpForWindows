@echo off
echo.
echo. 正在输出logcat，大约需要1分钟，请重复尝试复现您遇到的问题，时间到后会自动关闭该窗口，请不要手动关闭，并保持设备连接稳定，屏幕为亮屏已解锁状态
ping -n 35 127.1>nul
echo.
echo. 还需要30s
ping -n 20 127.1>nul
echo.
echo. 还需要10s
ping -n 10 127.1>nul
taskkill /f /im adb.exe
exit