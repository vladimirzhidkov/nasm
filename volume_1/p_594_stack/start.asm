section .data
str:		db	"This is a string.", 0

section .text
global _start
_start:		; reverse string using stack
		xor	ebx, ebx	; current char
		xor 	ecx, ecx	; char count
next:		mov	bl, [str + ecx] 
		test	ebx, ebx
		jz	done
		push	ebx
		inc	ecx
		jmp	next
done:		jecxz	exit		; length is 0
		; copy back to str
		xor	eax, eax	
		mov	edi, str
nxt:		pop	ebx
		mov	[edi], bl
		inc	edi	
		loop	nxt	
exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
