section .bss
line:		resb	512
asterisks:	resb	512

section .data
len_longest:	dd	0
len_last_word:	dd	0
addr_last_word:	dd	0	; address of the beginning of the word

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

		; find the longest word
		xor	ebx, ebx	; current word length
		mov	ecx, eax	; loop counter
		mov	esi, line
		cld
loop:		lodsb			; [esi]->al; inc esi
		; al is current character
		; if (al == ' ' || al == '\n') 
if:		cmp	al, ' ' 
		jz	then		
		cmp	al, 0xa		
		jz	then		
		jmp	else
then:
		; save address and length of the current word
		; ebx is length
		; esi-1 is current position in line
		; if (length != 0)
		test	ebx, ebx
		jz	end_save_word
		mov	[len_last_word], ebx
		mov	[addr_last_word], esi	
		dec	dword[addr_last_word]
		sub	[addr_last_word], ebx	

end_save_word:
		; if (ebx > len_longest) then len_longest = ebx
		cmp	ebx, [len_longest]
		jb	reset			 
		mov	[len_longest], ebx	
reset:		; else ebx = 0
  		xor	ebx, ebx
		jmp	if_done
else:		; else ++ebx
		inc	ebx			
if_done:	loop	loop

		; form string of * for longest word
		mov	ecx, [len_longest]
		test	ecx, ecx
		jz	_start	
		mov	edi, asterisks 
		mov	al, '*'
		cld
lp1:		stosb				; al->[longest]; inc edi
		loop	lp1
		mov	byte[edi], 0xa		; newline character
		mov	edx, [len_longest]
		inc	edx

		; print asterisks 
		mov	eax, 4			; sys_write
		mov	ebx, 1			; stdout
		mov	ecx, asterisks 
		; edx is set above
		int	0x80

		; print last word. add newline at the end of it
		mov	eax, [addr_last_word]
		add	eax, [len_last_word]
		mov	[eax], byte 0xa
		mov	eax, 4			; sys_write
		mov	ebx, 1			; stdout
		mov	ecx, [addr_last_word]
		mov	edx, [len_last_word]
		inc	edx
		int	0x80			; call kernel	

		; reset
		; no need to reset addr_last_word, len_last_word
		; if input is empty, it never get to this point, jumps to _start if there is no longest word
		mov	dword[len_longest], 0	; reset len_longest
		jmp	_start	
exit:
		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
