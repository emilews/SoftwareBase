;archivos.asm

%include 'constantes.asm'
%include 'funciones.asm'

section .data

segment .bss
    buffer  resb 1024
    len     equ  1024
    file    resb   30
    filelen resb    4

section .text
    global _start

_start:
    ;vemos los argumentos del sistema operativo
    pop ecx         ;numero de argumentos
    pop eax         ;nombre del programa
    dec ecx         ;restamos 1 al contador de argumentos

    ;abrimos archivoy leemos
    pop ebx             ;nombre de archivo
    mov esi, buffer     ;direccion del buffer a esi
    mov edx, len        ;longitud del buffer
    call leer_archivo   ;leer el file

    ;imprime buffer
    mov eax, buffer
    call sprintLF


    jmp quit