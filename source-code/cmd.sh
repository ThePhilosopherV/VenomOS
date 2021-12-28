#!/bin/bash
nasm bootsec.asm -fbin && nasm filetable.asm -fbin && nasm kernel.asm -fbin && nasm program.asm -fbin && cat bootsec kernel filetable program  > os.bin && qemu-system-x86_64  -fda os.bin 
