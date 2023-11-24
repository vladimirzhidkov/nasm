section .data
src_array:	dd	0,1,2,3,4,5,6,7,8,9
SIZE:		equ	($ - src_array) / 4

section .bss
dest_array:	resd	SIZE

section .text
global _start
_start:		; copy src_array to dest_array
		mov	ecx, SIZE
		mov	esi, src_array
		mov	edi, dest_array
		cld
		rep movsd		; dword[esi] -> [edi]; inc esi, inc edi, dec ecx, check ecx for 0

exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
