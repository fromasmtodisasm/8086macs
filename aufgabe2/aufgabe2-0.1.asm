;-----------------------------------------------------------
; PROGRAM:		Caesar-Chiff
; DESCRIPTION:	Uses the Caesar algorithm to en-/decode Text
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------------

%include "stdio.mac"
%include "string.mac"
%include "caesar.mac"

CPU 8086

SEGMENT DATA USE16
	msg:	db		"Wort eingeben (keine Sonderzeichen!): $"
	clear:	db		"Wort mit Kleinbuchstaben: $"
	secure:	db		"Wort verschluesselt: $"
	input:	db		255					; maximum chars to read
			resb	1					; chars actually read
			times 	255 db 0x00			; buffer itself


SEGMENT STACK STACK USE16
	stack:	resb	512
	output:	resb	255
	enc:	resb	255


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	print msg
	scan input
	newline
	strlower input+2
	print clear
	printnl input+2
	caesar_enc input+2, output
	strupper output
	print secure
	printnl output
	caesar_dec output, enc
	strlower enc
	print clear
	print enc


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
