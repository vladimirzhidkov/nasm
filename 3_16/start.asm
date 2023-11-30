section .bss
LEN_BUF:	equ	8
buf:		resb	LEN_BUF

section .data
wc:		dd	0		; word count

section .text
global _start
_start:		mov	dword[wc], 0	
		xor	edi, edi	; current word length
read_next_buf:	mov 	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax
		jz	exit
		; iterate through input line
		mov	esi, buf
read_next_char:	mov	bl, [esi]
		cmp	bl, 0xa
		jz	end_line
		cmp	bl, ' '
		jnz	update_word_len	
		call	count_word
		jmp	next_iter
update_word_len:inc	edi		; current word length
next_iter:	inc	esi
		dec	eax
		jnz	read_next_char
		jmp	read_next_buf
end_line:	call	count_word
		call	print_asterisk
		jmp	_start	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status 
		int	0x80
; increases word count [wc] if word is not empty
count_word:	test	edi, edi	; current word length
		jz	.done
		inc	dword[wc]	
		xor	edi, edi
.done:		ret	
; prints [wc] long line of asterisks
print_asterisk:	mov	esi, [wc]
.next_buf:	test	esi, esi
		jz	.done
		cmp	esi, LEN_BUF-1
		jbe	.last_buf
		sub	esi, LEN_BUF-1
		mov	ecx, LEN_BUF-1
		mov	edx, ecx 
		jmp	.form_str	
.last_buf:	mov	ecx, esi	; for stosb 
		mov	edx, esi	; for sys_write	
		mov	byte[buf+edx], 0xa	; print NL
		inc	edx
		xor	esi, esi	
.form_str:	cld
		mov	edi, buf
		mov	al, '*'
		rep	stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80
		jmp	.next_buf
.done:		ret
