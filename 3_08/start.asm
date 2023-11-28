section .bss
LEN_BUF:	equ	4		; any > 0 
buf:		resb	LEN_BUF		; buffer for stdin
LEN_STR:	equ	10
str:		resb	LEN_STR		; string of '*' up to 9 ending with NL character

section .text
global _start
_start:		xor	esi, esi	; line length 	
		xor	edi, edi	; reset digit;  = 0 (no input yet) or '0'-'9'
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin	
		mov	ecx, buf
		mov	edx, LEN_BUF
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit	
		cmp 	esi, 0		; check if it's first read (line length)
		jne	chk_ln_end	; not first read 
		movzx	ebx, byte[buf]	; input character
		cmp	bl, '0'
		jb	chk_ln_end
		cmp	bl, '9'
		ja	chk_ln_end
		mov	edi, ebx	; save digit
chk_ln_end:	add	esi, eax	; update line length
		cmp	byte[buf+eax-1], 0xa	; check last buf element for NL character	
		jne	read_stdin
		cmp	esi, 2		; line length
		jne	_start		; input is not one character (excluding NL), so start over
		cmp	edi, 0	
		je	_start		; no digit was entered, so start over
		;form string
		sub	edi, '0'	; convert to number
		mov	ecx, edi
		mov	edx, edi	; for sys_write
		mov	edi, str
		mov	al, '*'
		cld
		rep	stosb
		mov	byte[edi], 0xa
		inc	edx
		; print
		mov	eax, 4
		mov	ebx, 1
		mov	ecx, str
		int	0x80	
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
