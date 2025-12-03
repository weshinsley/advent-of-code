@echo off
setlocal enabledelayedexpansion

set "output="
for /f "delims=" %%A in ('%1') do (
    if defined output (
        set "output=!output!	%%A"
    ) else (
        set "output=%%A"
    )
)

echo !output!
@echo off