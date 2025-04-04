bits 64
default rel


; Definicion de caracteres 
	sys_read: equ 0	
	sys_write:	equ 1
	sys_nanosleep:	equ 35
	sys_nanosleep2:	equ 200
	sys_time:	equ 201
	sys_fcntl:	equ 72

	char_equal: equ 61 
	char_aster: equ 42
	char_may: equ 62  
	char_men: equ 60 
	char_dosp: equ 58
	char_comillas: equ 71 ;Letra que identifica al Jugador 1
	char_comilla: equ 39 
	char_space: equ 32 
	left_direction: equ -1
	right_direction: equ 1
	up_direction: equ 2
	down_direction: equ 3
	char_bot1: equ 98 ; Letra que identifica al bot1 blue
	char_bot2: equ 98 ; Letra que identifica al bot1 blue
	char_bot3: equ 98 ; Letra que identifica al bot1 blue
	char_player2: equ 82 ; Letra que identifica al Jugador 2



STDIN_FILENO: equ 0			;Se utiliza en llamadas al sistema que requieren un descriptor de archivo, por ejemplo, al leer de la entrada estándar

F_SETFL:	equ 0x0004		;Se pasa como segundo argumento a la llamada al sistema fcntl para indicar que queremos cambiar los flags del descriptor de archivo.
O_NONBLOCK: equ 0x0004		;Se utiliza como tercer argumento en la llamada al sistema fcntl para indicar que el descriptor de archivo debe operar en modo no bloqueante.

;definicion de pantalla en limpio
	row_cells:	equ 24	;Numero de filas que caben en la pantalla
	column_cells: 	equ 110 ; set to any (reasonable) value you wish
	array_length:	equ row_cells * column_cells + row_cells ;(+ 32 caracteres de nueva línea)

;sleep time
timespec:
    tv_sec  dq 0
    tv_nsec dq 20000000		;0.02 s

timespec2:
    tv_sec2  dq 0
    tv_nsec2 dq 2000000000000		;0.02 s

;limpieza de la pantalla
clear:		db 27, "[2J", 27, "[H"	;2J: Esta es una secuencia de escape ANSI que indica Clear screen
clear_length:	equ $-clear			;H: Indica reposicionamiento del cursor.

; Texto mostrado en la pantalla de inicio
	
	msg13: db "               ", 0xA, 0xD
	msg1: db "     					   TECNOLOGICO DE COSTA RICA        ", 0xA, 0xD
	msg14: db "               ", 0xA, 0xD
	msg17: db "               ", 0xA, 0xD
	msg18: db "               ", 0xA, 0xD
	msg2: db "						Valerin Calderon       ", 0xA, 0xD
	msg5: db "						Yendry Badilla         ", 0xA, 0xD
	msg15: db "						Andrés Molina          ", 0xA, 0xD
	msg6: db "               ", 0xA, 0xD
	msg7: db "               ", 0xA, 0xD
	msg8: db "               ", 0xA, 0xD
	msg9: db "               ", 0xA, 0xD
	msg16: db "               ", 0xA, 0xD 
	msg3: db "						GRAN TRAK TEC        ", 0xA, 0xD

	msg19: db "               ", 0xA, 0xD
	msg20: db "               ", 0xA, 0xD
	msg21: db "               ", 0xA, 0xD
	msg22: db "               ", 0xA, 0xD
	msg23: db "               ", 0xA, 0xD 
	msg24: db "               ", 0xA, 0xD
	msg25: db "               ", 0xA, 0xD
	msg26: db "               ", 0xA, 0xD 
	msg4: db "      					   PRESIONE ENTER PARA INICIAR        ", 0xA, 0xD
	msg1_length:	equ $-msg1
	msg2_length:	equ $-msg2
	msg3_length:	equ $-msg3
	msg4_length:	equ $-msg4
	msg5_length:	equ $-msg5
	msg13_length:	equ $-msg13
	msg14_length:	equ $-msg14
	msg15_length:	equ $-msg15
	msg16_length:	equ $-msg16
	msg17_length:	equ $-msg17 
	msg6_length:	equ $-msg6 
	msg7_length:	equ $-msg7 
	msg8_length:	equ $-msg8 
	msg9_length:	equ $-msg9 
	msg18_length:	equ $-msg18
	msg19_length:	equ $-msg19
	msg20_length:	equ $-msg20
	msg21_length:	equ $-msg21
	msg22_length:	equ $-msg22
	msg23_length:	equ $-msg23
	msg24_length:	equ $-msg24
	msg25_length:	equ $-msg25
	msg26_length:	equ $-msg26

	game_over_msg db "El juego ha finalizado", 0xA, 0xD
	game_over_msg_length equ $-game_over_msg

	; Usefull macros (Como funciones reutilizables)
 
	%macro setnonblocking 0		;Configura la entrada estándar para que funcione en modo no bloqueante
		mov rax, sys_fcntl
		mov rdi, STDIN_FILENO
		mov rsi, F_SETFL
		mov rdx, O_NONBLOCK
		syscall
	%endmacro

	%macro unsetnonblocking 0	;Restablece la entrada estándar al modo bloqueante
		mov rax, sys_fcntl
		mov rdi, STDIN_FILENO
		mov rsi, F_SETFL
		mov rdx, 0
		syscall
	%endmacro

	%macro full_line 0			;Linea completa de X
		times column_cells db "X"
		db 0x0a, 0xD
	%endmacro

	;Esta parte es para la creacion de la pista

	%macro up_down_pista 0			;Parte de arriba de la pista
		db "X"
		times 9 db " "
		times 90 db "O"
		times 9 db " "
		db "X"
		db 0x0a, 0xD
	%endmacro

	%macro right_pista1 0		;Crea una línea con 'X' en los extremos y espacios en el medio, seguida de una nueva línea
		db "X"
		times 9 db " "
		db "O"
		times 88 db " "
		db "O"
		times 9 db " "
		db "X", 0x0a, 0xD
	%endmacro

	%macro right_pista2 0		;Crea una línea con 'X' en los extremos y espacios en el medio, seguida de una nueva línea
		db "X"
		times 9 db " "
		db "O"
		times 70 db " "
		times 19 db "O"
		times 9 db " "
		db "X", 0x0a, 0xD
	%endmacro

	%macro right_pista3 0		;Crea una línea con 'X' en los extremos y espacios en el medio, seguida de una nueva línea
		db "X"
		times 9 db " "
		db "O"
		times 70 db " "
		db "O"
		times 27 db " "
		db "X", 0x0a, 0xD
	%endmacro

	%macro right_pista4 0		;Crea una línea con 'X' en los extremos y espacios en el medio, seguida de una nueva línea
		db "X"
		times 9 db " "
		db "O"
		times 70 db " "
		db "O"
		times 4 db " "
		times 23 db "O"
		db "X", 0x0a, 0xD
	%endmacro

	; Fin de la creacion de la pista

	%macro marcador_j1 0			;Crea una línea completa de 'O' seguida de una nueva línea marcadores
		db "X PLAYER 1 TURNS: "
		times 60 db " "
		db "Time:"
		times 26 db " "
		db "X"
		db 0x0a, 0xD
	%endmacro

	%macro marcador_j2 0			;Crea una línea completa de 'O' seguida de una nueva línea
		db "X PLAYER 2 TURNS: "
		times 91 db " "
		db "X"
		db 0x0a, 0xD
	%endmacro

	%macro hollow_line 0		;Crea una línea con 'X' en los extremos y espacios en el medio, seguida de una nueva línea
		db "X"
		times column_cells-2 db char_space	;A 80 le resta las 2 X de los extremos e imprime 78 espacios
		db "X", 0x0a, 0xD
	%endmacro

	%macro print 2				;Imprime una cadena especificada en la salida estándar
		mov eax, sys_write
		mov edi, 1 	; stdout
		mov rsi, %1				;Parametro 1 que se pasa en donde se llama al macro
		mov edx, %2				;Parametro 2
		syscall
	%endmacro

	;Esta es la funcion que obtiene lo que uno ingrese
	%macro getchar 0			;Lee un solo carácter de la entrada estándar y lo almacena en input_char
		mov     rax, sys_read
		mov     rdi, STDIN_FILENO
		mov     rsi, input_char
		mov     rdx, 1 ; number of bytes
		syscall         ;read text input from keyboard
	%endmacro

	%macro sleeptime 0			;Suspende la ejecución del programa durante el tiempo especificado
		mov eax, sys_nanosleep
		mov rdi, timespec
		xor esi, esi		; ignore remaining time in case of call interruption
		syscall			; sleep for tv_sec seconds + tv_nsec nanoseconds
	%endmacro

