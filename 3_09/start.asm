section .bss
LEN_BUF:	equ	5
buf:		resb	LEN_BUF	

section .text
global _start
_start:		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		; check for EOF
		test	eax, eax
		jz	exit
		; write to stdout
		mov	edx, eax	; num of characters
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80		
		jmp	_start	
exit:		mov	ebx, eax	; return status
		mov	eax, 1		; sys_exit
		int	0x80	
