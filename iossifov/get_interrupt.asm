;-----------------------------------------------------
; PROGRAM:		Interrupts
; DESCRIPTION:	Get address of an ISR (DOS 0x21)
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

	; GET CURRENT ADDRESS OF ISR 0x21
	mov ah, 0x35
	mov al, 0x21	; we want address of DOS ISR 0x21
	int 0x21		; es:bx -> current address of ISR 0x21

	mov si, reg_es
	push es
	push si
	call itoah		; convert es to hex ascii representation
	pop si
	pop es

	mov si, reg_bx
	push bx
	push si
	call itoah		; convert bx to hex ascii representation
	pop si
	pop bx

	mov si, reg_es
	push si
	call print		; print es address of ISR as hex
	pop si

	mov ax, ":"
	push ax
	call putc
	pop ax

	mov si, reg_bx
	push si
	call printnl	; print bx address of ISR as hex
	pop si

	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