global _start

section .bss

	buffer resb 5  ; Buffer para almacenar los dígitos convertidos

	input_char resq 1 

	temp_char resb 1
	random_value resb 1 ; Número random obtenido (renombrado para evitar conflicto)
	random2_value resb 1 ; Número random adicional (renombrado para evitar conflicto)
	start_time resq 1  ; Variable para almacenar el tiempo inicial
	current_time resq 1 ; Variable para almacenar el tiempo actual

	; Bots
	bot_random resb 1 ; Número random obtenido para el bot (renombrado)
 	random_result resq 1
  	bot_speed resq 1
  	bot_counter resq 1
	bot_direction resq 1  ; Variable para almacenar la direccion actual del bot
	bot_first_move resb 1  ; Variable para rastrear si el bot ya realizó su primer movimiento (0 = no, 1 = sí)
	bot_path_state resb 1  ; Estado actual en la ruta predefinida (0-7)


section .data 


	urandom db '/dev/urandom', 0
	newline db 10, 0

	score dq 0
	score_position dq board + 19 + 10* (column_cells + 2)

		time_msg db "Tiempo restante: ", 0
		time_msg_length equ $-time_msg
		time_buffer db "00", 0  ; Buffer para mostrar los segundos restantes como texto
		time_buffer_length equ $-time_buffer

	board:
		full_line
		marcador_j1
		marcador_j2 
		full_line
        %rep 3  ; 3 = linea superior+linea inferior+linea de comandos 
        hollow_line
        %endrep 

		up_down_pista


        right_pista2

       %rep 2  ; 3 = linea superior+linea inferior+linea de comandos 
        right_pista3
        %endrep

		right_pista4
		right_pista4
		right_pista4

       %rep 2  ; 3 = linea superior+linea inferior+linea de comandos 
        right_pista3
        %endrep 

		right_pista2


		up_down_pista

		%rep 3  ; 3 = linea superior+linea inferior+linea de comandos 
        hollow_line
        %endrep

        full_line
	board_size:   equ   $ - board

	; Added for the terminal issue	
		termios:        times 36 db 0	;Define una estructura de 36 bytes inicializados a 0. Esta estructura es utilizada para almacenar las configuraciones del terminal
		stdin:          equ 0			;Define el descriptor de archivo para la entrada estándar (stdin), que es 0
		ICANON:         equ 1<<1		;Canonico la entrada no se envía al programa hasta que el usuario presiona Enter
		ECHO:           equ 1<<3		;Bandera que habilita o deshabilita este modo
		VTIME: 			equ 5
		VMIN:			equ 6
		CC_C:			equ 18


	pallet_position dq board + 85 + ((column_cells + 2) * 10) ; El 1 es el movimiento horizontal y  en ((column_cells + 2) * 12) el 12 es el movimiento vertical 
	pallet_size dq 3

	bot_initial_position dq board + 85 + ((column_cells + 3) * 10)  ;posición inicial
	bot_position dq board + 85 + ((column_cells + 3) * 10) ; El 1 es el movimiento horizontal y  en ((column_cells + 2) * 12) el 12 es el movimiento vertical
	player2_position dq board + 82 + ((column_cells + 2) * 10) ; Posición inicial del Jugador 2
	pared1_x_pos: dq 30 ;0-59
	pared1_y_pos: dq 1
	pared2_x_pos: dq 80 ;0-59
	pared2_y_pos: dq 1
		colen: dq 21
		colj: dq 0
		cole: dq 0
		pared: dq 21
		colplayer: dq 0 


