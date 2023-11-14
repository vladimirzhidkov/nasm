section .text
global _start
_start:

; ZF = 0 : AL + BL != 0
; ZF = 1 : AL + BL  = 0
; SF = 0 : 0 <= AL + BL < 0x80
; SF = 1 : AL + BL > 0x7F
; CF = 0 : AL + BL <= 0xFF
; CF = 1 : AL + BL > 0xFF

; ZSOC flags
; 0000
	mov	al, 0x01
	mov	bl, 0x00
	add	al, bl	
; ZSOC flags
; 0001
	mov	al, 0xFF
	mov	bl, 0x02
	add	al, bl
; ZSOC flags
; 0010
;	NONE
; ZSOC flags
; 0011
	mov	al, 0x80
	mov	bl, 0x81
	add	al, bl
; ZSOC flags
; 0100
	mov	al, 0x80
	mov	bl, 0x00
	add	al, bl
; ZSOC flags
; 0101
	mov	al, 0xFF
	mov	bl, 0xFF
	add	al, bl
; ZSOC flags
; 0110
	mov	al, 0x7F
	mov	bl, 0x01
	add	al, bl
; ZSOC flags
; 0111 
;	NONE
; ZSOC flags
; 1000
	mov	al, 0x00
	mov	bl, 0x00	
	add	al, bl
; ZSOC flags
; 1001
	mov	al, 0xFF
	mov	bl, 0x01
	add	al, bl
; ZSOC flags
; 1010
;	NONE
; ZSOC flags
; 1011
;	NONE
; ZSOC flags
; 1100
;	NONE
; ZSOC flags
; 1101
;	NONE
; ZSOC flags
; 1110
;	NONE
; ZSOC flags
; 1111
;	NONE
exit:
	mov	ebx, 0
	mov	eax, 1	; exit() syscall
	int	0x80	; syscall interrupt vector

