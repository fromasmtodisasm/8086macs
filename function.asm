;-----------------------------------------------------
; PROGRAM:		FunctionCalling
; DESCRIPTION:	Call functions instead of macros
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

CPU 186

SEGMENT DATA USE16
	msg:	db		"Hello World!$"


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:
	%include "new_stdio.mac"
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	; DOS - WRITE STRING
	mov dx, msg
	call print

	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
