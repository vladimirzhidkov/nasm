section .bss
buf		resb	1024	

section .text
global _start
_start:
		; read from stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 1024 
		int	0x80

		; check for EOF
		test	eax, eax
		jz	exit

		; iterate through input
		; eax is accumulator that holds final number 
		; ebx is current character
		; ecx is 10
		; esi is address current character in buffer 
		; edi is buffer address + size 
		mov	esi, buf
		mov	edi, buf 
		add	edi, eax
		xor	eax, eax
		xor	ebx, ebx
		mov	ecx, 10
loop:		mov	bl, [esi]
		; if bl is a digit character
		cmp	bl, '0'
		jb	print	
		cmp	bl, '9'
		ja	print	
		; convert bl to a number
		sub	bl, '0'
		; multiply eax by 10 (ecx) and add current digit (ebx) to it
		mul	ecx	
		add	eax, ebx 
		; next iteration
		inc	esi
		cmp	edi, esi
		jnz	loop


print:		; check the funal number for 0
		test	eax, eax
		jz	_start	
		; print by 1024 at once so not to cause overflow
		mov	esi, eax	; initial number
lp3:		cmp	esi, 1024
		ja	dec_num
		mov	eax, esi
		xor	esi, esi	
		jmp	form_str
dec_num:	sub	esi, 1024
		mov	eax, 1024
form_str:	; form string of *
		mov	edx, eax	; for print
		mov	ecx, eax	; loop counter
		mov	al, '*'
		mov	edi, buf
		cld
lp2:		stosb
		loop lp2
		; print it
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80	
		; check esi
		test	esi, esi
		jnz	lp3
		; print newline character
		mov	[buf], byte 0xa
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		mov	edx, 1 
		int	0x80

		jmp	_start
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return value
		int	0x80