section .text
;;;;;;;;;;;;;;;;;;;;for the working of the terminal;;;;;;;;;;;;;;;;;
canonical_off:										;La entrada se procese carácter por carácter sin esperar a que se presione Enter.
        call read_stdin_termios						;Guarda los atributos actuales del terminal en la variable termios

        ; clear canonical bit in local mode flags	
        push rax						
        mov eax, ICANON								;Carga el valor de la constante ICANON (que representa el bit del modo canónico) en eax
        not eax										;Niega todos los bits en eax
        and [termios+12], eax						;Limpia el bit canónico en las banderas de modo local
		mov byte[termios+CC_C+VTIME], 0				;Establecen VTIME y VMIN en 0 para que el terminal no espere caracteres adicionales
		mov byte[termios+CC_C+VMIN], 0
        pop rax

        call write_stdin_termios					;Escribe los atributos modificados de termios de vuelta al terminal
        ret

echo_off:											;No se muestran los caracteres introducidos
        call read_stdin_termios

        ; clear echo bit in local mode flags
        push rax
        mov eax, ECHO
        not eax
        and [termios+12], eax
        pop rax

        call write_stdin_termios
        ret

canonical_on:										;La entrada se procesa en líneas completas. Espera hasta que el usuario presione Enter
        call read_stdin_termios

        ; set canonical bit in local mode flags
        or dword [termios+12], ICANON
		mov byte[termios+CC_C+VTIME], 0			;Tiempo en decisegundos que el terminal espera para la entrada.
		mov byte[termios+CC_C+VMIN], 1			;El número mínimo de caracteres que se deben leer
        call write_stdin_termios
        ret

echo_on:											;Se muestran los caracteres introducidos
        call read_stdin_termios

        ; set echo bit in local mode flags
        or dword [termios+12], ECHO

        call write_stdin_termios
        ret

read_stdin_termios:									;Lee los atributos del terminal y los guarda en la variable termios
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, stdin
        mov ecx, 5401h
        mov edx, termios
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

write_stdin_termios:								;Escribe los atributos del terminal utilizando la llamada al sistema 
        push rax
        push rbx
        push rcx
        push rdx

        mov eax, 36h
        mov ebx, stdin
        mov ecx, 5402h
        mov edx, termios
        int 80h

        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

;;;;;;;;;;;;;;;;;;;;end for the working of the terminal;;;;;;;;;;;;

; Function: print_pallet
; This function moves the pallet in the game
; Arguments: none
;
; Return;
;	void
print_pallet:
  
	mov r8, [pallet_position] 
	.write_pallet:
		mov byte [r8], char_comillas
	ret

