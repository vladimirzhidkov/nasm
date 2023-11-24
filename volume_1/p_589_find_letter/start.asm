section .rodata
STR:		db	"This is a string."
LEN_STR:	equ	$ - STR

section .text
global _start
_start:		; find letter in str
		mov	al, 'r'
		mov	edi, STR
		mov	ecx, LEN_STR
		cld
		repnz scasb		; cmp al, [edi]; inc edi; dec ecx


exit:		mov	eax, 1		; sys_write
		mov	ebx, 0		; return status
		int	0x80		; call kernel
