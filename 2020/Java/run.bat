@echo off
if "%~1"=="" (
  for /L %%x in (1,1,9) do (echo %%x/25) & echo -- & java d0%%x/puzzle.java & echo.
  for /L %%x in (10,1,25) do (echo %%x/25) & echo -- & java d%%x/puzzle.java & echo.
) else ( echo %~1 & echo -- & java d%~1/puzzle.java & echo.
)