; Function: move_pallet
; Mueve al Jugador 1 en la direccion especificada
; Argumentos:
;   rdi: direccion (up_direction, down_direction, left_direction, right_direction)
; Return:
;	void
move_pallet:

	push rax
	push rcx

	mov r13, [colj]
	cmp r13, 1
	je .endp
	  
	cmp rdi, up_direction					; Comparar el valor de rdi (dirección) con left_direction
	je .move_up						; Si no es igual a left_direction, saltar a .move_right

	cmp rdi, down_direction
	je .move_down

	cmp rdi, right_direction
	je .move_right

	cmp rdi, left_direction
	je .move_left

	.move_up:
		mov r8, [pallet_position]

		; INICIO DE COMPARACIONES PARA LAS COLISIONES
		cmp r8, board + 109 + ((column_cells + 2) * 4)
		jl .endp

		cmp r8, board + 82 + ((column_cells + 2) * 9)
		je .endp 
		cmp r8, board + 83 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 84 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 85 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 86 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 87 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 88 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 89 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 90 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 91 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 92 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 93 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 94 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 95 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 96 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 97 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 98 + ((column_cells + 2) * 9)
		je .endp
		cmp r8, board + 99 + ((column_cells + 2) * 9)
		je .endp

		cmp r8, board + 86 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 87 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 88 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 89 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 90 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 91 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 92 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 93 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 94 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 95 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 96 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 97 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 98 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 99 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 100 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 101 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 102 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 103 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 104 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 105 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 106 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 107 + ((column_cells + 2) * 14)
		je .endp
		cmp r8, board + 108 + ((column_cells + 2) * 14)
		je .endp

		cmp r8, board + 9 + ((column_cells + 2) * 18)  ; Comparar con 81
		jle .fuera_rango  ; Si rax <= 81, salir

		cmp r8, board + 100 + ((column_cells + 2) * 18) ; Comparar con 100
		jge .fuera_rango  ; Si rax >= 100, salir

		; Aquí entra si 81 < r8 < 100
		jmp .continuar    

		.fuera_rango:
			mov r9, [pallet_size]
			mov byte [r8], char_space	; Limpiar último carácter del palet
			sub r8, 112						; Mover una fila arriba (restar 320)
			mov [pallet_position], r8			; Actualizar posición

		jmp .endp

		.continuar:
			jmp .endp

	.move_down:

		mov r8, [pallet_position]

		cmp r8, board + 86 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 87 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 88 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 89 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 90 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 91 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 92 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 93 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 94 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 95 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 96 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 97 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 98 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 99 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 100 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 101 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 102 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 103 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 104 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 105 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 106 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 107 + ((column_cells + 2) * 10)  
		je .endp
		cmp r8, board + 108 + ((column_cells + 2) * 10)  
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 83 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 84 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 85 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 86 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 87 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 88 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 89 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 90 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 91 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 92 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 93 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 94 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 95 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 96 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 97 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 98 + ((column_cells + 2) * 15)
		je .endp
		cmp r8, board + 99 + ((column_cells + 2) * 15)
		je .endp
		
		cmp r8, board + ((column_cells + 2) * 20)
		jg .endp


		cmp r8, board + 9 + ((column_cells + 2) * 6)  
		jle .fuera_rango_down  ; Si rax <= 81, salir

		cmp r8, board + 100 + ((column_cells + 2) * 6) 
		jge .fuera_rango_down  ; Si rax >= 100, salir

		

		; Aquí entra si 81 < r8 < 100
		jmp .continuar    

		.fuera_rango_down:
			mov r9, [pallet_size]
			mov byte [r8], char_space	; Limpiar último carácter del palet
			add r8, 112							; Mover una fila abajo (sumar 320)
			mov [pallet_position], r8			; Actualizar posición


		jmp .endp	

		.continuar_down:
			jmp .endp



		
		

	.move_left:

		mov r13, [colj]
		cmp r13, 1
		je .endp

		mov r8, [pallet_position]

		; INICIO DE COMPARACIONES PARA LAS COLISIONES
		cmp r8, board + 1 + ((column_cells + 2) * 4)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 5)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 6)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 7)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 8)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 9)
		je .endp 
	
		cmp r8, board + 1 + ((column_cells + 2) * 10)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 11)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 12)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 12)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 13)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 14)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 15)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 16)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 17)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 18)
		je .endp 

		cmp r8, board + 1 + ((column_cells + 2) * 19)
		je .endp

		cmp r8, board + 1 + ((column_cells + 2) * 20)
		je .endp

		cmp r8, board + 100 + ((column_cells + 2) * 7)
		je .endp

		cmp r8, board + 100 + ((column_cells + 2) * 8)
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 9)
		je .endp

		;-----COLISION PARTE INTERNA DE LA CURVA-----
		cmp r8, board + 82 + ((column_cells + 2) * 10)
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 11)
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 12)
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 13)
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 14)
		je .endp

		cmp r8, board + 82 + ((column_cells + 2) * 15)
		je .endp
		;---FIN COLISION PARTE INTERNA DE LA CURVA----

		cmp r8, board + 100 + ((column_cells + 2) * 16)
		je .endp

		cmp r8, board + 100 + ((column_cells + 2) * 17)
		je .endp

		mov r9, [pallet_size]
		mov byte [r8], char_space	; Limpiar el último carácter del palet
		dec r8								; Mover la posición del palet una unidad a la izquierda
		mov [pallet_position], r8			; Actualizar la posición del palet en la memoria

		jmp .endp	
							 
	.move_right:

		mov r13, [colj]
		cmp r13, 2
		je .endp

		mov r8, [pallet_position]

		
		cmp r8, board + 108 + ((column_cells + 2) * 4)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 5)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 6)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 7)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 8)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 9)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 10)
		je .endp

		cmp r8, board + 85 + ((column_cells + 2) * 11)
		je .endp

		cmp r8, board + 85 + ((column_cells + 2) * 12)
		je .endp

		cmp r8, board + 85 + ((column_cells + 2) * 13)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 14)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 15)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 16)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 17)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 18)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 19)
		je .endp

		cmp r8, board + 108 + ((column_cells + 2) * 20)
		je .endp

		mov byte [r8], char_space
		inc r8
		mov [pallet_position], r8
 


	.endp:
		mov qword [colj], 0

	pop rax
	pop rcx
	 
	ret

; Primera definición
print_bot1:
    mov r9, [bot_position]
    .write_pallet_bot1:
        mov byte [r9], char_bot1
    ret

; Segunda definición
print_bot1_position:
    mov r10, [bot_position]
    .write_pallet_bot2:
        mov byte [r10], char_bot1
    ret

; Funcion generar un numero aleatorio entre 100 y 150 para la velocidad 
generate_random:
    ; Abrir /dev/urandom para leer un byte aleatorio
	push rdi
	push rsi
	push rdx
	push rax

    mov rax, 0                ; sys_read
    mov rdi, urandom          ; Descriptor de archivo para /dev/urandom
    mov rsi, random_value     ; Dirección donde se guarda el byte aleatorio
    mov rdx, 1                ; Leer 1 byte
    syscall                   ; Llamada al sistema para leer

    ; Reducir el rango del número aleatorio a 0-49
    movzx rax, byte [random_value]  ; Cargar el byte aleatorio en rax
    xor rdx, rdx              ; Limpiar rdx para la division
    mov rcx, 50               ; Divisor (rango deseado: 50 numeros)
    div rcx                   ; rax = rax / rcx, rdx = rax % rcx
    ; Ahora rdx contiene el número aleatorio en el rango 0-49

    ; Ajustar el rango base a 100-150
    add rdx, 100 ; suma 100 para obtener el rango deseado

    ; Guardar el resultado en una variable o registro
    mov [random_result], rdx  ; Guardar el número aleatorio generado

	pop rdi
	pop rsi
	pop rdx
	pop rax

    ret

