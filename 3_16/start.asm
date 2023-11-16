section .bss
buf:		resb	512

section .text
global _start
_start:
		; read stdin
		mov 	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80

		; check for EOF
		test	eax, eax
		jz	exit

		; iterate through line
		; al is current character
		; ebx is current word length
		; ecx is loop counter
		; edx is word counter
		xor	ebx, ebx
		mov	ecx, eax	; loop counter
		xor	edx, edx
		mov	esi, buf
		cld
lp1:		lodsb			
		; al is current character
		; if al == ' ' || al == '\n'		
		; 	count word (edx)
		; else
		; 	increment current word length (ebx)
		cmp	al, ' '
		jnz	or
		jmp	then	
or:		cmp	al, 0xa		; newline
		jnz	else
then:		; count word
		; if ebx != 0  
		;	increment word counter (edx)
		;	reset current word length (ebx)
		; else
		;	go to next iteration 
		test	ebx, ebx
		jz	next
		inc	edx
		xor	ebx, ebx
		jmp	next	
else:		; increment current word length
		inc	ebx
next:		loop	lp1

		; form string of * with length of word counter (edx)
		; al is '*'
		; ecx is loop counter
		; edx is length
		mov	al, '*'
		mov	ecx, edx
		jecxz	_start		; if word counter is 0, start all over		
		mov	edi, buf
		cld
lp2:		stosb
		loop	lp2	
		; add newline character
		mov	[edi], byte 0xa	
		inc	edx
		
		; print string of * to stdout
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		; edx was set above
		int	0x80
		jmp	_start
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status 
		int	0x80		; call kernel
