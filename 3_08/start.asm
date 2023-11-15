section .bss
buf:		resb	2
str:		resb	10

section .text
global _start
_start:
		; read number
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin	
		mov	ecx, buf
		mov	edx, 2		; number of bytes to read
		int	0x80		; call kernel

		; check if it is [1-9]
		xor	ecx, ecx
		mov	cl, [buf]	; get input character
		cmp	cl, '1'		
		jb	exit		; < 1
		cmp	cl, '9'		
		ja	exit		; > 9

		; convert to number
		sub	cl, '0'

		; store number for later use in sys_write
		mov	edx, ecx	

		; create a string of '*' 
		mov	edi, str
		mov	al, '*'
		cld
lp:
		stosb		; AL->[EDI]; inc EDI
		loop	lp
		mov	byte[edi], 0xa	; add newline to the end of str
		inc	edx
print:
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, str	; string to print 
		int	0x80		; call kernel 	
exit:
		mov	eax, 1	; sys_exit
		mov	ebx, 0	; return status
		int	0x80	; call kernel
