;promedio.asm
;calcular el promedio del arreglo de enteros
;autor: Federico Cirett
;Fecha: 2018-10-15
%include 'funciones.asm'

segment .bss
	arreglo_enteros  resb 200         ;50 casillas de 4 bytes c/u
	elementos resb 4				  ;numero de elementos

section .text
	global _start:

_start:
    ;BLOQUE INICIAL: Revisamos si hay suficientes argumentos
	pop ecx			;obtenemos el numero de argumentos
	cmp ecx,1		;comparamos si es menor a 2
	jl salir 		;salimos si es menor a 2

    ;BLOQUE de INICIALIZACION
	pop eax			;obtenemos nombre de programa
	dec ecx			;restamos 1 al numero de argumentos
	mov elementos, ecx
	mov edx, 0		;ponemos en 0 EDX
	mov esi,arreglo_enteros   ;la direccion de 'arreglo_enteros' a ESI

    ;CICLO DE EXTRACCION DE ARGUMENTOS
ciclo:
	pop eax					;sacamos direccion de argumento del stack
	call atoi				;lo convertimos a entero de 4 bytes
	mov [esi+edx*4],eax		;lo guardamos en el arreglo_enteros
	inc edx					;incrementamos el indice de arreglo_enteros
	dec ecx					;decrementamos numero de argumentos por procesar
	cmp ecx,0				;preguntamos si ya no tenemos argumentos
	jne ciclo 				;ciclar en caso de que si existan argumentos

    ;CICLO DE IMPRESION
ciclo_impresion:
	mov ebx, [esi+edx*4]
	dec edx
	add eax,ebx
	cmp ecx, edx
	je imprimir
	jne ciclo_impresion


ciclo_suma:

    ;SALIDA
salir:
	jmp quit

imprimir:
	call iprintLF
	call salir