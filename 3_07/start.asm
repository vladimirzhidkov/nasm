section .bss
buffer:	resb 2		; reserve 1 byte for a letter, and the second one for press enter

section .data
yes	db 'YES', 0xA	; followed by newline
len_yes	equ $ - yes	; length

no	db 'NO', 0xA
len_no	equ $ - no	


section .text
global _start
_start:
		; read from stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin file descriptor
		mov	ecx, buffer
		mov	edx, 2		; number of bytes to read
		int	0x80

		; check if buffer[0] is 'A'
		mov	al, [buffer]
		cmp	al, 'A' 
		jnz	print_no

print_yes:
		mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	ecx, yes
		mov	edx, len_yes	; length
		int	0x80
		jmp	exit
print_no:
		mov	eax, 4		; sys_write
		mov	ebx, 1  	; stdout
		mov	ecx, no 
		mov	edx, len_no	; length
		int	0x80
exit:
		mov	ebx, 0	; return status
		mov	eax, 1	; sys_exit
		int	0x80	; call kernel 
