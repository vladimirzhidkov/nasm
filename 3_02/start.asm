section .text
global _start
_start:
; a)
	mov	al, 0xfe
	mov	bl, 02
	add	al, bl
; b)
	mov	al, 02
	mov	bl, 0xfe
	add	al, bl
; c)
	mov	al, 0x1f
	mov	bl, 0x1e
	add	al, bl
; d)
	mov	al, 0x1f
	mov	bl,0xff
	add	al, bl
; e)
	mov	al, 0x7a
	mov	bl, 07
	add	al, bl
; f)
	mov	al, 0x8b
	mov	bl, 0xf0
	add	al, bl
exit:
	mov	ebx, 0
	mov	eax, 1	;exit() syscall
	int	0x80

