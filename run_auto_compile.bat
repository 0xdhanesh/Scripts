@echo off
REM COMPILERS BASE DIRECTORY
set COMPILERS="C:\Users\mrd_p\Desktop\Codes\Compilers"

echo Running 64-bit Windows compile script...
call %COMPILERS%\auto_compile_64.bat

echo Running 32-bit Windows compile script...
call %COMPILERS%\auto_compile_32.bat

echo.
echo Both 32-bit and 64-bit compile scripts have finished.
pause
