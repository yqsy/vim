@ECHO OFF

if "%VIM_FILENAME%" == "" GOTO ERROR_NO_FILE

CD /D "%VIM_FILEDIR%"

d:\dev\python25\python.exe d:\dev\mingw32\emake.py "%VIM_FILENAME%"

GOTO END


:ERROR_NO_FILE
echo missing file name

:END



