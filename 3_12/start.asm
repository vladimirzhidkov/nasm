section .bss
LEN_BUF:	equ	10		; any > 0
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
		; check for EOF
		test	eax, eax
		jz	exit	
		; iterate through buf
		mov	esi, buf
		xor	ebx, ebx	; input character
nxt_char:	mov	bl, [esi]
		cmp	bl, 0xa
		je	print_ok
		inc	esi
		dec	eax
		jnz	nxt_char
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
