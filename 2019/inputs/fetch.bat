@echo off
if "%~1"=="" (
  echo Specify day: 1-25
  exit /b 1
)

if "%AOC_SESSION_TOKEN%"=="" (
  echo AOC_SESSION_TOKEN is not set. Please set it.
  exit /b 1
)
echo Fetching AoC 2019, day %~1 to input_%~1.txt
curl -s --fail --cookie "session=%AOC_SESSION_TOKEN%" "https://adventofcode.com/2019/day/%~1/input" -o input_%~1.txt
