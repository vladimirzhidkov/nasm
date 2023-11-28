section .bss
LEN_BUF:	equ	4		; any > 0 
buf:		resb	LEN_BUF		; buffer for stdin
LEN_STR:	equ	10
str:		resb	LEN_STR		; string of '*' up to 9 ending with NL character

section .data
error:		dd	0		; error flag / pointer to error msg. 0 means no input error
digit:		db	0		; input digit character or 0 if none read

section .rodata
MSG_ERROR:	db	"Input error", 0xa
LEN_MSG_ERROR:	equ	$ - MSG_ERROR

section .text
global _start
_start:		
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin	
		mov	ecx, buf
		mov	edx, LEN_BUF
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit	
		xor	ebx, ebx	; input character
		mov	esi, buf
read_nxt_char:	movzx	ebx, byte[esi]
		cmp	ebx, 0xa	; NL character
		jz	end_input	; EBX = NL character
		cmp	dword[error], 0	; error flag / pointer to error msg. 0 means no input error
		jnz	next_iter	; there was input error earlier
		cmp	byte[digit], 0
		jnz	set_error	; there was already digit
		cmp	ebx, '0'
		jb	set_error	; EBX is not a digit character
		cmp	ebx, '9'
		ja	set_error	; EBX is not a digit character
		mov	[digit], bl	; store digit
		jmp	next_iter
set_error:	mov	dword[error], MSG_ERROR 
next_iter:	inc	esi
		dec	eax
		jnz	read_nxt_char
		jmp	_start
end_input:	cmp	byte[digit], 0
		jnz	chk_for_err	; there is digit stored	
		mov	dword[error], MSG_ERROR	; there was no digit stored, so set error	
chk_for_err:	mov	ecx, [error]
		test	ecx, ecx
		jz	form_str	; there was no input errors
		mov	edx, LEN_MSG_ERROR
		jmp	sys_write
form_str:	movzx	ecx, byte[digit]
		sub	ecx, '0'
		mov	edx, ecx
		mov	eax, '*'
		mov	edi, str
		cld
		rep stosb
		mov	byte[edi], 0xa	; add NL character
		inc	edx
		mov	ecx, str 
sys_write:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		int	0x80
		mov	byte[digit], 0	; reset 
		mov	dword[error], 0	
		jmp	_start	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80	
