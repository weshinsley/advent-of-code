@echo off
for /L %%x in (1, 1, 9) do (
  echo Day %%x
  echo -----
  java d0%%x.wes
  echo.
)
for /L %%x in (10, 1, 19) do (
  echo Day %%x
  echo ------
  java d%%x.wes
  echo.
)