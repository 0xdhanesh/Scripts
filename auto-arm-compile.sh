#!/bin/bash

ARCH=$(uname -m)
OUT_DIR="${ARCH}_Build"
mkdir -p "$OUT_DIR"
echo "Detected architecture: ${ARCH}"
echo "Output folder: ${OUT_DIR}"

for FILE in *.c; do
    BASENAME=$(basename "$FILE" .c)
    echo "Processing $BASENAME.c ..."

    if [[ "$ARCH" == "aarch64" ]]; then
        # 64-bit (Native)
        gcc -fno-stack-protector -z execstack -no-pie -Wl,-z,norelro -o "$OUT_DIR/64bit_InSecure_${BASENAME}" "$FILE"
        gcc -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$OUT_DIR/64bit_Secure_${BASENAME}" "$FILE"

        # Optional: 32-bit cross-compile if toolchain exists
        if command -v arm-linux-gnueabihf-gcc >/dev/null 2>&1; then
            arm-linux-gnueabihf-gcc -fno-stack-protector -z execstack -no-pie -Wl,-z,norelro -o "$OUT_DIR/32bit_InSecure_${BASENAME}" "$FILE"
            arm-linux-gnueabihf-gcc -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$OUT_DIR/32bit_Secure_${BASENAME}" "$FILE"
        else
            echo "Skipping 32-bit build — arm-linux-gnueabihf-gcc not found"
        fi

    elif [[ "$ARCH" == "armv7l" ]]; then
        # 32-bit only (Native)
        gcc -fno-stack-protector -z execstack -no-pie -Wl,-z,norelro -o "$OUT_DIR/32bit_InSecure_${BASENAME}" "$FILE"
        gcc -fstack-protector-all -z noexecstack -fPIE -pie -Wl,-z,relro,-z,now -s -o "$OUT_DIR/32bit_Secure_${BASENAME}" "$FILE"

    else
        echo "Unsupported ARM architecture: $ARCH"
    fi
done

echo "Compilation complete. Check the folder: ${OUT_DIR}"

