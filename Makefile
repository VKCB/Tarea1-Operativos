# Makefile for gran_trak.asm
# This Makefile is used to assemble and link the gran_trak.asm file into an executable.
# It uses NASM for assembly and the GNU linker for linking.
# Compiler and flags
ASM = nasm
ASM_FLAGS = -f elf64 -g -l -F dwarf

# Executable and object names
TARGET = gran_trak
OBJECT = gran_trak.o

# Default rule to build and run the program
all: $(TARGET)

# Rule to assemble the .asm file into an object file
$(OBJECT): gran_trak.asm
  $(ASM) $(ASM_FLAGS) -o $(OBJECT) gran_trak.asm

# Rule to link the object file into an executable
$(TARGET): $(OBJECT)
  ld -o $(TARGET) $(OBJECT)

# Clean rule to remove generated files
clean:
  rm -f $(OBJECT) $(TARGET)
