section .bss
    key_pressed resb 1

section .text
global _start

_start:
    call read_input   ; Llamar a la función para leer teclado

    ; Imprimir la tecla presionada en pantalla
    mov ah, 0Eh      ; Función de BIOS para imprimir un carácter
    mov al, [key_pressed] ; Cargar la tecla leída
    int 10h          ; Llamar a la interrupción para mostrar en pantalla

    ; Salir del programa
    mov ax, 0x4C00
    int 21h

%include "input.asm"  ; Incluir el archivo input.asm
