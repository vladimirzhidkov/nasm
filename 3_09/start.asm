section .bss
buf:		resb	512

section .text
global _start
_start:

read:
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, buf
		mov	edx, 512	; num of characters
		int	0x80		; call kernel
; check for EOF
		test	eax, eax	; eax holds return value from sys_read
		jz	exit
write:
		mov	edx, eax	; num of characters
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, buf
		int	0x80		; call kernel
; go back to reading
		jmp	read
exit:
		mov	ebx, eax	; return status
		mov	eax, 1		; sys_exit
		int	0x80		; call kernel
