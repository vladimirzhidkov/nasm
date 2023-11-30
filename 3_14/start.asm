section .bss
LEN_BUF:	equ	2		; any > 1	
buf:		resb	LEN_BUF	

section .data
len_longest:	dd	0
len_last:	dd	0

section .text
global _start
_start:		mov	dword[len_longest], 0	
		mov	dword[len_last], 0
read_stdin:	mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf 
		mov	edx, LEN_BUF 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		mov	ecx, eax	
		mov	al, ' '
		mov	edi, buf
scan:		mov	edx, ecx	; # characters left in buf
		repne	scasb		; scan buf and stop when find blank
		jz	end_of_word	; blank found
		cmp	byte[edi-1], 0xa	; check last input character for NL
		je	end_of_word	
		add	esi, edx
		jmp	read_stdin	
end_of_word:	sub	edx, ecx	; calc length
		dec	edx		; exclude blank or NL
		add	esi, edx	; total length of current word	
		jz	check_longest	; if length is not 0
		mov	[len_last], esi	; then save word length 	
check_longest:	cmp	esi, [len_longest]
		jbe	reset_wl	; not the longest word	
		mov	[len_longest], esi
reset_wl:	xor	esi, esi	; reset word length
		cmp	byte[edi-1], 0xa	; check last input character for NL
		je	print
		jmp	scan	
print:		mov	esi, [len_longest]
		call	print_asterisk
		mov	esi, [len_last]
		call	print_asterisk
		jmp	_start
print_asterisk:
print_next_buf: test	esi, esi
		jz	return
		cmp	esi, LEN_BUF-1
		jbe	last_buf
		sub	esi, LEN_BUF-1
		mov	ecx, LEN_BUF-1		; for stosb
		mov	edx, ecx		; for sys_write
		jmp	form_str
last_buf:	mov	byte[buf+esi], 0xa	; add NL character
		mov	edx, esi		; for sys_write
		inc	edx
		mov	ecx, esi
		xor	esi, esi
form_str:	mov	al, '*'
		mov	edi, buf
		rep	stosb
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80	
		jmp	print_next_buf
return:		ret
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
