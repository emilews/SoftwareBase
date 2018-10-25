;promedio.asm
;calcular el promedio del arreglo de enteros
;autor: Federico Cirett
;Fecha: 2018-10-15

%include 'funciones.asm'

segment .bss
	arreglo_enteros  resb 200         ;50 casillas de 4 bytes c/u
	sum rest 4
	num rest 4

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
	mov [num],ecx	;mover tamaño del arreglo a variable num
	mov edx, 0		;ponemos en 0 EDX
	mov esi,arreglo_enteros   ;la direccion de 'arreglo_enteros' a ESI

    ;CICLO DE EXTRACCION DE ARGUMENTOS
ciclo:
	pop eax				;sacamos direccion de argumento del stack
	call atoi			;lo convertimos a entero de 4 bytes
	mov [esi+edx*4],eax	;lo guardamos en el arreglo_enteros
	inc edx					;incrementamos el indice de arreglo_enteros
	dec ecx					;decrementamos numero de argumentos por procesar
	cmp ecx,0				;preguntamos si ya no tenemos argumentos
	jne ciclo 			;ciclar en caso de que si existan argumentos
	mov edi,[num]

		;CICLO SUMA
ciclo_cuadrado:
	dec edi		;decrementar cantidad n de elementos en el array
	mov ebx,[esi+edi*4]	;poner en memoria ebx el contenido del arreglo
	mov eax,ebx		;mover numero eax
	imul eax, 
    inc ecx
    call iprintLF
    add [sum], eax
	cmp edi,0			;preguntamos si ya no tenemos argumentos
	jne ciclo_cuadrado				;ciclar en caso de que siga habiendo elementos en el arreglo


ciclo_suma:
    mov eax, [sum]
    div ecx
    call iprintLF

ciclo_perimetro:
    dec ecx		;decrementar cantidad n de elementos en el array
	mov ebx,[esi+ecx*4]	;poner en memoria ebx el contenido del arreglo
	mov eax,ebx		;mover numero eax
	imul eax, 4
    inc edx
    call iprintLF
	cmp ecx,0			;preguntamos si ya no tenemos argumentos
	jne ciclo_perimetro				;ciclar en caso de que siga habiendo elementos en el arreglo




    ;SALIDA
salir:
	jmp quit
