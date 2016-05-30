@ECHO OFF

if "%VIM_FILENAME%" == "" GOTO ERROR_NO_FILE

SET GOROOT=d:\dev\go\go-1.6.2
d:\dev\go\go-1.6.2\bin\go build "%VIM_FILEPATH%"
    
GOTO END


:ERROR_NO_FILE
echo missing file name

:END



