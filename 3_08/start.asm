section .bss
LEN_BUF:	equ	3
buf:		resb	LEN_BUF
LEN_STR:	equ	10
str:		resb	LEN_STR

section .data
error:		dd	0
digit:		db	0, 0xa

section .rodata
MSG_ERROR:	db	"Input error", 0xa
LEN_MSG_ERROR:	equ	$ - MSG_ERROR

section .text
global _start
_start:		; read input
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin	
		mov	ecx, buf
		mov	edx, LEN_BUF
		int	0x80
		; check for EOF
		test	eax, eax
		jz	exit	
		; iterate through buf
		xor	ebx, ebx	; char
		mov	esi, buf
read_char:	mov	bl, [esi]
		cmp	bl, 0xa		; NL
		jz	end_input	; bl = NL 
		cmp	dword[error], 0
		jnz	next		; there was input error earlier
		cmp	byte[digit], 0
		jnz	set_error	; there was already digit
		cmp	bl, '0'
		jb	set_error
		cmp	bl, '9'
		ja	set_error
		mov	[digit], bl
		jmp	next
set_error:	mov	dword[error], MSG_ERROR 
next:		inc	esi
		dec	eax
		jnz	read_char
		jmp	_start
end_input:	cmp	byte[digit], 0
		jnz	print		
		mov	dword[error], MSG_ERROR	
print:		mov	ecx, [error]
		test	ecx, ecx
		jz	form_str	; there was no input errors
		mov	edx, LEN_MSG_ERROR
		jmp	sys_write
form_str:	xor	ecx, ecx	
		mov	cl, [digit]
		sub	ecx, '0'
		mov	edx, ecx
		mov	al, '*'
		mov	edi, str
		cld
		rep stosb
		mov	byte[edi], 0xa
		inc	edx
		mov	ecx, str 
sys_write:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		int	0x80
reset:		mov	byte[digit], 0
		mov	dword[error], 0	
		jmp	_start	
exit:		mov	eax, 1	; sys_exit
		mov	ebx, 0	; return status
		int	0x80	
