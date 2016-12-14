@ECHO OFF

if "%VIM_FILENAME%" == "" GOTO ERROR_NO_FILE

CD /D "%VIM_FILEDIR%"

if "%VIM_FILEEXT%" == ".c" GOTO RUN_MAIN
if "%VIM_FILEEXT%" == ".cpp" GOTO RUN_MAIN
if "%VIM_FILEEXT%" == ".cc" GOTO RUN_MAIN
if "%VIM_FILEEXT%" == ".cxx" GOTO RUN_MAIN

if "%VIM_FILEEXT%" == ".py" GOTO RUN_PY
if "%VIM_FILEEXT%" == ".pyw" GOTO RUN_PY

if "%VIM_FILEEXT%" == ".bat" GOTO RUN_CMD
if "%VIM_FILEEXT%" == ".cmd" GOTO RUN_CMD

if "%VIM_FILEEXT%" == ".js" GOTO RUN_NODE
if "%VIM_FILEEXT%" == ".pro" GOTO RUN_PROLOG


echo unsupported file type %VIM_FILEEXT%
GOTO END

:RUN_MAIN
"%VIM_FILENOEXT%"
GOTO END

:RUN_PY
python "%VIM_FILENAME%"
GOTO END

:RUN_CMD
cmd /C "%VIM_FILENAME%"
GOTO END

:RUN_NODE
node.exe "%VIM_FILENAME%"
GOTO END

:RUN_PROLOG
start d:\dev\swipl\bin\swipl-win.exe -s "%VIM_FILENAME%"
EXIT

:ERROR_NO_FILE
echo missing filename
GOTO END

:END

