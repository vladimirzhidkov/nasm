section .bss
LEN_BUF:	equ	8
buf:		resb	LEN_BUF	

section .data
len_line:	dd	0

section .rodata
MSG_YES:	db	"YES", 0xa
MSG_NO:		db	"NO ", 0xa
LEN_MSG:		equ	4	

section .text
global _start
_start:		xor	edi, edi	; paren balance ( 0 = balanced, any other = not balanced)
		mov	dword[len_line], 0	; current line length, needed to detect empty line
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf 
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		add	[len_line], eax
		; iterate through input line
		mov	esi, buf
read_next_char:	mov	bl, [esi]
		cmp	bl, 0xa		; NL char
		jz	line_end
		test	edi, edi
		js	next_iter	; if edi < 0, closing paren comes before opening one	
		cmp	bl, '('
		jz	opening_paren
		cmp	bl, ')'
		jz	closing_paren
		jmp	next_iter
opening_paren:	inc	edi
		jmp	next_iter
closing_paren:	dec	edi
		jmp	next_iter
next_iter:	inc	esi
		dec	eax
		jnz	read_next_char
		jmp	read_stdin
line_end:	cmp	dword[len_line], 1
		jz	_start	
		test	edi, edi			
		jz	print_yes
print_no:	mov	ecx, MSG_NO
		jmp	write
print_yes:	mov	ecx, MSG_YES
write:		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	edx, LEN_MSG
		int	0x80 
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
