;-----------------------------------------------------
; PROGRAM:		Template
; DESCRIPTION:	Simple template printing "Hello World"
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

CPU 8086

SEGMENT DATA USE16
	msg:	db		"Hello World!$"


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	; DOS - WRITE STRING
	mov ah, 0x09
	mov dx, msg
	int 0x21


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
