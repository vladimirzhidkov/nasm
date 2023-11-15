section .bss
buf:		resb	512

section .text
global _start
_start:

read:		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512
		int	0x80
		test	eax, eax	; holds number or characters or 0 for EOF
		jz	exit

		; count +/- symbols
		mov	ecx, eax	; loop counter
		mov	esi, buf
		cld
		xor	ebx, ebx	; counter for '+'
		xor	edx, edx	; counter for '-'
lp1:
		lodsb
if1:		
		cmp	al, '+'
		jnz	if2	
		inc	ebx		
		jmp	endif
if2:	
		cmp	al, '-'
		jnz	endif
		inc	edx
endif:	
		loop	lp1		
multiply:
		mov	eax, ebx	
		mul	dl
		
		; store result of multiplication for later use
		mov	edx, eax

		; check for zero result	
		test	edx, edx
		jz	exit		
		
		; form string of * with length of eax
		mov	ecx, eax	; loop counter
		mov	edi, buf
		cld
		mov	al, '*'
lp2:
		stosb			; al->[edi]; inc edi
		loop	lp2
		mov	byte[edi], 0xa	; add newline	
		inc	edx
print:
		mov	eax, 4	; sys_write
		mov	ebx, 1	; stdout
		mov	ecx, buf
		; edx was set above after multiplication
		int	0x80 

exit:
		mov	eax, 1	; sys_exit
		mov	ebx, 0	; return status
		int	0x80	; call kernel
