;promedio.asm
;invertir cadena
;autor: Emilio Wong
;Fecha: 24 octubre

%include 'funciones.asm'

segment .bss
	cadena_destino  resb 30         ;50 casillas de 4 bytes c/u


section .text
	global _start:

_start:
   pop ecx
   mov edx, ecx
   mov esi, cadena_destino
   pop eax
   mov edx, 0

ciclo:
    pop eax
    mov bl, byte[eax]
    push ebx
    inc eax
    inc edx
    cmp eax, 0
    jne ciclo


 SecondCicle:
    cmp edx,0
    je salir
    pop eax
    call sprint
    jmp SecondCicle

dec ecx
cmp ecx, 1
jne ciclo


salir:
	jmp quit
