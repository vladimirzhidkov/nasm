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

		; save string length to edx for later use in print
		mov	edx, eax

		; form string of *
		mov	ecx, eax
		mov	edi, buf
		mov	al, '*'
		cld
lp1:
		stosb			; al->[edi]; inc edi
		loop	lp1
lp1_done:
		mov	byte[edi], 0xa	; add newline
		inc	edx
print:
		mov	eax, 4
		mov	ebx, 1		; stdout
		mov	ecx, buf
		; edx is set above
		int	0x80
		
		; start over
		jmp	read
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
