section .rodata
HELLO:		db	"hello", 0xa
LEN_HELLO:	equ	$ - HELLO

section .text
global _start
_start:		; print hello 5 times
		mov	esi, 5		; loop counter	
print_hello:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, HELLO
		mov	edx, LEN_HELLO
		int	0x80
		dec	esi
		test	esi, esi
		jnz	print_hello
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80