; Funcion: generate_random_low
; Genera un número aleatorio entre 0 y 10
; Return:
;   rdx: Número aleatorio en el rango 0-10
generate_random_low:
    ; Abrir /dev/urandom para leer un byte aleatorio
    push rdi
    push rsi
    push rdx
    push rax

    mov rax, 0                ; sys_read
    mov rdi, urandom          ; Descriptor de archivo para /dev/urandom
    mov rsi, random_value     ; Dirección donde se guarda el byte aleatorio
    mov rdx, 1                ; Leer 1 byte
    syscall                   ; Llamada al sistema para leer

    ; Reducir el rango del número aleatorio a 0-10
    movzx rax, byte [random_value]  ; Cargar el byte aleatorio en rax
    xor rdx, rdx              ; Limpiar rdx para la división
    mov rcx, 4               ; Divisor (rango deseado: 11 números, de 0 a 10)
    div rcx                   ; rax = rax / rcx, rdx = rax % rcx
    ; Ahora rdx contiene el número aleatorio en el rango 0-10

    ; Guardar el resultado en una variable o registro
    mov [random_result], rdx  ; Guardar el número aleatorio generado

    pop rdi
    pop rsi
    pop rdx
    pop rax

    ret

; Función: set_bot_speed
; Establece la velocidad del bot de manera aleatoria
set_bot_speed:
	push rdx
	; Llamar a la funcion para generar numero random
	call generate_random
	; ; Guardar el numero aleatorio en la variable de velocidad del bot
	; mov [bot_speed], rdx ; Guardar el número aleatorio generado en bot_speed

	; pop rdx
	; ret
	; Invertir el valor (mayor número = mayor velocidad)
    mov rax, 150                ; Valor máximo
    sub rax, rdx                ; Restar el número generado (100-150)
    add rax, 100                ; Ajustar nuevamente al rango 50-100
    mov [bot_speed], rax        ; Guardar el número invertido
    pop rdx
    ret


; Función: move_bot
; Mueve el bot en la dirección definida
; Return:
;   void
move_bot:

	push rax
	push rcx

	mov r11, [colj]              ; Cargar el valor de la variable `colj` en r11
	cmp r11, 1                   ; Comparar el valor de `colj` con 1
	je .endp                     ; Si `colj` es igual a 1, saltar al final de la función
    
	cmp rdi, up_direction					; Comparar el valor de rdi (dirección) con left_direction
	je .move_up						; Si no es igual a left_direction, saltar a .move_right

	cmp rdi, down_direction
	je .move_down

	cmp rdi, right_direction
	je .move_right

	cmp rdi, left_direction
	je .move_left

	; Si no coincide con ninguna dirección, salir
    jmp .endp
							 
	.move_up:
		mov r10, [bot_position]

		; INICIO DE COMPARACIONES PARA LAS COLISIONES
		cmp r10, board + 109 + ((column_cells + 2) * 4)
		jl .endp

		cmp r10, board + 82 + ((column_cells + 2) * 9)
		je .endp 
		cmp r10, board + 83 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 84 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 85 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 86 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 9)
		je .endp

		cmp r10, board + 86 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 100 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 101 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 102 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 103 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 104 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 105 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 106 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 107 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 108 + ((column_cells + 2) * 14)
		je .endp

		cmp r10, board + 9 + ((column_cells + 2) * 18)  ; Comparar con 81
		jle .fuera_rango  ; Si rax <= 81, salir

		cmp r10, board + 100 + ((column_cells + 2) * 18) ; Comparar con 100
		jge .fuera_rango  ; Si rax >= 100, salir

		; Aquí entra si 81 < r10 < 100
		jmp .continuar    

		.fuera_rango:
			mov r9, [pallet_size]
			mov byte [r10], char_space	; Limpiar último carácter del palet
			sub r10, 112						; Mover una fila arriba (restar 320)
			mov [bot_position], r10			; Actualizar posición

		jmp .endp

		.continuar:
			jmp .endp

	.move_down:

		mov r10, [bot_position]

		cmp r10, board + 86 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 100 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 101 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 102 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 103 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 104 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 105 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 106 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 107 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 108 + ((column_cells + 2) * 10)  
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 83 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 84 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 85 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 86 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 15)
		je .endp
		
		cmp r10, board + ((column_cells + 2) * 20)
		jg .endp


		cmp r10, board + 9 + ((column_cells + 2) * 6)  
		jle .fuera_rango_down  ; Si rax <= 81, salir

		cmp r10, board + 100 + ((column_cells + 2) * 6) 
		jge .fuera_rango_down  ; Si rax >= 100, salir

		

		; Aquí entra si 81 < r10 < 100
		jmp .continuar    

		.fuera_rango_down:
			mov r9, [pallet_size]
			mov byte [r10], char_space	; Limpiar último carácter del palet
			add r10, 112							; Mover una fila abajo (sumar 320)
			mov [bot_position], r10			; Actualizar posición


		jmp .endp	

		.continuar_down:
			jmp .endp



		
		

	.move_left:

		mov r11, [colj]
		cmp r11, 1
		je .endp

		mov r10, [bot_position]

		; INICIO DE COMPARACIONES PARA LAS COLISIONES
		cmp r10, board + 1 + ((column_cells + 2) * 4)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 5)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 6)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 7)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 8)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 9)
		je .endp 
	
		cmp r10, board + 1 + ((column_cells + 2) * 10)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 11)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 12)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 12)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 13)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 14)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 15)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 16)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 17)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 18)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 19)
		je .endp

		cmp r10, board + 1 + ((column_cells + 2) * 20)
		je .endp

		cmp r10, board + 100 + ((column_cells + 2) * 7)
		je .endp

		cmp r10, board + 100 + ((column_cells + 2) * 8)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 9)
		je .endp

		;-----COLISION PARTE INTERNA DE LA CURVA-----
		cmp r10, board + 82 + ((column_cells + 2) * 10)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 11)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 12)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 13)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 14)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 15)
		je .endp
		;---FIN COLISION PARTE INTERNA DE LA CURVA----

		cmp r10, board + 100 + ((column_cells + 2) * 16)
		je .endp

		cmp r10, board + 100 + ((column_cells + 2) * 17)
		je .endp

		mov r9, [pallet_size]
		mov byte [r10], char_space	; Limpiar el último carácter del palet
		dec r10								; Mover la posición del palet una unidad a la izquierda
		mov [bot_position], r10			; Actualizar la posición del palet en la memoria

		jmp .endp	
							 
	.move_right:

		mov r11, [colj]
		cmp r11, 2
		je .endp

		mov r10, [bot_position]

		
		cmp r10, board + 108 + ((column_cells + 2) * 4)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 5)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 6)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 7)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 8)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 9)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 10)
		je .endp

		cmp r10, board + 85 + ((column_cells + 2) * 11)
		je .endp

		cmp r10, board + 85 + ((column_cells + 2) * 12)
		je .endp

		cmp r10, board + 85 + ((column_cells + 2) * 13)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 14)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 15)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 16)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 17)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 18)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 19)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 20)
		je .endp

		mov byte [r10], char_space
		inc r10
		mov [bot_position], r10
 
	.endp:
		mov qword [colj], 0

	pop rax
	pop rcx
	 
	ret

