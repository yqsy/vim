@echo off
set PATH=d:\dev\mingw64\bin;$PATH

cd /D "%VIM_FILEDIR%"

d:\dev\mingw64\bin\gcc -Wall -O3 "%VIM_FILENAME%" -o "%VIM_FILENOEXT%.exe" -lwinmm -lstdc++ -lws2_32 -static
rem d:\dev\mingw64\bin\gcc --version



