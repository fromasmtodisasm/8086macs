A_SRC="boot.asm"
C_SRC="kernel.c"
OBJ="boot.o kernel.o"
EXE="kernel.elf32"

nasm -felf32 -oboot.o $A_SRC
gcc -m32 -c -okernel.o $C_SRC
ld -melf_i386 -Ttext 0x100000 -o$EXE $OBJ