; Funcion: update_bot_direction
; Actualiza la direccion del bot segun la posicion actual
; Return:
;   void
update_bot_direction:
    mov rax, [bot_position]       ; Cargar la posición actual del bot

    ; Verificar si el bot está en el límite inferior del tablero
    cmp rax, board + ((column_cells + 2) * (row_cells - 1))  ; Límite inferior
    jge .change_direction_up      ; Si está en el límite inferior, cambiar dirección a "arriba"

    ; Verificar si el bot está en el límite superior del tablero
    cmp rax, board
    jle .change_direction_down    ; Si está en el límite superior, cambiar dirección a "abajo"

    ; Verificar si el bot está en el límite derecho del tablero
    cmp rax, board + column_cells - 1
    jge .change_direction_left    ; Si está en el límite derecho, cambiar dirección a "izquierda"

    ; Verificar si el bot está en el límite izquierdo del tablero
    cmp rax, board
    jle .change_direction_right   ; Si está en el límite izquierdo, cambiar dirección a "derecha"

    ret                           ; Si no hay cambios, salir de la función

	.change_direction_up:
		mov qword [bot_direction], up_direction
		ret

	.change_direction_down:
		mov qword [bot_direction], down_direction
		ret

	.change_direction_left:
		mov qword [bot_direction], left_direction
		ret

	.change_direction_right:
		mov qword [bot_direction], right_direction
		ret


; Funcion: change_bot_direction
; Genera una dirección aleatoria para el bot
; Return:
;   void
change_bot_direction:
    ; Incrementar el estado de la ruta
    mov al, [bot_path_state]
    inc al
    cmp al, 8        ; Si llegamos al final del recorrido (8 estados)
    jl .no_reset
    xor al, al       ; Reiniciar el estado a 0
	.no_reset:
		mov [bot_path_state], al
		
		; Seleccionar dirección según el estado de la ruta
		cmp al, 0
		je .set_right    ; Estado 0: Derecha
		
		cmp al, 1
		je .set_up       ; Estado 1: Arriba
		
		cmp al, 2
		je .set_left     ; Estado 2: Izquierda
		
		cmp al, 3
		je .set_down     ; Estado 3: Abajo
		
		cmp al, 4
		je .set_right    ; Estado 4: Derecha
		
		cmp al, 5
		je .set_up       ; Estado 5: Arriba
		
		cmp al, 6
		je .set_left     ; Estado 6: Izquierda
		
		cmp al, 7
		je .set_right    ; Estado 7: Derecha (hacia el punto inicial)
		
    ; Si ninguna de las anteriores coincide, establecer dirección a la derecha
    .set_right:
        mov qword [bot_direction], right_direction
        ret
        
    .set_down:
        mov qword [bot_direction], down_direction
        ret
        
    .set_left:
        mov qword [bot_direction], left_direction
        ret
        
    .set_up:
        mov qword [bot_direction], up_direction
        ret

; Funcion: print_player2
; Imprime al Jugador 2 en su posición actual
print_player2:
	mov r11, [player2_position] 
	.write_pallet:
		mov byte [r11], char_player2	 
	ret

