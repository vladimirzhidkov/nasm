section .bss
LEN_BUF:	equ	2		; any >  1
buf:		resb	LEN_BUF		; for both stdin and stdout

section .data
sum:		dd	0

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
read_nxt_char:	mov	bl, [esi]	
		cmp	bl, 0xa
		jz	prnt_nxt_buf	; BL = NL character	
		cmp	bl, '0'
		jb	nxt_iter	; BL is not a digit character, so ignore it
		cmp	bl, '9'
		ja	nxt_iter	; BL is not a digit character, so ignore it
		sub	bl, '0'		; convert BL to number
		add	dword[sum], ebx
nxt_iter:	inc	esi
		dec	eax
		jnz	read_nxt_char
		jmp	_start	
prnt_nxt_buf:	mov	eax, [sum]	; total length left
		test	eax, eax
		jz	_start
		cmp	eax, LEN_BUF-1	; -1 is for reserving spot for NL character 
		jbe	last_buf	; 	
		sub	eax, LEN_BUF-1	; reduce total length left by buf length - 1
		mov	ecx, LEN_BUF-1	; for stosb use
		mov	dword[sum], eax ; updated length left
		mov	edx, ecx	; for sys_write
		jmp	form_str
last_buf:	mov	ecx, eax	; for stosb use
		mov	byte[buf+ecx], 0xa	; add NL char to the end
		mov	edx, ecx	; for sys_write
		inc	edx
		mov	dword[sum], 0	
form_str:	mov	edi, buf
		mov	al, '*'
		rep stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf	
		int	0x80
		jnz	prnt_nxt_buf	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
