section .text
global _start
_start:
; a)
	mov	al, 0x1a
	mov	bl, 0x1c
	sub	al, bl
; b)
	mov	al, 29
	mov	bl, 0xfe
	sub	al, bl
; c)
	mov	al, 0xed
	mov	bl, 0xee
	sub	al, bl
; d)
	mov	al, 0x7e
	mov	bl, 0x6d
	sub	al, bl
; e)
	mov	al, 0x8a
	mov	bl, 0x1a
	sub	al, bl
; f)
	mov	al, 0x7c
	mov	bl, 88
	sub	al, bl
exit:
	mov	ebx, 0
	mov	eax, 1	;exit() syscall
	int	0x80	;syscall interrupt vector
