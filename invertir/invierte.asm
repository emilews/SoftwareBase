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

ciclo:
    pop eax
    mov ecx,eax
    push byte[ecx]
    call sprintLF
    dec edx
    cmp edx, 1
    jne ciclo


salir:
	jmp quit
