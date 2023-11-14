section .text
global _start
_start:
; a)
	mov	eax, 0x4f682b
	mov	ax, 19905
	mov	al, 130o
; b)
	mov	eax, 0x99f6ee
	mov	ax, 63172o
	mov	al, 99
; c)
	mov	eax, 0xdb9fe3
	mov	ax, 2486
	mov	ah, 0x5b
; d)	
	mov	eax, 0x7f2176
	mov	ax, 62877
	mov	al, 134o
; e)
	mov	eax, 0x55623b
	mov	ax, 31071
	mov	ah, 0xc9
; f)
	mov	eax, 0x5e1bda
	mov	ax, 45102
	mov	ah, 0x40
exit:
	mov	ebx, 0
	mov	eax, 1	;exit() syscall
	int	0x80
