        org 0000h       ; Inicio del código en 0x0000

        ; Cargar los números en B y C (en hexadecimal)
        ld  D, 35h      ; Primer número en D (53 decimal)
        ld  E, 27h      ; Segundo número en E (39 decimal)

        ; Realizar la suma
        ld  A, D        ; Poner lo que hay en D en A
        add A, E        ; A = D + E

        ; Guardar el resultado de la suma en C
        ; C ahora tiene la suma en hexadecimal (0x5C, que es 92 decimal)

        ; Convertir el resultado a BCD
        call CONVERT_BCD
	ld A, B
        ; A contiene las centenas
        ; H contiene las decenas
        ; L contiene las unidades
         ; Fin del programa
        jp FIN          ; Saltar a la instrucción de fin

; Subrutina para convertir un número binario a BCD
CONVERT_BCD:
    ; C contiene el número a convertir
    ; Usaremos los registros B, H y L para almacenar las centenas, decenas y unidades

    ld  B, 0       ; Inicializar B para las centenas
    ld  H, 0       ; Inicializar H para las decenas
    ld  L, 0       ; Inicializar L para las unidades

CENTENAS:
    cp  100        ; Comparar A con 100 (centenas)
    jr  C, DECENAS ; Si A < 100, saltar a las decenas
    sub 100        ; Restar 100 de A
    inc B          ; Incrementar B (centenas)
    jr  CENTENAS   ; Repetir hasta que A < 100

DECENAS:
    cp  10         ; Comparar D con 10 (decenas)
    jr  C, UNIDADES; Si A < 10, saltar a las unidades
    sub 10         ; Restar 10 de A
    inc H          ; Incrementar H (decenas)
    jr  DECENAS    ; Repetir hasta que A < 10

UNIDADES:
    ld L, A        ; Colocar el valor restante de A en L (unidades)
    ret             ; Regresar al programa principal

FIN:
        ; Instrucción de fin
        nop            ; No hace nada, pero asegura estabilidad
        jp FIN         ; Ciclo infinito para finalizar el programa

        .end           ; Fin del código fuente