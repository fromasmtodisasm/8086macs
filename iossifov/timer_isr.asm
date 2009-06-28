;-----------------------------------------------------
; PROGRAM:		Interrupts
; DESCRIPTION:	Register a new ISR for timer interrupt.
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
	timer:	db		"Timer$"
	hour:	times	6 db 0
	min:	times	6 db 0


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
timer_int:
	mov ax, "T"			; ds seems to point to something curious ...
	push ax				; ... so we use putc, because it allows immeadiate
	call putc			; ... value definition.
	pop ax

	mov ax, 0x0A
	push ax
	call putc
	pop ax

	mov ax, 0x0D
	push ax
	call putc
	pop ax

	iret

timer_int_new:
	mov ah, 0x2C		; system time
	int 0x21

	mov bx, ":"
	mov al, ch
	xor ch, ch
	xor ah, ah

	add al, 0x30		; this won't work to represent ascii. value ...
	add cl, 0x30		; ... is interger. we need itoa!

	push ax
	call putc
	pop ax

	push bx
	call putc
	pop bx

	push cx
	call putc
	pop cx

	mov dx, 0x0A
	push dx
	call putc
	pop dx
	mov dx, 0x0D
	push dx
	call putc
	pop dx

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
	mov ax, 0x251C		; 1C is ISR for timer
	mov dx, timer_int
	int 0x21			; ds:dx -> new isr
	pop ds

.loop:
;	mov ah, 0x07
;	int 0x21
;	cmp al, 0x1B
;	je exit
	jmp .loop

	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
