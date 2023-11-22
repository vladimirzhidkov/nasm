section .bss
matrix:		resd	LINES * COLUMNS
LINES:		equ	5	
COLUMNS:	equ	9	
LEN_LINE:	equ	COLUMNS * 4

buf:		resb	LINES * COLUMNS + LINES

section .text
global _start
_start:
		xor	eax, eax	; offset (column index)
		xor	ebx, ebx	; base
		
nxt:		mov	[matrix + ebx + eax * 4], eax 
		inc	eax
		cmp	eax, COLUMNS 
		jnz	nxt
		xor	eax, eax
		add	ebx, LEN_LINE			
		cmp	ebx, LINES * COLUMNS * 4
		jnz	nxt
print_matrix:	
		xor	eax, eax	; offset (column index)
		xor	ebx, ebx	; base
		mov	edi, buf
		
nxt_char:	mov	ecx, '0'
		add	ecx, [matrix + ebx + eax * 4]
		mov	[edi], cl	
		inc	edi
		inc	eax
		cmp	eax, COLUMNS 
		jnz	nxt_char
		xor	eax, eax
		mov	byte[edi], 0xa
		inc	edi
		add	ebx, LEN_LINE			
		cmp	ebx, LINES * COLUMNS * 4
		jnz	nxt_char

		; print buf
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		mov	edx, LINES * COLUMNS + COLUMNS 
		int	0x80
exit:		
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
