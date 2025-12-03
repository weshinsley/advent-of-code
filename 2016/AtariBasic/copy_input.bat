@echo off
for /L %%x in (1,1,9) do copy /y ..\inputs\input_%%x.txt d0%%x\INPUT.TXT >nul
for /L %%x in (10,1,25) do copy /y ..\inputs\input_%%x.txt d%%x\INPUT.TXT >nul
