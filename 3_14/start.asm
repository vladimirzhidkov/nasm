section .bss
LEN_BUF:	equ	64		; any > 1	
buf:		resb	LEN_BUF	

section .data
len_longest:	dd	0
len_last:	dd	0

section .text
global _start
_start:		mov	dword[len_longest], 0	
		mov	dword[len_last], 0
		xor	edi, edi	; current word length
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf 
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		; iterate through input
		mov	esi, buf
read_next_char:	mov	bl, [esi]
		cmp	bl, ' '
		jnz	chk_NL	
		call	word_end
		xor	edi, edi
		jmp	next_iter
chk_NL:		cmp	bl, 0xa
		jz	line_end		
		inc	edi
next_iter:	inc	esi
		dec	eax
		jnz	read_next_char
		jmp	read_stdin	
line_end:	call	word_end
		mov	esi, [len_longest]
		call	print_asterisk
		mov	esi, [len_last]
		call	print_asterisk
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80

word_end:	test	edi, edi
		jz	.done	
		mov	[len_last], edi
		cmp	edi, [len_longest]
		jbe	.done	
		mov	[len_longest], edi
.done:		ret

print_asterisk:	test	esi, esi
		jz	.done	
		cmp	esi, LEN_BUF-1
		jbe	.last_buf
		sub	esi, LEN_BUF-1
		mov	ecx, LEN_BUF-1		; for stosb
		mov	edx, ecx		; for sys_write
		jmp	.form_str
.last_buf:	mov	byte[buf+esi], 0xa	; add NL character
		mov	edx, esi		; for sys_write
		inc	edx
		mov	ecx, esi
		xor	esi, esi
.form_str:	mov	al, '*'
		mov	edi, buf
		rep	stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80	
		jmp	print_asterisk
.done:		ret
