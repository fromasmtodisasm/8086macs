;-----------------------------------------------------
; PROGRAM:		Processcontrol
; DESCRIPTION:	Emulating an process of a control
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

%include "stdio.mac"
%include "string.mac"
%include "type.mac"


CPU 8086

SEGMENT DATA USE16
	msg_input:	db		"Binaerzahl als String: $"
	msg_ascii:	db		"Binaerzahl als integer: $"
	error:		db		"Keine Binaerzahl!$"
	input:		db		9
				resb	1
				times	10 db 0
	status:		db		"Bit $"


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	print msg_input		; request user interaction
	scan input			; read user input

	isbin input+2		; does the string only contain 0, 1
	cmp bx, 0			; bx == 0?
	je nobin			; yes? print error
	newline				; print a 'LF' (linefeed)

	binstrint input+2	; convert string of 1, 0 to an 2 byte int value
	print msg_ascii
	printc bl			; print the lower byte of the int value
	newline

	strlen input+2		; what's the length of the string in cx
	mov si, input+2		; si points to first byte of string
loop:
	print status		; print "Bit "
	add cx, 0x30		; content of cx as ascii
	printc cl			; print the position of the bit
	sub cx, 0x30		; content of cx as value
	printc ":"
	printc " "
	printc [si]			; print bit where si points to as representation ...
	newline				; ... of the status.
	cmp cx, 1			; was it the last 0, 1?
	je exit				; yes? exit ...
	dec cx				; ... otherwise decrement cx ...
	inc si				; ... and increment si
	jmp loop			; repeat


nobin:
	newline
	print error
	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
