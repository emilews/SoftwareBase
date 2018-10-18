;promedio.asm
;calcular el promedio del arreglo de enteros
;autor: Federico Cirett
;Fecha: 2018-10-15
%include 'funciones.asm'

segment .bss
	arreglo_enteros  resb 200         ;50 casillas de 4 bytes c/u
	sum resb 4				  		  ;Resultado de la suma

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
ciclo_suma:
 	dec edx					;Restamos 1 a edx, por que estamos un número adelantado al del array
	mov ebx, [esi+edx*4]	;Buscamos el valor en memoria y pasamos a ebx
	add ecx,ebx				;Sumamos los registros de ecx (en 0) con el de ebx (con el valor en memoria)
	mov [sum], ecx			;Movemos la suma al registro dinámico en [sum]
	cmp edx, 0				;Comparamos para ver si nuestro contador llega a 0
	jne ciclo_suma


ciclo_impresion:



imprimir:
	mov eax, [sum]
	call iprintLF

    ;SALIDA
salir:
	jmp quit

