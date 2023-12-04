section .bss
LEN_BUF		equ	4		; any > 0
buf		resb	LEN_BUF	

section .data
TEN:		dd	10

section .text
global _start
_start:		xor	eax, eax	; -1 for input error, or input number	
read_stdin:	push	eax
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		; iterate through input
		mov	ecx, eax
		pop	eax
		mov	esi, buf
read_next_char:	xor	ebx, ebx
		mov	bl, [esi]
		test	bl, bl
		js	next_iter
		cmp	bl, 0xa
		jz	print
		cmp	bl, '0'
		jb	input_error
		cmp	bl, '9'
		ja	input_error
		sub	ebx, '0'
		mul	dword[TEN]
		add	eax, ebx
		jmp	next_iter
input_error:	mov	eax, -1
next_iter:	inc	esi
		dec	ecx
		jnz	read_next_char
		jmp	read_stdin
print:		test	eax, eax
		jz	_start
		js	_start
		mov	esi, eax
print_next_buf:	test	esi, esi
		jz	print_NL	
		cmp	esi, LEN_BUF
		jbe	print_last_buf
		sub	esi, LEN_BUF
		mov	ecx, LEN_BUF
		mov	edx, LEN_BUF
		jmp	form_str
print_last_buf:	mov	ecx, esi	
		mov	edx, esi	
		xor	esi, esi
form_str:	mov	edi, buf
		mov	al, '*'
		rep	stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80
		jmp	print_next_buf	
print_NL:	mov	byte[buf], 0xa	
		mov	eax, 4
		mov	ecx, buf
		mov	edx, 1
		int	0x80
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return value
		int	0x80
