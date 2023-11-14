section .text
global _start
_start:
; a)
	mov	eax, 0x12345678
	and	eax, 0x0ccccccc
; b)
	mov	eax, 0x12345678
	and	eax, 0x33333333
; c)
	mov	eax, 0x12345678
	or	eax, 0x0ccccccc
; d)
	mov	eax, 0x12345678
	shl	eax, 4
; e)
	mov	eax, 0x12345678
	shr	eax, 4
; f)
	mov	eax, 0x0f000
	shr	eax, 2
; g)
	mov	eax, 0x9abcdef1
	shr	eax, 16
; h)
	mov	eax, 0x9abcdef1
	sar	eax, 16
; i)
	mov	eax, 0x45678abc
	sar	eax, 16

; j)
	mov	eax, 0xabcdef12	
	mov	ebx, 0x3456789a
	shl	eax, 12
	and 	eax, 0x00ff0000
	shr	ebx, 20
	and	ebx, 0x0ff
	or	eax, ebx
; k)
	mov	eax, 0x1234abcd
	xor	eax, 0x33333333
; l)
	xor	eax, eax
	neg	eax
	sal	eax, 16
	sar	eax, 8
exit:
	mov	ebx, 0
	mov	eax, 1	;exit() syscall
	int	0x80

