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

		; check if it's a digit. if it is, store it in al
		mov	al, [buf]	; get input character
		sub	al, '0'		; convert it to digit 
		js	exit		; < 0
		cmp	al, 10		; 
		jns	exit		; > 9

		; create a string of '*' with length = AL. ECX is end of string
		xor	ecx, ecx
loop:
		cmp	cl, al
		jz	done	
		mov	byte[str + ecx], '*'
		inc	ecx	
		jmp	loop		
done:	
		mov	byte[str + ecx], 0xA	; newline character
		inc	ecx			; length of str
print:
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	edx, ecx	; length
		mov	ecx, str	; string to print 
		int	0x80		; call kernel 	
exit:
		mov	eax, 1	; sys_exit
		mov	ebx, 0	; return status
		int	0x80	; call kernel
