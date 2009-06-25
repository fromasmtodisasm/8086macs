;-----------------------------------------------------
; PROGRAM:		Flag
; DESCRIPTION:	Display the flag of Switzerland
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK 1.5 (DOS)
; VERSION:		0.2
;-----------------------------------------------------

%include "text_graphics.mac"

CPU 8086

SEGMENT DATA USE16


SEGMENT STACK STACK USE16
		resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax

	rect 0,0,80,24,0x4020
	rect 25,0,30,24,0x7020
	rect 0,8,80,8,0x7020


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
