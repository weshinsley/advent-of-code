@echo off
if "%~1"=="" (
  for /L %%x in (1,1,9) do (echo %%x/25) & javac d0%%x/puzzle.java
  for /L %%x in (10,1,25) do (echo %%x/25) & javac d%%x/puzzle.java
) else ( echo %~1 & javac d%~1/puzzle.java
)
