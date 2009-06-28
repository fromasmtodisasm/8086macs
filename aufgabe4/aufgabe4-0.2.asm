;-----------------------------------------------------
; PROGRAM:		PARTEI
; DESCRIPTION:	Balkendiagramm einer Wahl
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.2
;-----------------------------------------------------

%include "stdio.mac"
%include "stdlib.mac"
%include "string.mac"

CPU 8086

%define MAX 0x06
%define ACT 0x01
%define TIM	0x07

SEGMENT DATA USE16
	msg_partei1:		db		"Stimmen Partei 1: $"
	msg_partei2:		db		"Stimmen Partei 2: $"
	msg_partei3:		db		"Stimmen Partei 3: $"
	msg_partei4:		db		"Stimmen Partei 4: $"
	msg_partei_ges:		db		"Stimmen insgesamt: $"
	partei1_ascii:		db		MAX
						resb	ACT
						times	TIM db 0
	partei2_ascii:		db		MAX
						resb	ACT
						times	TIM db 0
	partei3_ascii:		db		MAX
						resb	ACT
						times	TIM db 0
	partei4_ascii:		db		MAX
						resb	ACT
						times	TIM db 0
	partei_ascii:		times	TIM db 0
	error_not_numeric:	db	"ERROR: Eine der Eingaben ist keine Ziffer!$"
	error_overflow:		db	"ERROR: Die Anzahl der Gesamtstimmen ist "
						db	"groesser als 65535!$"
	partei1_dec:		dw		0
	partei2_dec:		dw		0
	partei3_dec:		dw		0
	partei4_dec:		dw		0
	partei_dec:			dw		0


SEGMENT STACK STACK USE16
	stack:		resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	; INPUT - GET VOICES FOR EVERY PARTY
	mov cx, 4
	mov si, msg_partei1
	mov di, partei1_ascii
.loop0:
	push si
	call print
	pop si
	add si, 19

	push di
	call scan
	pop di
	add di, 9
	
	call newline
	loop .loop0

	; PROCESSING - CONVERT USER INPUT TO INTEGER
	mov cx, 4
	mov si, partei1_ascii+2
	mov di, partei1_dec
.loop1:
	push ax
	push si
	call atoi
	pop si
	pop ax

	cmp ax, -1
	je .not_numeric

	mov [di], ax
	add si, 9
	add di, 2
	loop .loop1

	; PROCESSING - SUM EACH VOICES
	mov cx, 4
	mov si, partei1_dec
	xor ax, ax
.loop2:
	add ax, [si]
	jc .overflow
	add si, 2
	loop .loop2

	mov di, partei_dec
	mov [di], ax

	; PROCESSING - CONVERT SUM TO ASCII
	mov ax, [partei_dec]
	mov di, partei_ascii
	push ax
	push di
	call itoa
	pop di
	pop ax

	; OUTPUT - PRINT SUM OF VOICES
	mov di, partei_ascii
	push di
	call printnl
	pop di

	jmp exit

.not_numeric:
	mov ax, error_not_numeric
	push ax
	call printnl
	pop ax

	jmp exit

.overflow:
	mov ax, error_overflow
	push ax
	call printnl
	pop ax


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
