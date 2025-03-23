build:
	nasm -f elf64 -o Gran_Trak_TEC.o Gran_Trak_TEC.asm -g -l Gran_Trak_TEC.lst -F dwarf
	ld -o Gran_Trak_TEC Gran_Trak_TEC.o

clean:
	rm arkanoid .*.swp