; Funcion: move_player2
; Mueve al Jugador 2 en la dirección especificada
; Argumentos:
;   rdi: dirección (up_direction, down_direction, left_direction, right_direction)
move_player2:
    push rax
    push rcx

	mov r12, [colj]
	cmp r12, 1
	je .endp
	  
	cmp rdi, up_direction					; Comparar el valor de rdi (dirección) con left_direction
	je .move_up						; Si no es igual a left_direction, saltar a .move_right

	cmp rdi, down_direction
	je .move_down

	cmp rdi, right_direction
	je .move_right

	cmp rdi, left_direction
	je .move_left

	.move_up:
		mov r10, [player2_position]

		; INICIO DE COMPARACIONES PARA LAS COLISIONES
		cmp r10, board + 109 + ((column_cells + 2) * 4)
		jl .endp

		cmp r10, board + 82 + ((column_cells + 2) * 9)
		je .endp 
		cmp r10, board + 83 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 84 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 85 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 86 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 9)
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 9)
		je .endp

		cmp r10, board + 86 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 100 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 101 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 102 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 103 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 104 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 105 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 106 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 107 + ((column_cells + 2) * 14)
		je .endp
		cmp r10, board + 108 + ((column_cells + 2) * 14)
		je .endp

		cmp r10, board + 9 + ((column_cells + 2) * 18)  ; Comparar con 81
		jle .fuera_rango  ; Si rax <= 81, salir

		cmp r10, board + 100 + ((column_cells + 2) * 18) ; Comparar con 100
		jge .fuera_rango  ; Si rax >= 100, salir

		; Aquí entra si 81 < r10 < 100
		jmp .continuar    

		.fuera_rango:
			mov r9, [pallet_size]
			mov byte [r10], char_space	; Limpiar último carácter del palet
			sub r10, 112						; Mover una fila arriba (restar 320)
			mov [player2_position], r10			; Actualizar posición

		jmp .endp

		.continuar:
			jmp .endp

	.move_down:

		mov r10, [player2_position]

		cmp r10, board + 86 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 100 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 101 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 102 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 103 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 104 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 105 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 106 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 107 + ((column_cells + 2) * 10)  
		je .endp
		cmp r10, board + 108 + ((column_cells + 2) * 10)  
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 83 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 84 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 85 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 86 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 87 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 88 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 89 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 90 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 91 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 92 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 93 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 94 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 95 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 96 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 97 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 98 + ((column_cells + 2) * 15)
		je .endp
		cmp r10, board + 99 + ((column_cells + 2) * 15)
		je .endp
		
		cmp r10, board + ((column_cells + 2) * 20)
		jg .endp


		cmp r10, board + 9 + ((column_cells + 2) * 6)  
		jle .fuera_rango_down  ; Si rax <= 81, salir

		cmp r10, board + 100 + ((column_cells + 2) * 6) 
		jge .fuera_rango_down  ; Si rax >= 100, salir

		

		; Aquí entra si 81 < r10 < 100
		jmp .continuar    

		.fuera_rango_down:
			mov r9, [pallet_size]
			mov byte [r10], char_space	; Limpiar último carácter del palet
			add r10, 112							; Mover una fila abajo (sumar 320)
			mov [player2_position], r10			; Actualizar posición


		jmp .endp	

		.continuar_down:
			jmp .endp



		
		

	.move_left:

		mov r13, [colj]
		cmp r13, 1
		je .endp

		mov r10, [player2_position]

		; INICIO DE COMPARACIONES PARA LAS COLISIONES
		cmp r10, board + 1 + ((column_cells + 2) * 4)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 5)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 6)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 7)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 8)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 9)
		je .endp 
	
		cmp r10, board + 1 + ((column_cells + 2) * 10)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 11)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 12)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 12)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 13)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 14)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 15)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 16)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 17)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 18)
		je .endp 

		cmp r10, board + 1 + ((column_cells + 2) * 19)
		je .endp

		cmp r10, board + 1 + ((column_cells + 2) * 20)
		je .endp

		cmp r10, board + 100 + ((column_cells + 2) * 7)
		je .endp

		cmp r10, board + 100 + ((column_cells + 2) * 8)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 9)
		je .endp

		;-----COLISION PARTE INTERNA DE LA CURVA-----
		cmp r10, board + 82 + ((column_cells + 2) * 10)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 11)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 12)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 13)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 14)
		je .endp

		cmp r10, board + 82 + ((column_cells + 2) * 15)
		je .endp
		;---FIN COLISION PARTE INTERNA DE LA CURVA----

		cmp r10, board + 100 + ((column_cells + 2) * 16)
		je .endp

		cmp r10, board + 100 + ((column_cells + 2) * 17)
		je .endp

		mov r9, [pallet_size]
		mov byte [r10], char_space	; Limpiar el último carácter del palet
		dec r10								; Mover la posición del palet una unidad a la izquierda
		mov [player2_position], r10			; Actualizar la posición del palet en la memoria

		jmp .endp	
							 
	.move_right:

		mov r13, [colj]
		cmp r13, 2
		je .endp

		mov r10, [player2_position]

		
		cmp r10, board + 108 + ((column_cells + 2) * 4)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 5)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 6)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 7)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 8)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 9)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 10)
		je .endp

		cmp r10, board + 85 + ((column_cells + 2) * 11)
		je .endp

		cmp r10, board + 85 + ((column_cells + 2) * 12)
		je .endp

		cmp r10, board + 85 + ((column_cells + 2) * 13)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 14)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 15)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 16)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 17)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 18)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 19)
		je .endp

		cmp r10, board + 108 + ((column_cells + 2) * 20)
		je .endp

		mov byte [r10], char_space
		inc r10
		mov [player2_position], r10
 


	.endp:
		mov qword [colj], 0

	pop rax
	pop rcx
	 
	ret

