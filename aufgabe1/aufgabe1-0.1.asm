;-----------------------------------------------------
; PROGRAM:		Flag
; DESCRIPTION:	Display the flag of Switzerland
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK 1.5 (DOS)
; VERSION:		0.1
;-----------------------------------------------------

CPU 8086

SEGMENT DATA USE16
	; SWITZERLAND FLAG
	pic1:	times 25	dw	0x4020	; rot
			times 30	dw	0x7020	; grau
			times 25	dw	0x4020	; rot
	pic2:	times 80	dw	0x7020	; grau


SEGMENT STACK STACK USE16
	stack:	resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov ax, 0xB800				; Adresse des Videospeichers
	mov es, ax

	cld							; Direction-Flag loeschen
	mov di, 0x0000				; Offset des Videospeichers

	; FIRST LOOP - TOP OF THE FLAG
	mov bx, 8					; 8 mal 1 Zeile schreiben
.loop1:
	mov si, pic1				; Offset des Bildanfangs
	mov cx, 1*80				; 1 Zeile ...
	rep movsw					; ... kopieren
	dec bx
	jnz .loop1

	; SECOND LOOP - MIDDLE OF THE FLAG
	mov bx, 8
.loop2:
	mov si, pic2
	mov cx, 1*80
	rep movsw
	dec bx
	jnz .loop2

	; THIRD LOOP - BOTTOM OF THE FLAG
	mov bx, 8
.loop3:
	mov si, pic1
	mov cx, 1*80
	rep movsw
	dec bx
	jnz .loop3


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
