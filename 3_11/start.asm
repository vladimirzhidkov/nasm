section .bss
buf:		resb	512

section .text
global _start
_start:

read:
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80
		
		; check for EOF
		test	eax, eax
		jz	exit	
	
		; count sum of all digits
		xor	edx, edx	; sum
		mov	ecx, eax	; loop counter
		xor	eax, eax
		mov	esi, buf
		cld
lp1:
		lodsb			; [esi]->al; inc esi
	if:	cmp	al, '1'
		jb	endif
		cmp	al, '9'
		ja	endif
		sub	al, '0'		; get actual digit 
		add	edx, eax
	endif:
		loop	lp1
lp1_done:
		; form string of * with length of EBX
		mov	ecx, edx
		jecxz	exit
		mov	edi, buf
		cld
		mov	al, '*'
lp2:
		stosb			; al->[edi]; inc edi
		loop	lp2
		mov	byte[edi], 0xa	; add newline character
		inc	edx	
print:
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf 
		; edx was set above
		int	0x80
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
