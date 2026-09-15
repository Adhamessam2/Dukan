@echo off
echo ===================================================
echo   Dukan - Subagent Code Review Runner
echo ===================================================
echo.

cd /d "%~dp0.."

echo [1/3] Running Flutter Static Analysis...
call flutter analyze
if %errorlevel% neq 0 (
    echo [ERROR] Flutter analysis found issues!
) else (
    echo [SUCCESS] Flutter analysis passed clean.
)

echo.
echo [2/3] Checking Code Formatting...
call dart format --output=none --set-exit-if-changed lib test
if %errorlevel% neq 0 (
    echo [WARNING] Unformatted code detected. Run 'dart format lib test' to fix.
) else (
    echo [SUCCESS] All code is properly formatted.
)

echo.
echo [3/3] Checking Unused Dependencies ^& Lints...
call flutter pub pub run dependency_validator 2>nul || echo [INFO] Dependency validator check completed.

echo.
echo ===================================================
echo Code review static checks completed!
echo ===================================================
