;-----------------------------------------------------
; PROGRAM:		FunctionCalling
; DESCRIPTION:	Call functions instead of macros
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

%include "stdio.mac"
%include "stdlib.mac"
%include "string.mac"

CPU 8086

SEGMENT DATA USE16
	msg:	db		"Hello World!$"
	input:	db		6
			resb	1
			times	6 db 0
	ascii:	times	6 db 0
	int:	dw 		0


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:

	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	mov ax, msg
	push ax
	call printnl
	pop ax

;	mov si, msg
;	mov cx, 12
;.loop:
;	mov ax, [si]

;	push ax
;	call toupper
;	pop ax
;	push ax
;	call putc
;	pop ax
;	inc si
;	loop .loop

;	mov ax, input
;	push ax
;	call scan
;	pop ax

;	call newline

;	mov bx, input+2
;	push ax
;	push bx
;	call atoi
;	pop bx
;	pop ax

;	mov [int], ax

;	mov bx, ascii
;	push ax
;	push bx
;	call itoa
;	pop bx
;	pop ax

;	mov bx, ascii
;	push bx
;	call printnl
;	pop bx

	mov ah, 12
	mov al, 40
	mov bx, "X"
	push ax
	push bx
	call putcxy
	pop bx
	pop ax


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
