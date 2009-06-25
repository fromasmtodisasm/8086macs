;------------------------------------------------------
; PROGRAM:		Processcontrol
; DESCRIPTION:	Emulating an process of a motor control
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.2
;------------------------------------------------------

%include "stdio.mac"
%include "string.mac"
%include "type.mac"


CPU 8086

; TODO
;	Save memory usage by padding all messages to the same length. So it
;	would not be necessary to calculate the length of each string.
SEGMENT DATA USE16
	msg_user:		db		"Information",0x0A
					db		"-----------",0x0A
					db		"Bit x: 1 / 0",0x0A,0x0A
					db		"Bit 0: Motor an / aus",0x0A
					db		"Bit 1: Motor links / rechts",0x0A
					db		"Bit 2: Laufgeschwindigkeit 1x / 2x",0x0A
					db		"Bit 3: Temperatur Ok / nicht Ok",0x0A
					db		"Bit 4: Kuehlfluessigkeit Ok / nicht Ok",0x0A
					db		"Bit 5: Oelstand Ok / nicht Ok",0x0A
					db		"Bit 6: Motorbremse an / aus",0x0A
					db		"Bit 7: Kraftstoffzufuhr Ok / nicht Ok",0x0A,0x0A
					db		"8 Ziffern, 0 oder 1. Erste Ziffer ist Bit 7: $"
	msg_ascii:		db		"Integer: $"
	error:			db		"Keine Binaerzahl!$"
	input:			db		9
					resb	1
					times	10 db 0
	status_true:	db		"Motor an$"						; Bit 0
					db		"Motor laeuft links$"			; Bit 1
					db		"1x Laufgeschwindigkeit$"		; Bit 2
					db		"Temperatur Ok$"				; Bit 3
					db		"Kuehlfluessigkeit Ok$"			; Bit 4
					db		"Oelstand Ok$"					; Bit 5
					db		"Motorbremse an$"				; Bit 6
					db		"Kraftstoffzufuhr Ok$"			; Bit 7
	status_false:	db		"Motor aus$"					; Bit 0
					db		"Motor laeuft rechts$"			; Bit 1
					db		"2x Laufgeschwindigkeit$"		; Bit 2
					db		"Temperatur nicht Ok$"			; Bit 3
					db		"Kuehlfluessigkeit nicht Ok$"	; Bit 4
					db		"Oelstand nicht Ok$"			; Bit 5
					db		"Motorbremse aus$"				; Bit 6
					db		"Kraftstoffzufuhr nicht Ok$"	; Bit 7
	int:			times 3 db 0
					db		"$"


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	print msg_user			; request user interaction
	scan input				; read user entered input

	isbin input+2			; does the string only contain 0, 1
	cmp bx, 0				; bx == 0 ...
	je nobin				; ... yes? print error
	newline					; print 2 times ...
	newline					; ... a 'LF' (linefeed)

	print msg_ascii			; print user information
	binstr2asciistr input+2, int	; ascii representation of bits
	print int				; print decimal value
	newline

	strlen input+2			; how many bits to check
	mov si, status_true		; bit is 'set messages'
	mov di, status_false	; bit is 'not set messages'
.loop:
	cmp cx, 0				; last bit reached ...
	je exit					; ... yes? exit

	ror bl, 1				; transfer lowest bit into carry flag ...
	jc .set					; ... is it set? yes, jump to 'set messages'

	printnl di				; print bit is not set message
	push cx					; save bits to check
	strlen di				; determine length of string where di points to
	add cx, 1				; 1 byte further, otherwise di points to "$"
	add di, cx				; message for next (not set) bit
	strlen si				; determine length of string where si points to
	add cx, 1				; 1 byte further, otherwise si points to "$"
	add si, cx				; message for next (set) bit
	pop cx					; restore bits to check
	dec cx					; decrement counter for bits to check
	jmp .loop				; repeat until cx == 0
.set:
	printnl si				; print bit is set message
	push cx					; save bits to check
	strlen di				; determine length of string where di points to
	add cx, 1				; 1 byte further, otherwise di points to "$"
	add di, cx				; message for next (not set) bit
	strlen si				; determine length of string where si points to
	add cx, 1				; 1 byte further, otherwise si points to "$"
	add si, cx				; message for next (set) bit
	pop cx					; restore bits to check
	dec cx					; decrement counter for bits to check
	jmp .loop				; repeat until cx == 0


nobin:
	newline					; print a 'LF' (linefeed)
	print error				; print error. combination of digits is illegal
	; DOS - RETURN
exit:
	mov ah, 0x4C			; return ...
	int 0x21				; ... to dos
