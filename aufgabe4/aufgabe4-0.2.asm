;-----------------------------------------------------
; PROGRAM:		PARTY
; DESCRIPTION:	Bar chart of an election.
; AUTHOR:		Alexander Meinke <ameinke@online.de>
; LICENCE:		Public Domain
; ASSEMBLER:	NASM 2.05.01
; LINKER:		ALINK (DOS)
; VERSION:		0.2
;-----------------------------------------------------

%define MAX 0x06
%define ACT 0x01
%define TIM	0x07

%define DOS

%include "stdio.mac"
%include "stdlib.mac"
%include "string.mac"
%include "math.mac"
%include "text_graphics.mac"

CPU 8086

SEGMENT DATA USE16
	msg_partei1:		db		"Stimmen Partei 1: $"
	msg_partei2:		db		"Stimmen Partei 2: $"
	msg_partei3:		db		"Stimmen Partei 3: $"
	msg_partei4:		db		"Stimmen Partei 4: $"
	msg_partei:			db		"Stimmen insgesamt: $"

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

	partei1_dec:		dw		0
	partei2_dec:		dw		0
	partei3_dec:		dw		0
	partei4_dec:		dw		0
	partei_dec:			dw		0
	
	partei1_per:		times	TIM db 0
	partei2_per:		times	TIM db 0
	partei3_per:		times	TIM db 0
	partei4_per:		times	TIM db 0

	partei1_bar:		db		0
	partei2_bar:		db		0
	partei3_bar:		db		0
	partei4_bar:		db		0

	error_not_numeric:	db	"ERROR: Eine der Eingaben ist keine Ziffer!$"
	error_overflow:		db	"ERROR: Die Anzahl der Gesamtstimmen ist "
						db	"groesser als 65535!$"
	error_null:			db	"ERROR: Die Anzahl der Gesamtstimmen ist 0!$"


SEGMENT STACK STACK USE16
	stack:		resb	512


SEGMENT CODE USE16
..start:
	; INIT SEGMENTS
	mov ax, DATA
	mov ds, ax
	mov es, ax

	; OUTPUT - CLEAR SCREEN
;	call cls
	mov cx, 24
.loop0:
	call newline
	loop .loop0

	xor dx, dx
	mov ah, 0x02
	int 0x10

	; INPUT - GET VOICES FOR EACH PARTY
	mov cx, 4
	mov si, msg_partei1
	mov di, partei1_ascii
.loop1:
	push si
	call print
	pop si
	add si, 19

	push di
	call scan
	pop di
	add di, 9
	
	call newline
	loop .loop1

	; PROCESSING - CONVERT USER INPUT TO INTEGER
	mov cx, 4
	mov si, partei1_ascii+2
	mov di, partei1_dec
.loop2:
	push ax
	push si
	call atoi
	pop si
	pop ax

	jc .not_numeric

	mov [di], ax
	add si, 9
	add di, 2
	loop .loop2

	; PROCESSING - SUM EACH VOICES
	mov cx, 4
	mov si, partei1_dec
	xor ax, ax
.loop3:
	add ax, [si]
	jc .overflow
	add si, 2
	loop .loop3

	mov di, partei_dec
	mov [di], ax
	cmp ax, 0
	je .null

	; PROCESSING - CONVERT SUM TO ASCII
	mov ax, [partei_dec]
	mov di, partei_ascii
	push ax
	push di
	call itoa
	pop di
	pop ax

	; OUTPUT - PRINT SUM OF VOICES
	mov di, msg_partei
	push di
	call print
	pop di

	mov di, partei_ascii
	push di
	call printnl
	pop di

	; PROCESSING - CALCULATE PERCENTAGE OF EACH PARTY
	mov si, partei1_dec
	mov di, partei_dec
	mov cx, 5
	mov bx, partei1_per
.loop4:
	mov ax, [si]
	mov dx, [di]
	push ax
	push dx
	push cx
	push bx
	call percent
	add sp, 8
	add si, 2
	add bx, 7
	cmp si, partei4_dec+2
	jne .loop4


	; PROCESSING - CALCULATE LENGTH OF EACH BAR
	mov si, partei1_per
	mov cx, 4
	mov bh, 6
	mov bl, 0
	mov dh, 0x1F
	mov dl, " "
.loop5:
	push ax
	push si
	call atoi
	pop si
	pop ax

	push bx
	mov bx, 80
	mul bl
	pop bx

	push dx
	push bx
	xor dx, dx
	mov bx, 100
	div bx
	pop bx
	pop dx

	; OUTPUT - DRAW BAR OF PARTY
	xchg ah, al
	mov al, 3
	push bx
	push ax
	push dx
	call draw_rect
	pop dx
	pop ax
	pop bx

	add si, 7
	add bh, 3
	add dh, 0x10
	loop .loop5

	; OUTPUT - PERCENTAL OF EACH PARTY
	mov si, partei1_per
	mov cx, 4
	mov ah, 7
	mov al, 0
.loop6:
	push ax
	push si
	call printxy
	pop si
	pop ax

	push ax
	add al, 6
	mov bx, "%"
	push ax
	push bx
	call putcxy
	pop bx
	pop ax
	pop ax

	add si, 7
	add ah, 3
	loop .loop6

	jmp exit

	; ERROR - ONE OF THE USERINPUT IS NOT NUMERIC
.not_numeric:
	mov ax, error_not_numeric
	push ax
	call printnl
	pop ax
	jmp exit

	; ERROR - SUM OF VOICES IS GREATER THAN 65535
.overflow:
	mov ax, error_overflow
	push ax
	call printnl
	pop ax
	jmp exit
	
	; ERROR - SUM OF VOICES IS 0
.null:
	mov ax, error_null
	push ax
	call printnl
	pop ax


	; DOS - RETURN
exit:
	mov cx, 14
.loop6:
	call newline
	loop .loop6

	mov ah, 0x4C
	int 0x21
