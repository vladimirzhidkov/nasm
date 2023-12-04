section .bss
LEN_BUF:	equ	11		; can hold upto 4bln
buf:		resb	LEN_BUF

section .text
global _start
_start:		xor	esi, esi	; char counter	
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		add	esi, eax
		test	eax, eax	; check for EOF
		jnz	read_stdin	
		mov	eax, esi	; quotient
		mov	esi, 10		; divisor
		mov	edi, buf+LEN_BUF-1
		mov	byte[edi], 0xa
		dec	edi
		mov	ecx, 1		; char counter
divide:		xor	edx, edx	; remainder
		div	esi		; divide by 10
		mov	ebx, '0'
		add	ebx, edx
		mov	[edi], bl
		dec	edi
		inc	ecx
		test	eax, eax
		jnz	divide	
print:		inc	edi	
		mov	eax, 4		; sys_write
		mov	ebx, 2		; stdout
		mov	edx, ecx
		mov	ecx, edi 
		int	0x80
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
