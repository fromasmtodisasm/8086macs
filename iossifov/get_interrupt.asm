;-----------------------------------------------------
; PROGRAM:		Interrupts
; DESCRIPTION:	Get address of an ISR (Divide by Zero)
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
	reg_bx:	times	6 db 0
	reg_es:	times	6 db 0


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
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

	; GET CURRENT ADDRESS OF ISR
	mov ah, 0x35
	int 0x21		; es:bx -> current address of ISR

	mov si, reg_bx
	push bx
	push si
	call itoa
	pop si
	pop bx

	mov si, reg_es
	push es
	push si
	call itoa
	pop si
	pop es

	mov si, reg_es
	push si
	call print
	pop si

	mov ax, ":"
	push ax
	call putc
	pop ax

	mov si, reg_bx
	push si
	call printnl
	pop si

	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
