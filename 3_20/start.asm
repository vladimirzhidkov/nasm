section .bss
buf		resb	512

section .data
nums:		dd	0, 0
num_count:	dd	0		; number of processed numbers so far
results:	dd	0, 0, 0

section .rodata
BASE_TEN:		dd	10
MSG_ERROR:	db	"Wrong input format: must be two numbers separated by space.", 0xa
LEN_MSG_ERROR:	equ	$ - MSG_ERROR

section .text
global _start
_start:		; read stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80
		; check for EOF
		test	eax, eax
		jz	exit
		; if last character is not newline (user ended input with EOF)
		; then add it
		mov	[buf + eax], byte 0xa
		inc	eax
		; prepare for iterating through input 
		mov	ecx, eax	; loop counter	
		xor	eax, eax	; accumulator (input number)
		xor	ebx, ebx	; current element
		mov	esi, buf	; current position address
		xor	edi, edi	; sign flag 
		; start loop of reading characters from buf
lp_read_c:	mov	bl, [esi]	
		; check for digit characters
chk_digit:	cmp	bl, '0'
		jb	chk_blank	; not a digit 
		cmp	bl, '9'
		ja	chk_blank	; not a digit
		sub	bl, '0'
		mul	dword[BASE_TEN]
		add	eax, ebx
		jmp	next_iter
chk_blank:	; at this point bl is not a digit character
		cmp	bl, ' '
		jnz	chk_newline		; not blank not digit
		cmp	esi, buf
		jz	next_iter		; blank and first character	
		cmp	[esi-1], byte ' '
		jz	next_iter		; blank and prev is also blank
		cmp	[esi-1], byte '-'
		jz	error			; blank and prev is minus
		jmp	chk_sign_flag		; blank and prev is digit
		; at this point bl is not digit and not blank
chk_newline:	cmp	bl, 0xa			
		jz	chk_sign_flag		; newline and prev is digit 
		; at this point bl is not digit, not blank, not newline
chk_minus:	cmp	bl, '-'
		jnz	error			; not minus character
		cmp	esi, buf
		jz	set_sign_flag		; minus and first character	
		cmp	[esi-1], byte ' '
		jnz	error			; minus and prev is not blank 
set_sign_flag:	mov	edi, 1			; set sign flag		
		jmp	next_iter		; minus character
chk_sign_flag:	; if needed, negate input number (eax),
		test	edi, edi	; check sign flag
		jz	store_num	; input number is positive
		neg	eax
		xor	edi, edi	; reset sign flag
store_num:	; store input number (eax) -> nums[], inc num_count
		mov	edx, [num_count]
		mov	[nums+edx*4], eax	
		inc	edx
		mov	[num_count], edx
		xor	eax, eax	; reset accumulator (input number)
		; if two numbers already processed, then done with reading
		cmp	edx, 2
		jz	calculate	
next_iter:	; prepare for next iteration
		inc	esi
		loop	lp_read_c	
		jmp	calculate
error:		; print error
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, MSG_ERROR
		mov	edx, LEN_MSG_ERROR
		int	0x80
		jmp	reset
calculate:	; load nums[0] -> eax, nums[1] -> ebx
		mov	eax, [nums]
		mov	ebx, [nums + 4]
		; calculate sum and store into results[0] 
		mov	[results], eax
		add	[results], ebx 
		; calculate difference and store into results[1] 
		mov	[results + 4], eax
		sub	[results + 4], ebx 
		; calculate product and store into results[2]	
		mul	ebx
		mov	[results + 8], eax
		; convert results to string and store it into buf
		; digit by digit in reverse order
		xor	eax, eax	; quotient
		xor	edx, edx	; reminder
		xor	esi, esi	; sign flag (0=positive, otherwise negative)
		mov	ebx, 10
		mov	ecx, 3		; result count
		mov	edi, buf+33
		mov	[edi], byte 0xa	; add newline character
		dec	edi
lp_nxt_result:	mov	eax, [results + ecx*4-4]
		; if eax is negative number,
		; then set neg flag(esi) and negate number(eax) 
		mov	esi, eax
		and	esi, 0x80000000	; check MSB
		jz	lp_nxt_digit
		neg	eax
lp_nxt_digit:	div	ebx
		add	edx, '0'
		mov	[edi], dl 
		dec	edi
		xor	edx, edx
		test	eax, eax
		jnz	lp_nxt_digit
		; if number is negative, then print '-'
		; esi is flag for negative number
		test 	esi, esi
		jz	add_blank
		mov	[edi], byte '-'
		dec	edi	
add_blank:	mov	[edi], byte ' '	; add blank bw results
		dec	edi
		dec	ecx
		test	ecx, ecx
		jnz	lp_nxt_result
		add	edi, 2		; remove blank in front of first result
		; print results
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, edi
		mov	edx, buf+33+1
		sub	edx, edi
		int	0x80	
reset:		; reset num_count and start all over
		mov	[num_count], dword 0	
		jmp	_start
exit:		; exit
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
