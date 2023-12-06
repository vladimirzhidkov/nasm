 #-*- Makefile -*-

EXEC = a.out
OBJS = start.o fill_mem.o
AS = nasm
LD = ld 
AS_FLAGS = -f elf
LD_FLAGS = -m elf_i386

ifdef DEBUG 
AS_FLAGS += -g -F dwarf
endif

#Rules
default:
	make $(EXEC) DEBUG=1
release: 
	make clean $(EXEC) DEBUG=

$(EXEC): $(OBJS)
	$(LD) $(LD_FLAGS) $(OBJS) -o $(EXEC)

# pattern rule, @ is target, < is dependency
%.o: %.asm
	$(AS) $(AS_FLAGS) -o $@ $<

clean:
	find . -type f -name "*.o" -exec rm -f {} \;
	rm -f *.out
