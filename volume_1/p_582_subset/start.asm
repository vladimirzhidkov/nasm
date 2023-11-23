section .bss
SIZE_MY_SET_1:	equ	16	
my_set_1:	resd	SIZE_MY_SET_1 	; set of SIZE_MY_SET_1 * 32 bits
X:		equ	54	; bit index in my_set_1

section .data
my_set_2:	dd	0x0f0f0f0f, 0xf0f0f0f0, 0xffff0000, 0x0000ffff
SIZE_MY_SET_2:	equ	($ - my_set_2) / 4

section .text
global _start
_start:		; clear my_set_1
		xor	eax, eax
		mov	ecx, SIZE_MY_SET_1	
nxt:		mov	[my_set_1 + ecx * 4 - 4], eax
		dec	ecx
		jnz	nxt	

set_bit:	; set bit at X in my_set_1
		mov	ecx, X	
		and	cl, 11111b	; get first 5 bits ( bit index) 
		mov	eax, 1
		shl	eax, cl		; mask
		mov	ecx, X
		shr	ecx, 5		; element index in my_set_1
		or	[my_set_1 + ecx * 4], eax

reset_bit:	; reset bit at X in my_set_1
		mov	ecx, X	
		and	cl, 11111b	; get first 5 bits ( bit index) 
		mov	eax, 1
		shl	eax, cl		
		not	eax		; mask
		mov	ecx, X
		shr	ecx, 5		; element index in my_set_1
		and	[my_set_1 + ecx * 4], eax

sum:		; find sum of all set bits in my_set_2
		xor	eax, eax		; eax is accumulator
		mov	ecx, SIZE_MY_SET_2	; element count
nxt_element:	mov	ebx, [my_set_2 + ecx * 4 - 4]
		mov	edx, 32			; bit count
nxt_bit:	test	ebx, 1
		jz	skip
		inc	eax
skip:		shr	ebx, 1	
		dec	edx
		jnz	nxt_bit
		dec	ecx
		jnz	nxt_element	

		mov	ebx, eax
exit:		mov	eax, 1		; sys_exit
		;mov	ebx, 0		; return status
		int	0x80
