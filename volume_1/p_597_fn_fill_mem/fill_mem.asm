global fill_memory

section .text
fill_memory:	; edi = address, ecx = length, al = value
next:		jecxz	done	
		mov	[edi], al
		inc	edi
		loop	next	
done:		ret
