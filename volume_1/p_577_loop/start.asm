section .bss
SIZE		equ	5	
array		resd	SIZE

section .text
global _start
_start:		; populate array
		mov	ecx, SIZE
		mov	esi, array
nxt:		mov	[esi], ecx
		add	esi, 4
		loop	nxt

		; calclulate sum of all array elements
		xor	eax, eax	; accumulator
		mov	ecx, SIZE
		mov	esi, array
lp:		add	eax, [esi]
		add	esi, 4
		loop	lp	
		mov	ebx, eax
exit:		mov	eax, 1		; sys_exit
		;mov	ebx, 0		; return status
		int	0x80
