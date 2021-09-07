@echo off
echo.
echo. 正在输出logcat，大约需要20s，完成后会自动关闭该窗口，请不要手动关闭，并保持设备连接稳定，屏幕为亮屏已解锁状态
ping -n 10 127.1>nul
echo.
echo. 还需要10s
ping -n 5 127.1>nul
echo.
echo. 还需要5s
ping -n 5 127.1>nul
taskkill /f /im adb.exe
exit