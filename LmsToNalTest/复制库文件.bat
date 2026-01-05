@echo off
REM 批处理脚本 - 复制 NAL_NL2_SDK 库文件
REM 使用方法: 双击此文件运行

echo 开始复制 NAL_NL2_SDK 库文件...

set "SOURCE_PATH=..\DCTestUniPlugin\DCTestUniPlugin\NAL_NL2_SDK"
set "DEST_PATH=LmsToNalTest\NAL_NL2_SDK"

if exist "%SOURCE_PATH%" (
    echo 源路径: %SOURCE_PATH%
    echo 目标路径: %DEST_PATH%
    
    if exist "%DEST_PATH%" (
        echo 目标路径已存在，正在删除旧文件...
        rmdir /s /q "%DEST_PATH%"
    )
    
    echo 正在复制文件...
    xcopy /E /I /Y "%SOURCE_PATH%" "%DEST_PATH%"
    
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ✅ 库文件复制完成!
        echo 目标路径: %DEST_PATH%
    ) else (
        echo.
        echo ❌ 复制失败，错误代码: %ERRORLEVEL%
        pause
        exit /b 1
    )
) else (
    echo.
    echo ❌ 错误: 找不到源路径 %SOURCE_PATH%
    echo 请确保 DCTestUniPlugin 项目存在且包含 NAL_NL2_SDK 文件夹
    pause
    exit /b 1
)

echo.
echo 下一步: 在 Xcode 中打开项目并按照 '项目创建指南.md' 配置项目
pause

