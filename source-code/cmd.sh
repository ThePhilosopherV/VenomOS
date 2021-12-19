nasm bootsec.asm -fbin && nasm filetable.asm -fbin && nasm kernel.asm -fbin && cat bootsec filetable kernel > os.bin && qemu-system-x86_64 -fda os.bin 
