;-----------------------------------------------------
; PROGRAM:		PARTEI
; DESCRIPTION:	Balkendiagramm einer Wahl
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.1
;-----------------------------------------------------

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
	stack:		resb	1024


SEGMENT CODE USE16
%include "stdio.mac"
%include "string.mac"
%include "type.mac"
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	; INPUT
	mov 	cx, 4
	mov		dx, msg_partei1
	mov		di, partei1_ascii
.loop_in:
	call	print
	scan	di
	newline

	%ifdef DEBUG
		add		di, 2				; DEBUG - 2 to point to the string.
		print	di					; DEBUG - Print it.
		newline
	%endif

	add		dx, 19

	%ifdef DEBUG
		add		di, 7				; DEBUG - We need to point 9b further.
	%else
		add		di, 9
	%endif

	loop	.loop_in

	; PROCESSING - CONVERT INPUT
	mov		cx, 4
	mov		si, partei1_ascii+2
	mov		di, partei1_dec
.loop_p0:
	dedu	si
	cmp		ax, -1
	je		.error_not_numeric
	mov		[di], ax

	%ifdef DEBUG
		printc	[di]				; DEBUG - If string converted correctly
	%endif							;		- and the entered number is
									;		- 33-126 there should be an
									;		- ascii char.
	add		si, 9
	add		di, 2
	loop	.loop_p0

	; PROCESSING - SUM
	xor 	ax, ax
	mov 	cx, 4
	mov 	si, partei1_dec
.loop_p1:
	add 	ax, [si]
	jc 		.error_overflow
	add 	si, 2
	loop	.loop_p1

	%ifdef DEBUG
		printc	al					; DEBUG - If sum 33-126 there should be
	%endif							;		- an ascii char.

	mov [partei_dec], ax
	dude ax, partei_ascii

	; OUTPUT - SUM

	mov		dx, msg_partei_ges
	call	print
	mov		dx, partei_ascii
	call	printnl

	jmp		exit

.error_not_numeric:
;	printnl error_not_numeric
	jmp		exit

.error_overflow:
;	printnl error_overflow


	; DOS - RETURN
exit:
	mov ah, 0x4C
	int 0x21
