@echo off
set PATH=d:\dev\mingw64\bin;$PATH

cd /D "%VIM_FILEDIR%"

d:\dev\mingw64\bin\gcc -Wall -O3 -S "%VIM_FILENAME%" 
rem d:\dev\mingw64\bin\gcc --version




