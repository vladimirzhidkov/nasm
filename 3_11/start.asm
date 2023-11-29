section .bss
LEN_BUF:	equ	4		; any >  1
buf:		resb	LEN_BUF		; for both stdin and stdout

section .text
global _start
_start:		xor	edi, edi	; sum	
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit	
		mov	esi, buf
		xor	ebx, ebx	
read_nxt_char:	mov	bl, [esi]	; input character
		cmp	bl, 0xa
		jz	print		; BL = NL character	
		cmp	bl, '0'
		jb	nxt_iter	; BL is not a digit character, so ignore it
		cmp	bl, '9'
		ja	nxt_iter	; BL is not a digit character, so ignore it
		sub	bl, '0'		; convert BL to number
		add	edi, ebx
nxt_iter:	inc	esi
		dec	eax
		jnz	read_nxt_char
		jmp	read_stdin	
print:		mov	esi, edi	; total length left
prnt_nxt_buf:	test	esi, esi 
		jz	_start
		cmp	esi, LEN_BUF-1	; -1 is for reserving spot for NL character 
		jbe	last_buf	; 	
		sub	esi, LEN_BUF-1	; reduce total length left by buf length - 1
		mov	ecx, LEN_BUF-1	; for stosb use
		mov	edx, ecx	; for sys_write
		jmp	form_str
last_buf:	mov	ecx, esi	; for stosb use
		mov	byte[buf+ecx], 0xa	; add NL char to the end
		mov	edx, esi	; for sys_write
		inc	edx
		xor	esi, esi
form_str:	mov	edi, buf
		mov	al, '*'
		rep stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf	
		int	0x80
		jmp	prnt_nxt_buf	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
