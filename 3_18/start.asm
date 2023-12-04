section .bss
buf		resb	1024	

section .text
global _start
_start:		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 1024 
		int	0x80
		test	eax, eax	; check for EOF
		jz	exit
		; iterate through input
		mov	esi, buf
		mov	edi, buf 
		add	edi, eax
		xor	eax, eax
		xor	ebx, ebx
		mov	ecx, 10
loop:		mov	bl, [esi]
		cmp	bl, '0'
		jb	print	
		cmp	bl, '9'
		ja	print	
		sub	bl, '0'
		mul	ecx	
		add	eax, ebx 
		inc	esi
		cmp	edi, esi
		jnz	loop
print:		test	eax, eax
		jz	_start	
		mov	esi, eax	; initial number
lp3:		cmp	esi, 1024
		ja	dec_num
		mov	eax, esi
		xor	esi, esi	
		jmp	form_str
dec_num:	sub	esi, 1024
		mov	eax, 1024
form_str:	mov	edx, eax	; for print
		mov	ecx, eax	; loop counter
		mov	al, '*'
		mov	edi, buf
		cld
lp2:		stosb
		loop lp2
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80	
		test	esi, esi
		jnz	lp3
		mov	[buf], byte 0xa
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		mov	edx, 1 
		int	0x80
		jmp	_start
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return value
		int	0x80
