section .bss
line:		resb	512

section .data
yes:		db	"YES", 0xa
len_yes:	equ	$ - yes
no:		db	"NO", 0xa
len_no:		equ	$ - no

section .text
global _start
_start:
		; read line from stdin
		mov	eax, 3		; sys_read
		mov	ebx, 0		; stdin
		mov	ecx, line
		mov	edx, 512
		int	0x80

		; check for EOF
		test	eax, eax
		jz	exit

		; iterate through line
		; al is current character
		; ebx is paren accumulator. +1 for '(', -1 for ')' 
		; ecx is line length
		mov	esi, line
		cld
		mov	ecx, eax	
		xor	ebx, ebx	
loop:		lodsb			; [esi]->al; inc esi

		; if al == '(' then inc ebx
		cmp	al, '('
		jnz	if_cp	
		inc	ebx
		jmp	if_no_bal	
if_cp:		; if al == ')' then dec ebx
		cmp	al, ')'	
		jnz	next
		dec	ebx
if_no_bal:	; if ebx < 0 then parens are unbalanced. so print NO 
		cmp	ebx, 0
		jl	print_no	
next:		loop	loop

		; if ebx != 0 then print NO
		test	ebx, ebx
		jnz	print_no

print_yes:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, yes 
		mov	edx, len_yes
		int	0x80
		jmp	_start

print_no:	mov	eax, 4		; sys_write
		mov	ebx, 1		; stdout
		mov	ecx, no
		mov	edx, len_no
		int	0x80
		jmp	_start
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
