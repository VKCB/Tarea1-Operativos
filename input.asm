section .bss
    key_pressed resb 1

section .text
global read_input

; Función para leer la entrada del teclado
read_input:
    ; Llamar a la interrupción del BIOS para leer un carácter del teclado
    mov ah, 00h   ; Función de interrupción para leer tecla (bloqueante)
    int 16h       ; Llamar a la interrupción del BIOS

    ; Guardar la tecla presionada en 'key_pressed'
    mov [key_pressed], al

    ; Comparar la tecla presionada y actualizar dirección del jugador 1
    cmp al, 48    ; Flecha arriba (código ASCII extendido)
    je move_up_player1
    cmp al, 50    ; Flecha abajo
    je move_down_player1
    cmp al, 4B    ; Flecha izquierda
    je move_left_player1
    cmp al, 4D    ; Flecha derecha
    je move_right_player1

    ; Comparar la tecla presionada y actualizar dirección del jugador 2
    cmp al, 'W'   ; Jugador 2 arriba
    je move_up_player2
    cmp al, 'S'   ; Jugador 2 abajo
    je move_down_player2
    cmp al, 'A'   ; Jugador 2 izquierda
    je move_left_player2
    cmp al, 'D'   ; Jugador 2 derecha
    je move_right_player2

    ret

move_up_player1:
    ; Código para mover el jugador 1 hacia arriba
    ret

move_down_player1:
    ; Código para mover el jugador 1 hacia abajo
    ret

move_left_player1:
    ; Código para mover el jugador 1 hacia la izquierda
    ret

move_right_player1:
    ; Código para mover el jugador 1 hacia la derecha
    ret

move_up_player2:
    ; Código para mover el jugador 2 hacia arriba
    ret

move_down_player2:
    ; Código para mover el jugador 2 hacia abajo
    ret

move_left_player2:
    ; Código para mover el jugador 2 hacia la izquierda
    ret

move_right_player2:
    ; Código para mover el jugador 2 hacia la derecha
    ret
