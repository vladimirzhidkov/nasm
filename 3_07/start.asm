section .bss
LEN_BUF:	equ	4		; any > 0
buf:		resb	LEN_BUF		; stdin buffer

section .data
msg:		dd	0

section .rodata
YES:		db	'YES', 0xA	
NO:		db	'NO ', 0xA
LEN_MSG:	equ	4		; 3 for YES/NO, 1 for NL character	

section .text
global _start
_start:		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin file descriptor
		mov	ecx, buf
		mov	edx, LEN_BUF	; number of bytes to read
		int	0x80
		test	eax, eax	; eax = input length
		jz	exit		; EOF is reached 
		mov	esi, buf	; iterate through buf
read_nxt_char:	movzx	ebx, byte[esi]	; BL is input character
		cmp	bl, 0xa
		je	print		; BL = NL character 	
		cmp	dword[msg], 0	
		jne	set_msg_no	; there was already input processed, so set NO
		cmp	bl, 'A' 
		jne	set_msg_no	; BL != 'A'
		mov	dword[msg], YES 
		jmp	next_iter
set_msg_no:	mov	dword[msg], NO 
next_iter:	inc	esi
		dec	eax
		jnz	read_nxt_char
		jmp	_start	
print:		mov	ecx, [msg]	
		test	ecx, ecx
		jnz	sys_write	; msg is not empty, so send it to stdout
		mov	ecx, NO		; msg was empty
sys_write:	mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	edx, LEN_MSG
		int	0x80
		mov	dword[msg], 0	; reset to  default msg 
		jmp	_start	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80	
