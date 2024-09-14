; Definición de constantes
MAX_ATTEMPTS EQU 3

; Definición de variables
attempts     DB 0         ; Contador de intentos
input_buffer DB 0, 0, 0, 0 ; Buffer para almacenar la clave ingresada

; Definición de la clave correcta
CORRECT_KEY  DB '1', '2', '3', '4' ; Clave correcta como bytes

.org 0010h
START:
    ; Mostrar mensaje para solicitar la clave
    LD HL, MSG_REQUEST
    CALL PRINT_STRING

    ; Inicializar el contador de intentos
    LD A, 0
    LD (attempts), A

INPUT_LOOP:
    ; Inicializar el buffer de entrada
    LD HL, input_buffer
    LD B, 4

READ_DIGIT:
    ; Esperar la entrada del usuario
    CALL GET_CHAR

    ; Verificar si el carácter es un número
    CP '0'
    JR C, ERROR_NON_DIGIT
    CP '9' + 1
    JR NC, ERROR_NON_DIGIT

    ; Almacenar el dígito en el buffer
    LD (HL), A
    INC HL

    ; Ocultar el dígito con un asterisco
    LD A, '*'
    CALL PRINT_CHAR

    ; Decrementar el contador de dígitos
    DJNZ READ_DIGIT

    ; Verificar la clave ingresada
    LD HL, input_buffer
    LD DE, CORRECT_KEY
    LD B, 4

VERIFY_LOOP:
    LD A, (DE)
    LD C, A          ; Cargar el byte de la dirección apuntada por DE en C (clave correcta)
    LD A, (HL)       ; Cargar el byte desde el buffer de entrada en A (clave ingresada)
    CP C            ; Comparar A con C
    JR NZ, INCORRECT_KEY ; Si no son iguales, saltar a INCORRECT_KEY
    INC HL          ; Avanzar al siguiente byte en input_buffer
    INC DE          ; Avanzar al siguiente byte en CORRECT_KEY
    DJNZ VERIFY_LOOP ; Repetir hasta que se comparen todos los bytes

    ; Clave correcta
    LD HL, MSG_CORRECT
    CALL PRINT_STRING
    JR END

INCORRECT_KEY:
    ; Incrementar el contador de intentos
    LD A, (attempts)
    INC A
    LD (attempts), A

    ; Verificar si se han excedido los intentos
    CP MAX_ATTEMPTS
    JR Z, ACCESS_BLOCKED

    ; Clave incorrecta
    LD HL, MSG_INCORRECT
    CALL PRINT_STRING
    JR INPUT_LOOP

ACCESS_BLOCKED:
    ; Acceso bloqueado
    LD HL, MSG_BLOCKED
    CALL PRINT_STRING
    JR END

ERROR_NON_DIGIT:
    ; Mostrar mensaje de error y volver a solicitar la clave
    LD HL, MSG_ERROR
    CALL PRINT_STRING
    JR INPUT_LOOP

END:
    ; Fin del programa
    HALT

PRINT_STRING:
    ; Imprimir una cadena de texto terminada en 0
    LD A, (HL)
    OR A
    RET Z
    CALL PRINT_CHAR
    INC HL
    JR PRINT_STRING

PRINT_CHAR:
    OUT (00), A     ; Enviar el carácter en A al puerto de salida conectado a la pantalla
    RET

GET_CHAR:
    IN A, (01)      ; Leer un carácter del puerto de entrada conectado al teclado
    RET

; Mensajes de texto
MSG_REQUEST:  DB "Ingrese clave: ", 0
MSG_CORRECT:  DB "Clave correcta!", 0
MSG_INCORRECT: DB "Clave incorrect", 0
MSG_BLOCKED:  DB "Acceso bloquead", 0
MSG_ERROR:    DB "Solo numeros!!", 0

