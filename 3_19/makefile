OBJS = start.o

AS = nasm
LD = ld 

# nasm -f elf hello5.asm
# ld -m elf_i386 hello5.o -o hello5.out
ASFLAGS = -f elf -g -F dwarf 
LDFLAGS = -m elf_i386

#Rules

# defaut: link run

a.out: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o a.out

# pattern rules
# @ is target
# < is dependency
%.o: %.asm
	$(AS) $(ASFLAGS) $< -o $@

clean:
	find . -type f -name "*.o" -exec rm -f {} \;
	rm -f *.out
