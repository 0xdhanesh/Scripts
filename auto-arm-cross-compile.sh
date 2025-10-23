#!/bin/bash

TOOLCHAIN32=arm-linux-gnueabihf-gcc
TOOLCHAIN64=aarch64-linux-gnu-gcc
OUT_DIR="ARM_Build"
mkdir -p "$OUT_DIR"

echo "Using ARM cross compilers..."
for FILE in *.c; do
    BASENAME=$(basename "$FILE" .c)

    # 32-bit builds
    $TOOLCHAIN32 -fno-stack-protector -z execstack -no-pie -o "$OUT_DIR/32bit_InSecure_${BASENAME}" "$FILE"
    $TOOLCHAIN32 -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$OUT_DIR/32bit_Secure_${BASENAME}" "$FILE"

    # 64-bit builds
    $TOOLCHAIN64 -fno-stack-protector -z execstack -no-pie -o "$OUT_DIR/64bit_InSecure_${BASENAME}" "$FILE"
    $TOOLCHAIN64 -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$OUT_DIR/64bit_Secure_${BASENAME}" "$FILE"
done

