section .bss
LEN_INPUT_BUF:	equ	8		; any > 0
input_buf:	resb	LEN_INPUT_BUF
LEN_OUTPUT_BUF:	equ	8
output_buf:	resb	LEN_OUTPUT_BUF

section .data
len_word:	dd	0		; current word length

section .text
global _start
_start:		mov	edi, output_buf
		mov	ecx, LEN_OUTPUT_BUF
read_stdin:	push	ecx
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, input_buf 
		mov	edx, LEN_INPUT_BUF 
		int	0x80
		pop	ecx
		test	eax, eax	; check for EOF
		jz	exit
		; iterate through input_buf
		mov	esi, input_buf
read_next_char:	mov	dl, [esi]
		cmp	dl, 0xa		; check for NL	
		jnz	check_blank
		jmp	check_len_word
check_blank:	cmp	dl, ' '
		jnz	check_new_word
check_len_word:	cmp	dword[len_word], 0
		jz	print_char
		mov	dword[len_word], 0
		mov	byte[edi], ')' 
		call	print		
		jmp	print_char	
check_new_word:	cmp	dword[len_word], 0
		jnz	inc_len_word
		mov	byte[edi], '(' 
		call	print
inc_len_word:	inc	dword[len_word]
print_char:	mov	byte[edi], dl	; print current char
		call	print	
next_iter:	cmp	dl, 0xa		; check for NL	
		jz	flush_output_buf
		inc	esi
		dec	eax
		jnz	read_next_char	; still have chars left in input_buf
		jmp	read_stdin	; input_buf is empty, so jump to fill it up again with chars from stdin
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80 
flush_output_buf:
		mov	eax, 4
		mov	ebx, 1
		mov	ecx, output_buf
		mov	edx, edi
		sub	edx, output_buf
		int	0x80
		jmp	_start	
; prints to outpub buf. if full, flush it to stdout
print:		inc	edi	
		dec	ecx
		jnz	.done	
.flush:		push	eax
		push	ebx
		push	edx
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, output_buf
		mov	edx, LEN_OUTPUT_BUF
		int	0x80
		pop	edx
		pop	ebx
		pop	eax
		mov	ecx, LEN_OUTPUT_BUF	
		mov	edi, output_buf
.done:		ret
