section .data
array:		dd	0, 1, 2, 3, 4, 5, 6, 7, 8, 9
LEN_ARRAY:	equ	$ - array

section .text
global _start
_start:		; increase all array elements by 10
		mov	ecx, LEN_ARRAY
		mov	esi, array
		mov	edi, array
		cld
next:		lodsd			; [edi] -> EAX
		add	eax, 10
		stosd			; EAX -> [esi]
		loop	next

exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
