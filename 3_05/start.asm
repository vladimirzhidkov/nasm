section .text
global _start
_start:

; ZSOC flags
; 0000
	mov	al, 0x01
	mov	bl, 0x00
	sub	al, bl	
; ZSOC flags
; 0001
;	NONE
; ZSOC flags
; 0010
	mov	al, 0x80
	mov	bl, 0x01
	sub	al, bl
; ZSOC flags
; 0011
;	NONE
; ZSOC flags
; 0100
	mov	al, 0x80
	mov	bl, 0x00
	sub	al, bl
; ZSOC flags
; 0101
	mov	al, 0xFE
	mov	bl, 0xFF
	sub	al, bl
; ZSOC flags
; 0110
;	NONE
; ZSOC flags
; 0111 
	mov	al, 0x7F
	mov	bl, 0xFF
	sub	al, bl
; ZSOC flags
; 1000
	mov	al, 0x00
	mov	bl, 0x00	
	sub	al, bl
; ZSOC flags
; 1001
;	NONE
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

