section .bss
buf		resb	4096	

section .text
global _start
_start:
		; read from stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 4096 
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
		
print:		; form string of *
		mov	edx, eax	; for print
		mov	ecx, eax	; loop counter
		mov	al, '*'
		jecxz	_start
		mov	edi, buf
		cld
lp2:		stosb
		loop lp2
		mov	[edi], byte 0xa	; newline character
		inc	edx
		; print it
stop:		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80	
		jmp	_start
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return value
		int	0x80
