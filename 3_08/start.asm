section .bss
LEN_BUF:	equ	10		; don't change
buf:		resb	LEN_BUF		; buffer for stdin

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
		cmp	edi, 0		; input digit character
		je	_start		; no digit was entered, so start over
		sub	edi, '0'	; convert to number
		mov	edx, edi
		mov	byte[buf+edi], 0xa	; NL character
		inc	edx
		cld
		mov	al, '*'
		mov	ecx, edi
		mov	edi, buf
		rep stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80	
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80

		; just for fun, use existing buf of any size to form and print output string
;		mov	esi, edi	; input single digit number
;print_nxt_buf:	cmp	esi, LEN_BUF
;		jb	last_buf	; the rest of string will fit into buf	
;		sub 	esi, LEN_BUF
;		mov	ecx, LEN_BUF	; for stosb
;		mov	edx, ecx	; for sys_write
;		jnz	form_str
;		inc	esi
;		dec	ecx
;		dec	edx
;		jmp	form_str	
;last_buf:	mov	ecx, esi	; for stosb	
;		xor	esi, esi	; length
;		mov	byte[buf+ecx], 0xa	; add NL character
;		mov	edx, ecx	; for sys_write
;		inc	edx
;form_str:	mov	al, '*'	
;		mov	edi, buf 
;		cld
;		rep	stosb
;		mov	eax, 4		; sys_write
;		mov	ebx, 1		; stdout
;		mov	ecx, buf 
;		int	0x80	
;		test	esi, esi
;		jnz	print_nxt_buf		
;		jmp	_start
