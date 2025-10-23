@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Path to WinLibs MinGW-w64 64-bit GCC
set GCC64=C:\Users\mrd_p\Downloads\winlibs-x86_64-posix-seh-gcc-15.2.0-mingw-w64ucrt-13.0.0-r2\mingw64\bin\gcc.exe
set "OUT_DIR=Windows_Build_64"
mkdir "%OUT_DIR%"

echo Output folder: %OUT_DIR%
echo Using compiler: %GCC64%

for %%F in (*.c) do (
    set "NAME=%%~nF"
    echo.
    echo Building 64-bit: %%F ...

    REM 64-bit Insecure: No ASLR, DEP (NX), or SEH
    %GCC64% -m64 -fno-stack-protector -Wl,--disable-dynamicbase,--disable-nxcompat,--no-seh -o "%OUT_DIR%\64bit_InSecure_!NAME!.exe" "%%F"

    REM 64-bit Secure: ASLR, DEP/GS (to extent possible)
    %GCC64% -m64 -fstack-protector-all -fPIE -pie -s -Wl,--dynamicbase,--nxcompat -o "%OUT_DIR%\64bit_Secure_!NAME!.exe" "%%F"
)

echo.
echo All 64-bit builds complete! Files saved to %OUT_DIR%.
pause
