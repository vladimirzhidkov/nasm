extern fill_memory

section .bss
buf		resb	512

section .text
global _start
_start:		; fill 10 elements of buff with '*'
		mov	edi, buf
		mov	ecx, 10
		mov	al, '*'
		call	fill_memory
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
