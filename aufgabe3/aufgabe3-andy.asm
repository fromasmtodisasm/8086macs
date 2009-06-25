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

%include "stdio.mac"

SEGMENT DATA USE16
	progname:	db "Geben Sie eine 8-Bit Zahl ein$",0
	eingabe:	db 		9
				resb	1
				times	10 db 0
	stringlnge:	dw 0						; In diesem Programm reicht db.

	bit1_1:		db "1-Motor an$"
	bit1_0:		db "0-Motor aus$"
	bit2_1:		db "1-Ampel ist gruen$"
	bit2_0:		db "0-Ampel ist rot$"
	bit3_1:		db "1-Der Wasserhahn laeuft$"
	bit3_0:		db "0-Der Wasserhahn laeuft nicht$"
	bit4_1:		db "1-Die Frau ist sexy$"
	bit4_0:		db "0-Die Frau ist NICHT sexy$"
	bit5_1:		db "1-Die Bibliothek hat geoeffnet$"
	bit5_0:		db "0-Die Bibliothek hat geschlossen$"
	bit6_1:		db "1-Ich kann Assembler$"
	bit6_0:		db "0-Ich kann kein Assembler$"
	bit7_1:		db "1-Die CPU rechnet richtig$"
	bit7_0:		db "0-Die CPU rechnet falsch$"
	bit8_1:		db "1-Die Schaltung arbeitet korrekt$"
	bit8_0:		db "0-Die Schaltung arbeitet falsch$"


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	mov cx, 25

schleife:
	newline
	loop schleife

	print progname
	newline
	scan eingabe
	mov cx, 8
	xor bl, bl
	xor al, al
	mov si, eingabe+2

schleife2:
	mov al, [si]
	sub al, 0x30
	shl bl, 1
	add bl, al
	inc si
	loop schleife2

;	ror bl, 1

newline
printc bl

bit1:
	rol bl, 1
	jc bit1_an
	jmp bit1_aus

bit1_an:
	newline
	print bit1_1
	jmp bit2

bit1_aus:
	newline
	print bit1_0
	jmp bit2

bit2:
	rol bl, 1
	jc bit2_an
	jmp bit2_aus

bit2_an:
	newline
	print bit2_1
	jmp bit3

bit2_aus:
	newline
	print bit2_0
	jmp bit3

bit3:
	rol bl, 1
	jc bit3_an
	jmp bit3_aus

bit3_an:
	newline
	print bit3_1
	jmp bit4

bit3_aus:
	newline
	print bit3_0
	jmp bit4

bit4:
	rol bl, 1
	jc bit4_an
	jmp bit4_aus

bit4_an:
	newline
	print bit4_1
	jmp bit5

bit4_aus:
	newline
	print bit4_0
	jmp bit5

bit5:
	rol bl, 1
	jc bit5_an
	jmp bit5_aus

bit5_an:
	newline
	print bit5_1
	jmp bit6

bit5_aus:
	newline
	print bit5_0
	jmp bit6

bit6:
	rol bl, 1
	jc bit6_an
	jmp bit6_aus

bit6_an:
	newline
	print bit6_1
	jmp bit7

bit6_aus:
	newline
	print bit6_0
	jmp bit7

bit7:
	rol bl, 1
	jc bit7_an
	jmp bit7_aus

bit7_an:
	newline
	print bit7_1
	jmp bit8

bit7_aus:
	newline
	print bit7_0
	jmp bit8

bit8:
	rol bl, 1
	jc bit8_an
	jmp bit8_aus

bit8_an:
	newline
	print bit8_1
	jmp exit

bit8_aus:
	newline
	print bit8_0
	jmp exit


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
