# Makefile for gran_trak.asm
# This Makefile is used to assemble and link the gran_trak.asm file into an executable.

# Compiler and flags
ASM = nasm
ASM_FLAGS = -f elf64 
ASM_FLAGS_int = -g -l
ASM_FLAGS_end = -F dwarf

# Executable and object names
TARGET = Gran_Trak_TEC
OBJECT = Gran_Trak_TEC.o

# Default rule to build and run the program
all: $(TARGET)

# Rule to assemble the .asm file into an object file
$(OBJECT): Gran_Trak_TEC.asm
	$(ASM) $(ASM_FLAGS) -o $(OBJECT) Gran_Trak_TEC.asm $(ASM_FLAGS_int) Gran_Trak_TEC.lst $(ASM_FLAGS_end)

# Rule to link the object file into an executable
$(TARGET): $(OBJECT)
	ld -o $(TARGET) $(OBJECT)

# Clean rule to remove generated files
clean:
	rm -f $(OBJECT) $(TARGET)

# Run the program
run: $(TARGET)
	./$(TARGET)