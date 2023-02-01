@echo off
for /L %%x IN (1,1,9) do echo "" & echo "Day %%x" & Rscript d0%%x.R
for /L %%x IN (10,1,25) do echo "" & echo "Day %%x" & Rscript d%%x.R
