section .bss
LEN_BUF:	equ	2		; any > 1	
buf:		resb	LEN_BUF		

section .data
plus_count:	db	0
minus_count:	db	0

section .text
global _start
_start:		mov	byte[plus_count], 0
		mov	byte[minus_count], 0	
read_stdin:	; read input
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		; check for EOF
		test	eax, eax	; holds number or characters or 0 for EOF
		jz	exit
		; iterate through buf
		; eax = input length
		mov	esi, buf
read_nxt_char:	movzx	ebx, byte[esi]
		cmp	ebx, 0xa
		je	calc_prod	; EBX = NL character	
		cmp	ebx, '+'
		je	inc_plus_count	; EBX = '+'
		cmp	ebx, '-'
		je	inc_minus_count	; EBX = '-'
		jmp	nxt_iter
inc_plus_count:	inc	byte[plus_count]
		jmp	nxt_iter
inc_minus_count:inc	byte[minus_count]
nxt_iter:	inc	esi
		dec	eax
		jnz	read_nxt_char
		jmp	read_stdin	
calc_prod:	mov	al, [plus_count]
		mul	byte[minus_count]	; product->AX = total length
		; split total length into series of bufs
nxt_buf:	cmp	eax, LEN_BUF-1	; reserve 1 spot for NL char
		jbe	last_buf	
		sub	eax, LEN_BUF-1	; reduce total length left (reserve 1 spot for NL char)
		mov	ecx, LEN_BUF-1	; char counter for stosb use (reserve 1 spot for NL char) 
		mov	edx, ecx	; char counter for sys_write use
		jmp	fill_buf	
last_buf:	mov	ecx, eax	; char counter for stosb use 
		xor	eax, eax	; clear total length left
		mov	byte[buf+ecx], 0xa	; add NL character
		mov	edx, ecx	; char counter for sys_write use
		inc	edx
fill_buf:	push	eax		; save total length left
		; form string
		mov	al, '*'	
		mov	edi, buf
		cld
		rep stosb 
		; write to stdout
		mov	eax, 4		; sys_write 
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80 
		pop	eax		; restore total length left
		test	eax, eax
		jnz	nxt_buf
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
