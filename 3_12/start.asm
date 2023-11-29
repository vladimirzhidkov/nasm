section .bss
LEN_BUF:	equ	4		; any > 0
buf:		resb	LEN_BUF	

section .rodata
OK:		db	"OK", 0xa
LEN_OK		equ	$ - OK

section .text
global _start
_start:		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit	
		cmp	byte[buf+eax-1], 0xa	; check the last element for NL character
		je	print_ok
		jmp	_start
print_ok:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, OK
		mov	edx, LEN_OK
		int	0x80
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
