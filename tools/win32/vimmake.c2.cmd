@echo off
set PATH=d:\dev\mingw64\bin;$PATH

REM cd /D "%VIM_FILEDIR%"

d:\dev\mingw64\bin\gcc -Wall -O3 "%VIM_FILEPATH%" -o "%VIM_FILEDIR%/%VIM_FILENOEXT%.exe" -lwinmm -lstdc++ -lws2_32 -static -mavx
rem d:\dev\mingw64\bin\gcc --version



