section .rodata
STR:		db	"This is a string."
LEN_STR:	equ	$ - STR
WORD_LONG:	db	"long "
LEN_WORD_LONG:	equ	$ - WORD_LONG

section .bss
new_str:	resb	LEN_STR + LEN_WORD_LONG

section .text
global _start
_start:		; copy STR to new_str 
		mov	esi, STR
		mov	edi, new_str
		mov	ecx, LEN_STR
		cld
		rep movsb

		; insert WORD_LONG -> new_str 
		mov	esi, new_str + LEN_STR - 1 
		mov	edi, new_str + LEN_STR + LEN_WORD_LONG - 1 
		mov	ecx, 7		; length of "string." 
		std
		rep movsb	
		mov	esi, WORD_LONG + LEN_WORD_LONG - 1
		mov	ecx, LEN_WORD_LONG
		rep movsb

exit:		mov	eax, 1		; sys_exit
		mov	ebx, 0		; return status
		int	0x80		; call kernel
