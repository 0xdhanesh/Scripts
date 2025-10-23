#!/bin/bash

# 1. Detect architecture
ARCH=$(getconf LONG_BIT)
PLATFORM=$(uname -m)
FOLDER_NAME="linux_Build"
mkdir -p "$FOLDER_NAME"

echo "Detected architecture: ${ARCH}-bit (${PLATFORM})"
echo "Output folder: $FOLDER_NAME"

# 2. Find all .c files
C_FILES=$(find . -maxdepth 1 -type f -name "*.c")

# 3. Iterate and compile
for FILE in $C_FILES; do
    BASENAME=$(basename "$FILE" .c)
    echo "Compiling $BASENAME.c ..."

    # 32-bit Insecure
    gcc -m32 -no-pie -fno-stack-protector -z execstack -Wl,-z,norelro -o "$FOLDER_NAME/32bit_InSecure_${BASENAME}" "$FILE" 2>/dev/null

    # 32-bit Secure
    gcc -m32 -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$FOLDER_NAME/32bit_Secure_${BASENAME}" "$FILE" 2>/dev/null

    # 64-bit Insecure
    gcc -m64 -no-pie -fno-stack-protector -z execstack -Wl,-z,norelro -o "$FOLDER_NAME/64bit_InSecure_${BASENAME}" "$FILE" 2>/dev/null

    # 64-bit Secure
    gcc -m64 -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$FOLDER_NAME/64bit_Secure_${BASENAME}" "$FILE" 2>/dev/null
done

echo "Compilation complete. Output binaries saved to $FOLDER_NAME"

