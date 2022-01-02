#!/bin/bash
nasm bootsec.asm -fbin  && 
nasm filetable.asm -fbin && 
nasm kernel.asm -fbin && 
nasm program.asm -fbin && 
nasm mce.asm -fbin && 
nasm editor.asm -fbin && 

cat bootsec kernel filetable program mce editor  > tmp.bin && 
dd if=/dev/zero of=os.bin bs=512 count=2880 && 
dd if=tmp.bin of=os.bin conv=notrunc && 
qemu-system-x86_64  -fda os.bin 
