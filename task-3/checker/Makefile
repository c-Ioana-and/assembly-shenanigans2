CC = gcc
CFLAGS = -m32 -no-pie -fno-pie -g
ASM = nasm
ASMFLAGS = -f elf32
MAKEFLAGS = --silent
TASKNAME = task3
LDFLAGS = -m32 -no-pie -fno-pie

checker: checker.o $(TASKNAME).o

$(TASKNAME).o: ../$(TASKNAME).asm
	$(ASM) $(ASMFLAGS) $^ -o $@

checker.o: checker.c

check:
	./check.sh

clean: 
	rm checker *.o
