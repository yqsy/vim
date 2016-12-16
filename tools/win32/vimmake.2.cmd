@ECHO OFF

if "%VIM_FILENAME%" == "" GOTO ERROR_NO_FILE

if "%VIM_FILEEXT%" == ".c" GOTO COMPILE_C
if "%VIM_FILEEXT%" == ".cc" GOTO COMPILE_C
if "%VIM_FILEEXT%" == ".cpp" GOTO COMPILE_C
if "%VIM_FILEEXT%" == ".h" GOTO COMPILE_C
if "%VIM_FILEEXT%" == ".cxx" GOTO COMPILE_C
if "%VIM_FILEEXT%" == ".erl" GOTO COMPILE_ERLANG

:COMPILE_C
REM CD /D "%VIM_FILEDIR%"
d:\dev\mingw32\bin\gcc -Wall -O3 -std=c++11 "%VIM_FILEPATH%" -o "%VIM_FILEDIR%/%VIM_FILENOEXT%" -lwinmm -lstdc++ -lgdi32 -lws2_32 -msse3 -static
GOTO END

:COMPILE_ERLANG
d:\dev\erl8.2\bin\erlc.exe -W -o "%VIM_FILEDIR%" "%VIM_FILEPATH%"
GOTO END

:ERROR_NO_FILE
echo missing file name

:END


