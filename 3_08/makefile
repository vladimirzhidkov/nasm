 #-*- Makefile -*-

OBJS = start.o
AS = nasm
LD = ld 
ASFLAGS = -f elf 
LDFLAGS = -m elf_i386

ifdef DEBUG 
ASFLAGS += -g -F dwarf 
endif

#Rules
default:
	./build_debug.sh

a.out: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o a.out

# pattern rule, @ is target, < is dependency
%.o: %.asm
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	find . -type f -name "*.o" -exec rm -f {} \;
	rm -f *.out
