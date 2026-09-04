@echo off
setlocal

title 亚托莉 QQ 机器人 · 启动
color 0B

cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    echo [错误] 没有找到虚拟环境，请先运行 一键安装.bat
    pause
    exit /b 1
)

if not exist ".env" (
    echo [错误] 没有找到 .env，请先运行 一键安装.bat
    pause
    exit /b 1
)

echo ============================================================
echo    正在启动亚托莉主服务 ...
echo    监听: ws://127.0.0.1:8765/onebot
echo    管理: http://127.0.0.1:8787
echo    (Ctrl+C 可停止)
echo ============================================================
echo.

".venv\Scripts\python.exe" -m atri_qq_bot

pause
