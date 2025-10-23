#!/bin/bash

# Compute the absolute path to the Compilers directory based on the script's location
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPILERS="${SCRIPT_DIR}/Compilers"

arch=$(uname -m)
os=$(uname -s)

case "$os" in
    "Linux"|"Darwin")
        case "$arch" in
            x86_64|amd64)
                echo "Detected Linux/macOS 64-bit."
                bash "${COMPILERS}/auto-compile.sh"
                ;;
            armv7l|armhf|armv6l)
                echo "Detected ARM 32-bit."
                bash "${COMPILERS}/auto-arm-compile.sh"
                ;;
            aarch64)
                echo "Detected ARM 64-bit."
                bash "${COMPILERS}/auto-arm-compile.sh"
                ;;
            *)
                echo "Unknown CPU architecture: $arch"
                ;;
        esac
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo "Detected Windows via Bash. Please run run_auto_compile.bat from CMD."
        ;;
    *)
        echo "Unknown OS: $os"
        ;;
esac
