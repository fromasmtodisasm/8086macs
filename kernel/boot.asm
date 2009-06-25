;----------------------------------------------------------------------------
; PROGRAM:		Operating System Kernel
; DESCRIPTION:	Multiboot compilant elf32 Kernel that can be loaded by grub.
; VERSION:		0.1
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		GNU LD 2.19.51
;----------------------------------------------------------------------------

%include "stdio.mac"

CPU PRESCOTT
BITS 32
GLOBAL _start
EXTERN main


SEGMENT .multiboot align=4
	magic:			equ	0x1BADB002
	flags:			equ	0x00000000
multiboot:
	.magic			dd	magic
	.flags			dd	flags
	.checksum		dd	-(magic+flags)


SEGMENT .data
	msg0:			db "Hello World"
	msg:			db	'H',0x02
					db	'e',0x02
					db	'l',0x02
					db	'l',0x02
					db	'o',0x02
					db	' ',0x02
					db	'W',0x02
					db	'o',0x02
					db	'r',0x02
					db	'l',0x02
					db	'd',0x02
	invalue_str:	db	'I',0x02
					db	'n',0x02
					db	'p',0x02
					db	'u',0x02
					db	't',0x02
					db	':',0x02
					db	' ',0x02
	vendor_str:		db	'V',0x02
					db	'e',0x02
					db	'n',0x02
					db	'd',0x02
					db	'o',0x02
					db	'r',0x02
					db	':',0x02
					db	' ',0x02


SEGMENT .bss
	input_value:	resd	1
	vendor:			resd	3
	stack:			resb	512


SEGMENT .text
_start:

	cld
	mov esi, msg
	mov edi, 0x000B8000					; flat video mem address

	mov ecx, 0x00000016					; copy 22 times ...
	rep movsb							; ... a byte from [esi] to [edi]

	mov eax, 0x00000000
	cpuid

	mov esi, input_value				; store output of cpuid instruction
	mov [esi], eax						; max. input value for cpuid
	mov [esi+4], ebx					; Genu
	mov [esi+8], edx					; ineI
	mov [esi+12], ecx					; ntel

	mov edi, 0x000B80A0					; x = 0, y = 2
	mov esi, vendor_str
	mov ecx, 0x00000010
	rep movsb

	mov esi, vendor
	mov ecx, 0x0000000C
loop:
	movsb
	mov [edi], BYTE 0x02				; black / green
	inc edi
	cmp ecx, 0x00000000
	je invalue
	dec ecx
	jmp loop

invalue:
	mov edi, 0x000B8140					; x = 0, y = 3
	mov esi, invalue_str
	mov ecx, 0x0000000E
	rep movsb

	mov eax, [input_value]
	add al, 0x30
	add ah, 0x30
	mov [edi], ah
	mov [edi+1], BYTE 0x02
	mov [edi+2], al
	mov [edi+3], BYTE 0x02

	jmp main


exit:
	hlt
