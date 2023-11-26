section .bss
LEN_BUF:	equ	3
buf:		resb	LEN_BUF		; stdin buffer

section .rodata
YES		db	'YES', 0xA	
LEN_YES		equ	$ - YES	
NO		db	'NO', 0xA
LEN_NO		equ	$ - NO	

section .text
global _start
_start:		; read from stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin file descriptor
		mov	ecx, buf
		mov	edx, 1		; number of bytes to read
		int	0x80
		; check for EOF
		test	eax, eax
		jz	exit
		; check buf
		mov	al, [buf]
		cmp	al, 'A' 
		je	print_yes	; al = A
		cmp	al, 0xa
		je	_start		; al = newline so ignore it	
print_no:	mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	ecx, NO 
		mov	edx, LEN_NO	; length
		int	0x80
		jmp	_start
print_yes:	 mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	ecx, YES
		mov	edx, LEN_YES	; length
		int	0x80
		jmp	_start
exit:		mov	ebx, 0		; return status
		mov	eax, 1		; sys_exit
		int	0x80	
