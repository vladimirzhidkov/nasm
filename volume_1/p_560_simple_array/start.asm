section .bss
array:		resb	256

section .text
global _start
_start:
		mov	ecx, 256
		mov	edi, array
		mov	al, '@'
again:		mov	[edi], al
		inc	edi
		dec	ecx
		jnz	again


exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
