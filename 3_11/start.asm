section .bss
buf:		resb	512

section .data
ok:		db	"OK", 0xa
len_ok		equ	$ - ok

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
print:
		mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, ok
		mov	edx, len_ok
		int	0x80
		jmp	read
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80
