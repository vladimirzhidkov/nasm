section .bss
buf		resb	512

section .text
global _start
_start:		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		mov	ebx, 10
		mov	edi, buf + 10	; will be storing digit characters in reverse
		mov	[edi], byte 0xa	; newline character
		dec	edi
		mov	ecx, 1
lp1:		xor	edx, edx
		div	ebx
		add	edx, '0'
		mov	[edi], dl
		dec	edi
		inc	ecx
		test	eax, eax
		jnz	lp1
		inc	edi	
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	edx, ecx
		mov	ecx, edi 
		int	0x80		; call kernel
		jmp	_start	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
