section .bss
LEN_BUF:	equ	4		; any > 0
buf:		resb	LEN_BUF		; stdin buffer

section .rodata
YES:		db	'YES', 0xA	
NO:		db	'NO ', 0xA
LEN_MSG:	equ	4		; 3 for YES/NO, 1 for NL character	

section .text
global _start
_start:		xor	esi, esi	; line length	
		xor	edi, edi	; pointer to message (YES/NO) or 0 if freash read
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin file descriptor
		mov	ecx, buf
		mov	edx, LEN_BUF	; number of bytes to read
		int	0x80
		test	eax, eax	; eax = input length
		jz	exit		; EOF is reached 
		add	esi, eax	; update line length
		test	edi, edi
		jnz	test_nl		; message is set, not fresh read
		cmp	byte[buf], 'A'	; check first buf element
		jne	set_msg_no
		mov	edi, YES	; first buf element is 'A'
		jmp	test_nl
set_msg_no:	mov	edi, NO	
test_nl:	cmp	byte[buf+eax-1], 0xa	; check last buf element for NL character
		jne	read_stdin
		cmp	esi, 1		; check line length 
		je	_start		; line length = 1 (empty line), so reset and start over
		cmp	esi, 2
		je	print
		mov	edi, NO	
print:		mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	ecx, edi
		mov	edx, LEN_MSG
		int	0x80
		jmp	_start	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80	
