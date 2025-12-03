@echo off
if "%~1"=="" (
  for /L %%x in (1,1,9) do set /p="0%%x/25	"<nul & Rscript d0%%x.R
  for /L %%x in (10,1,25) do set /p="%%x/25	"<nul & Rscript d%%x.R
) else ( set /p="%~1	"<nul & Rscript d%~1.R
)
