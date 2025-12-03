@echo off
if "%~1"=="" (
  for /L %%x in (1,1,9) do set /p="0%%x/25	"<nul & call squish "python d0%%x.py"
  for /L %%x in (10,1,25) do set /p="%%x/25	"<nul & call squish "python d%%x.py"
) else ( set /p="%~1	"<nul & call squish "python d%~1.py"
)
