section .bss
buf		resb	512

section .text
global _start
_start:
		; read stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80

		; check for EOF
		test	eax, eax
		jz	exit

		; edx:eax holds number to convert to text
		; ebx is 10
		; ecx is counter of digits
		; edx is remander
		; edi is position address in buf
		mov	ebx, 10
		mov	edi, buf + 10	; will be storing digit characters in reverse
		mov	[edi], byte 0xa	; newline character
		dec	edi
		mov	ecx, 1
lp1:		xor	edx, edx
		div	ebx
		; convert remainder (edx) to digit character
		add	edx, '0'
		mov	[edi], dl
		dec	edi
		inc	ecx
		; check quotient (eax)
		test	eax, eax
		jnz	lp1
		inc	edi	
		
		; print buf starting at edi 
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	edx, ecx
		mov	ecx, edi 
		int	0x80		; call kernel
		
		jmp	_start	
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
