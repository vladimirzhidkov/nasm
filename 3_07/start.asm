section .bss
LEN_BUF:	equ	1		; any > 0
buf:		resb	LEN_BUF		; stdin buffer

section .data
msg:		dd	0

section .rodata
YES:		db	'YES', 0xA	
NO:		db	'NO ', 0xA
LEN_MSG:	equ	4		; 3 for YES/NO, 1 for NL character	

section .text
global _start
_start:		;mov	dword[msg], NO	; default msg 
		; read from stdin
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin file descriptor
		mov	ecx, buf
		mov	edx, LEN_BUF	; number of bytes to read
		int	0x80
		; check for EOF
		test	eax, eax
		jz	exit
		; iterate through buf
		; eax = input length
		mov	esi, buf
read_nxt_char:	movzx	ebx, byte[esi]	
		cmp	ebx, 0xa
		je	print		; EBX = NL character 	
		cmp	dword[msg], 0	
		jne	set_msg_no	; there was already input processed, so set NO
		cmp	ebx, 'A' 
		jne	set_msg_no	; EBX != 'A'
		mov	dword[msg], YES 
		jmp	next_iter
set_msg_no:	mov	dword[msg], NO 
next_iter:	inc	esi
		dec	eax
		jnz	read_nxt_char
		jmp	read_stdin
print:		mov	ecx, [msg]	
		test	ecx, ecx
		jnz	sys_write	; msg is not empty, so send it to stdout
		mov	ecx, NO		; msg was empty
sys_write:	mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	edx, LEN_MSG
		int	0x80
		; reset
		mov	dword[msg], 0	; default msg 
		jmp	read_stdin
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80	
