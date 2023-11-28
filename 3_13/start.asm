section .bss
LEN_BUF:	equ	1		; any > 0
buf:		resb	LEN_BUF	

section .text
global _start
_start:		xor	esi, esi	; char counter needed, so to detect and ignore empty lines (just looks nice)	
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		add	esi, eax
		mov	ecx, eax	; for stosb
		mov	edx, eax	; for sys_write
		cmp	byte[buf+ecx-1], 0xa	; check for NL character at the end
		jne	form_str	
		dec	esi
		jz	read_stdin	
		xor	esi, esi
		dec	ecx		; exclude NL character
form_str:	mov	edi, buf
		mov	al, '*'
		cld
		rep stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80
		jmp	read_stdin	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
