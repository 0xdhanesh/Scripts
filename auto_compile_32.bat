@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Path to WinLibs MinGW-w64 32-bit GCC (DWARF)
set GCC32=C:\Users\mrd_p\Downloads\winlibs-i686-posix-dwarf-gcc-15.2.0-mingw-w64ucrt-13.0.0-r2\mingw32\bin\gcc.exe
set "OUT_DIR=Windows_Build_32"
mkdir "%OUT_DIR%"

echo Output folder: %OUT_DIR%
echo Using compiler: %GCC32%

for %%F in (*.c) do (
    set "NAME=%%~nF"
    echo.
    echo Building 32-bit: %%F ...

    REM 32-bit Insecure: No ASLR, DEP (NX), or SEH
    %GCC32% -m32 -fno-stack-protector -Wl,--disable-dynamicbase,--disable-nxcompat,--no-seh -o "%OUT_DIR%\32bit_InSecure_!NAME!.exe" "%%F"

    REM 32-bit Secure: ASLR, DEP/GS (to extent possible)
    %GCC32% -m32 -fstack-protector-all -fPIE -pie -s -Wl,--dynamicbase,--nxcompat -o "%OUT_DIR%\32bit_Secure_!NAME!.exe" "%%F"
)

echo.
echo All 32-bit builds complete! Files saved to %OUT_DIR%.
pause