_start: 
    ; Obtener el tiempo inicial
    mov rax, sys_time
    xor rdi, rdi  ; Argumento nulo para sys_time
    syscall
    mov [start_time], rax  ; Guardar el tiempo inicial
    mov qword [bot_direction], down_direction  ; Direccion inicial del bot a la derecha
	mov byte [bot_first_move], 0  ; Inicializar a 0 (el bot no ha realizado su primer movimiento)
	mov qword [bot_counter], 0   ; Inicializar el contador del bot a 0
	mov byte [bot_path_state], 0  ; Inicializar el estado de la ruta

	print clear, clear_length
	call start_screen
	level_up:
	call canonical_off
	call echo_off
	call set_bot_speed

 
	.main_loop:

    ; Verificar el tiempo transcurrido 
    mov rax, sys_time
    xor rdi, rdi
    syscall
    mov [current_time], rax  ; Guardar el tiempo actual

    ; Calcular el tiempo restante
    mov rax, [start_time]
    add rax, 60  ; Tiempo límite (60 segundos)
    sub rax, [current_time]
    cmp rax, 0
    jle .time_up  ; Si el tiempo restante es <= 0, salir del juego

    ; Convertir el tiempo restante a texto
    mov rbx, rax
    mov rcx, 10
    xor rdx, rdx
    div rcx
    add dl, '0'  ; Convertir a carácter ASCII
    mov [time_buffer+1], dl
    add al, '0'  ; Convertir a carácter ASCII  
    mov [time_buffer], al

    ; Mostrar el tiempo restante en pantalla
    print clear, clear_length
    print time_msg, time_msg_length
    print time_buffer, time_buffer_length

	; Verificar si el bot ya realizó su primer movimiento
    mov al, [bot_first_move]
    cmp al, 0
    jne .use_pattern_direction  ; Si ya se movió, usar el patrón de direcciones
    
    ; Primer movimiento: usar dirección a la derecha
    mov rdi, right_direction
    call move_bot
    mov byte [bot_first_move], 1  ; Marcar que el bot ya se movió
    jmp .after_bot_move
    
    .use_pattern_direction:
        ; Guardar la posición actual del bot
		mov r15, [bot_position]
		
		; Intentar mover el bot
		mov rdi, [bot_direction]
		call move_bot
		
		; Verificar si el bot se movió (comparando posición antes y después)
		cmp r15, [bot_position]
		jne .after_bot_move
		
		; Si no se movió, hay una colisión, cambiar dirección
		call change_bot_direction
		mov rdi, [bot_direction]
		call move_bot

	.after_bot_move:
		; Continuar con el resto del bucle principal
		call print_pallet
		call print_bot1
		call print_player2
		print board, board_size

		; Leer entrada del usuario
		call .read_more

		; Pausar el programa por un tiempo
		sleeptime

		; Volver al inicio del bucle
		jmp .main_loop
	
	.read_more:
		getchar  ; Leer un carácter de la entrada de teclado

		cmp rax, 1
		jne .done

		mov al, [input_char]

		; Movimiento del Jugador 1
		cmp al, 'w'
		je .move_player1_up
		cmp al, 's'
		je .move_player1_down
		cmp al, 'a'
		je .move_player1_left
		cmp al, 'd'
		je .move_player1_right

		; Movimiento del Jugador 2 (Flechas)
		cmp al, 0x1B          ; Verificar si es la tecla Escape
		jne .go_out
		getchar               ; Leer el siguiente carácter
		mov al, [input_char]  ; Almacenar el carácter leído en al
		cmp al, '['           ; Verificar si es '['
		jne .go_out
		getchar               ; Leer el siguiente carácter
		mov al, [input_char]  ; Almacenar el carácter leído en al
		cmp al, 'A'           ; Flecha hacia arriba
		je .move_player2_up
		cmp al, 'B'           ; Flecha hacia abajo
		je .move_player2_down
		cmp al, 'C'           ; Flecha hacia la derecha
		je .move_player2_right
		cmp al, 'D'           ; Flecha hacia la izquierda
		je .move_player2_left

		jmp .go_out

    .move_player1_up:
        mov rdi, up_direction
        call move_pallet
        jmp .done

    .move_player1_down:
        mov rdi, down_direction
        call move_pallet
        jmp .done

    .move_player1_left:
        mov rdi, left_direction
        call move_pallet
        jmp .done

    .move_player1_right:
        mov rdi, right_direction
        call move_pallet
        jmp .done

    .move_player2_up:
        mov rdi, up_direction
        call move_player2
        jmp .done

    .move_player2_down:
        mov rdi, down_direction
        call move_player2
        jmp .done

    .move_player2_left:
        mov rdi, left_direction
        call move_player2
        jmp .done

    .move_player2_right:
        mov rdi, right_direction
        call move_player2
        jmp .done

    .go_out:
        cmp al, 'q'
        je exit

        jmp .read_more

    .done:
        sleeptime
        jmp .main_loop

	.time_up:
		; Mostrar mensaje de fin de juego
		print clear, clear_length
		print game_over_msg, game_over_msg_length
		jmp exit

		print clear, clear_length
		
		jmp exit


start_screen: 

	push rax
	push rcx
	push rdx
	push rdi
	push rsi
	
	print msg1, msg1_length	
	getchar
	print clear, clear_length

	pop rax
	pop rcx
	pop rdx
	pop rdi
	pop rsi
	ret



exit: 
	call canonical_on
	mov    rax, 60
    mov    rdi, 0
    syscall