section .bss
in:		resb	256
out:		resb	512

section .text
global _start
_start:
		; read from stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, in 
		mov	edx, 512
		int	0x80
		
		; check for EOF
		test	eax, eax
		jz	exit

		; iterate through buf
		; al is current character
		; ah is 0 if outside word
		;	1 if inside word 
		; ecx is loop counter
		mov	ecx, eax
		xor	eax, eax
		mov	esi, in 
		mov	edi, out 
lp1:		lodsb
		; if al == ' ' || al == '\n'
		;	check if prev position (ah != 0) was inside word
		;else
		;	check if prev position (ah == 0) was outside word
		cmp	al, ' '
		jnz	or
		; current character (al) is ' ' or '\n'
chk_ah1:	; check if prev position was inside word (ah != 0) 
		test	ah, ah
		jz	cpy
		mov	[edi], byte ')'
		inc	edi
		xor	ah, ah
		jmp	cpy	
or:		cmp	al, 0xa		; newline character
		jz	chk_ah1
else:		; current character (al) is not ' ' or '\n'	
		; check if prev position  was outside word (ah == 0)
		test	ah, ah
		jnz	cpy	
		mov	[edi], byte '('
		inc	edi
		mov	ah, 1
cpy:		; copy al->out
		mov	[edi], al
		inc	edi
		loop lp1 
		
		; print from out
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, out
		mov	edx, edi
		sub	edx, out
		int	0x80
		jmp	_start
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80 
