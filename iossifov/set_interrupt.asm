;-----------------------------------------------------
; PROGRAM:		Interrupts
; DESCRIPTION:	Register a new ISR for divide by zero.
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

CPU 8086

%include "stdio.mac"
%include "stdlib.mac"

SEGMENT DATA USE16
	msg:	db		"Hello ...$"
	div_0:	db		"Division durch 0!$"
	reg_bx:	times	6 db 0
	reg_es:	times	6 db 0


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
div_int:
	mov ax, div_0
	push ax
	call printnl
	pop ax

	iret


..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	; SALUT
	mov ax, msg
	push ax
	call printnl
	pop ax

	; REGISTER NEW ISR
	push ds
	mov ax, CODE
	mov ds, ax
	mov ax, 0x2500
	mov dx, div_int
	int 0x21			; ds:dx -> new isr
	pop ds

	; EXPLICIT DIVIDE BY ZERO
	mov bx, 0
	mov ax, 5
	div bl

	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
