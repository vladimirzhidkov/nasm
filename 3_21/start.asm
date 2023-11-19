section .bss
buf:		resb	512

section .data
operands:	dd	0, 0
operator:	db	0

section .rodata
BASE_TEN:	dd	10

MSG_ERROR:	db	"Error: Must be decimal operand followed by +, -, *, /, and another decimal operand. No spaces allowed", 0xa
LEN_MSG_ERROR:	equ	$ - MSG_ERROR

MSG_ERR_DIV_BY_0:	db	"Error: Division by 0", 0xa
LEN_MSG_ERR_DIV_BY_0:	equ	$ - MSG_ERR_DIV_BY_0	

section .text
global _start
_start:		; read input
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80		; call kernel
		; check for EOF
		test	eax, eax
		jz	exit
		; add newline to the end just in case the user hit EOF at the end of line
		mov	byte[buf+eax], 0xa
		inc	eax
		; reset previous state
		mov	[operator], byte 0
		; prepare for iterating through input
		mov	esi, buf	; address of the current input character
		mov	edi, buf 
		add	edi, eax	; address of the memory right after last input char
		xor	eax, eax	; operand (input number)
		xor	ebx, ebx	; current input character
		xor	ecx, ecx	; number of processed operands (input numbers) 
read_next_char:	; read input character
		mov	bl, [esi]
chk_digit:	cmp	bl, '0'
		jb	chk_operator	; not digit
		cmp	bl, '9'
		ja	chk_operator	; not digit
		; bl is digit, convert to number 
		sub	ebx, '0'
		; add to accumulator
		mul	dword [BASE_TEN]
		add	eax, ebx
		jmp	next_iter	
chk_0th_pos:	; at this point bl is not digit
		cmp	esi, buf	; check if bl is at 0th position in input
		jz	error		; at 0th pos and not a digit	
chk_operator:	; at this point bl is not at 0th pos, not digit
		cmp	bl, '+'
		jz	is_1st_operator
		cmp	bl, '-'
		jz	is_1st_operator
		cmp	bl, '*'
		jz	is_1st_operator
		cmp	bl, '/'
		jz	is_1st_operator
chk_newline:	; at this point bl is not at 0th pos, not digit, not '+'	
		cmp	bl, 0xa
		jz	store_operand
		jnz	error		; not newline	
is_1st_operator:cmp	byte[operator], 0
		jnz	error		; bl is operator, but not the very first one 
store_operator:	mov	[operator], bl
store_operand:	mov	[operands+ecx*4], eax
		inc	ecx		; number of processed operands (input numbers) 
		cmp	ecx, 2
		jz	calculate	; already got two operands
		xor	eax, eax	; operand (input number)
next_iter:	inc	esi		; address of the current input character
		;cmp	esi, edi
		;jnz	read_next_char
		jmp	read_next_char
error:		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, MSG_ERROR
		mov	edx, LEN_MSG_ERROR
		int	0x80
		jmp	_start
calculate:	mov	eax, [operands+0]	; 1st operand
		mov	ecx, [operands+4]	; 2nd operand
		mov	bl, [operator]		; operator
add:		cmp	bl, '+'
		jnz	sub
		add	eax, ecx
		jmp	convert_to_char	
sub:		cmp	bl, '-'
		jnz	mul
		sub	eax, ecx
		jmp	convert_to_char	
mul:		cmp	bl, '*'
		jnz	chk_div_by_0
		mul	ecx
		jmp	convert_to_char	
chk_div_by_0:	test	ecx, ecx
		jnz	div
		; output division by  0 error message
		mov	eax, 4		; sys_write
		mov	ebx, 1		; output
		mov	ecx, MSG_ERR_DIV_BY_0	
		mov	edx, LEN_MSG_ERR_DIV_BY_0
		int	0x80
		jmp	_start
div:		xor	edx, edx	
		div	ecx	
convert_to_char:; at this point the result is in eax
		mov	edi, buf+10	; reserve 11 chars in buf
		xor	ebx, ebx	; current digit
		mov	byte[edi], 0xa	; add newline character
		dec	edi
		; check for negative number
		mov	esi, eax	; will hold sign flag
		and	esi, 0x80000000
		jz	process_nxt_dgt
		neg	eax	
process_nxt_dgt:xor	edx, edx	
		div	dword[BASE_TEN]
		add	edx, '0'	; convert remainder to char
		mov	[edi], dl	; store it
		dec	edi
		test	eax, eax
		jnz	process_nxt_dgt
		inc	edi
		; print '-' if result was negative. esi holds sigh flag
		test	esi, esi
		jz	print_res
		dec	edi
		mov	byte[edi], '-'
print_res:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, edi
		mov	edx, buf+10+1
		sub	edx, edi
		int	0x80
		jmp	_start	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
