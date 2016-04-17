@ECHO OFF

if "%VIM_FILENAME%" == "" GOTO ERROR_NO_FILE

CD /D "%VIM_FILEDIR%"

d:\dev\mingw\bin\gcc -Wall -O3 "%VIM_FILENAME%" -o "%VIM_FILENOEXT%" -lwinmm -lstdc++ -lgdi32 -lws2_32 -msse3

GOTO END


:ERROR_NO_FILE
echo missing file name

:END



