@echo off
setlocal enabledelayedexpansion

title 亚托莉 QQ 机器人 · 一键安装
color 0B

echo ============================================================
echo    亚托莉 QQ 机器人 - 一键安装脚本
echo    (创建虚拟环境 + 安装依赖 + 生成 .env + 环境自检)
echo ============================================================
echo.

REM 切换到脚本所在目录（项目根目录）
cd /d "%~dp0"

echo [1/5] 检查 Python ...
where python >nul 2>nul
if errorlevel 1 (
    echo    [错误] 没有找到 python，请先安装 Python 3.11+ 并勾选 "Add to PATH"
    pause
    exit /b 1
)

for /f "delims=" %%v in ('python --version 2^>^&1') do set PYVER=%%v
echo    检测到: !PYVER!
echo.

echo [2/5] 创建虚拟环境 .venv ...
if exist ".venv\Scripts\python.exe" (
    echo    已存在，跳过创建。
) else (
    python -m venv .venv
    if errorlevel 1 (
        echo    [错误] 创建虚拟环境失败
        pause
        exit /b 1
    )
    echo    虚拟环境创建完成。
)
echo.

echo [3/5] 安装依赖 (requirements.txt) ...
".venv\Scripts\python.exe" -m pip install --upgrade pip
".venv\Scripts\python.exe" -m pip install -r requirements.txt
if errorlevel 1 (
    echo    [警告] 依赖安装可能不完整，请检查上方报错
    echo    若为网络问题可重试本脚本。
)
echo.

echo [4/5] 生成 .env ...
if exist ".env" (
    echo    .env 已存在，保留现有配置。
) else (
    copy ".env.example" ".env" >nul
    echo    已从 .env.example 生成 .env
    echo    请用记事本打开 .env，把 BOT_QQ 改成你的机器人 QQ 号。
)
echo.

echo [5/5] 运行环境自检 ...
".venv\Scripts\python.exe" tools\check_env.py

echo.
echo ============================================================
echo    安装步骤完成！
echo    接下来：
echo    1. 编辑 .env，填写 BOT_QQ（机器人 QQ 号）
echo    2. 安装 NapCat 并登录机器人 QQ（见 安装指引.txt）
echo    3. 启动：".venv\Scripts\python.exe -m atri_qq_bot"
echo ============================================================
echo.
pause
