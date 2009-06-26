;-----------------------------------------------------
; PROGRAM:		FunctionCalling
; DESCRIPTION:	Call functions instead of macros
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

CPU 8086

SEGMENT DATA USE16
	msg:	db		"Hello World!$"
	char:	db		0x00
	input:	db		11
			resb	1
			times	11 db 0
	length:	times	10 db 0
	ascii:	db		11
			resb	1
			times	11 db 0
	lint:	dd 		0


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
	%include "stdio.mac"
	%include "new_string.mac"

..start:

	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax
	

	; DOS - WRITE STRING
	mov ax, msg
	push ax
	call printnl
	pop ax

	mov ax, input
	push ax
	call scan
	pop ax

	call newline

	mov bx, input
	add bx, 2
	push ax
	push dx
	push bx
	call atoi
	pop bx
	pop dx
	pop ax

	mov [lint], ax
	mov [lint+2], dx

;	push ax
;	call putc
;	pop ax

	push ax
	push dx
	mov bx, ascii
	add bx, 2
	push bx
	call itoa
	pop bx
	pop dx
	pop ax

	mov bx, ascii
	add bx, 2
	push bx
	call printnl
	pop bx



	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
