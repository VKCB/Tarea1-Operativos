bits 64
default rel


; Here comes the defines
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
	char_comillas: equ 176
	char_comilla: equ 39 
	char_space: equ 32 
	left_direction: equ -1
	right_direction: equ 1
	up_direction: equ 2
	down_direction: equ 3



STDIN_FILENO: equ 0			;Se utiliza en llamadas al sistema que requieren un descriptor de archivo, por ejemplo, al leer de la entrada estándar

F_SETFL:	equ 0x0004		;Se pasa como segundo argumento a la llamada al sistema fcntl para indicar que queremos cambiar los flags del descriptor de archivo.
O_NONBLOCK: equ 0x0004		;Se utiliza como tercer argumento en la llamada al sistema fcntl para indicar que el descriptor de archivo debe operar en modo no bloqueante.

;screen clean definition
	row_cells:	equ 24	;Numero de filas que caben en la pantalla
	column_cells: 	equ 110 ; set to any (reasonable) value you wish
	array_length:	equ row_cells * column_cells + row_cells ;(+ 32 caracteres de nueva línea)

;This is regarding the sleep time
timespec:
    tv_sec  dq 0
    tv_nsec dq 20000000		;0.02 s

timespec2:
    tv_sec2  dq 0
    tv_nsec2 dq 2000000000000		;0.02 s

;This is for cleaning up the screen
clear:		db 27, "[2J", 27, "[H"	;2J: Esta es una secuencia de escape ANSI que indica Clear screen
clear_length:	equ $-clear			;H: Indica reposicionamiento del cursor.

; Esta es la pantalla de inicio
	
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

	input_char: resq 1 

	temp_char resb 1
	random resb 1 ;Numero random obtenido
	random2 resb 1

section .data 

	urandom db '/dev/urandom', 0
	newline db 10, 0

	score dq 0
	score_position dq board + 19 + 10* (column_cells + 2)

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

	;board: Es la dirección de inicio del tablero
	;40: Es el desplazamiento horizontal inicial desde el borde izquierdo del tablero.
	;29 * (column_cells + 2): Es el desplazamiento vertical. 20 indica la fila en la que se coloca la paleta, y column_cells + 2 es el número de caracteres por fila, incluyendo los caracteres de nueva línea 
	pallet_position dq board + 20 + (12 * 111)
	pallet_size dq 3

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
; This function is in charge of moving the pallet in a given direction
; Arguments:
;	rdi: left direction or right direction
;
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
		cmp r8, 320							; Verificar si está en la primera fila
		jl .endp							; Si sí, no moverse más arriba

		mov r9, [pallet_size]
		mov byte [r8], char_space	; Limpiar último carácter del palet
		sub r8, 112						; Mover una fila arriba (restar 320)
		mov [pallet_position], r8			; Actualizar posición

		jmp .endp

	.move_down:

		mov r8, [pallet_position]
		cmp r8, 320						; Verificar si está en la última fila (200 * 320)
		jl .endp							; Si sí, no moverse más abajo

		mov r9, [pallet_size]
		mov byte [r8], char_space	; Limpiar último carácter del palet
		add r8, 112							; Mover una fila abajo (sumar 320)
		mov [pallet_position], r8			; Actualizar posición


		jmp .endp	

	.move_left:

		mov r13, [colj]
		cmp r13, 1
		je .endp

		mov r8, [pallet_position]
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
		mov byte [r8], char_space
		inc r8
		mov [pallet_position], r8
 
	.endp:
		mov qword [colj], 0

	pop rax
	pop rcx
	 
	ret

_start: 
	print clear, clear_length
	call start_screen
	level_up:
	call canonical_off

 
	.main_loop:

		;call rand_num
		call print_pallet 
		print board, board_size	 

	
		
		;setnonblocking	
	.read_more:	
		getchar						;Llama a la macro getchar para leer un carácter de la entrada de teclado 
		
		cmp rax, 1
    	jne .done
		
		mov al,[input_char]

		.up_in:
			cmp al, 'w'
			jne .down_in
			mov rdi, up_direction
			call move_pallet
			jmp .done

		.down_in:
			cmp al, 's'
			jne .left_in
			mov rdi, down_direction
			call move_pallet
			jmp .done

		.left_in:
			cmp al, 'a'
			jne .right_in
			mov rdi, left_direction
			call move_pallet
			jmp .done
		
		.right_in:
		 	cmp al, 'd'
	    	jne .go_out
			mov rdi, right_direction
			call move_pallet
    		jmp .done	

		.go_out:

    		cmp al, 'q'
    		je exit

			jmp .read_more
		
		.done:	
			;unsetnonblocking		
			sleeptime	
			print clear, clear_length
    		jmp .main_loop 

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


