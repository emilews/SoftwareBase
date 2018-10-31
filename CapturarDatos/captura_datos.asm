%include 'funciones.asm'
%include 'constantes.asm'

section .data 
    nombre db "¿Cómo te llamas?", 0x0
    edad db "¿Cuál es tu edad?", 0x0

section .bss
    Buffer_nombre resb 20
    len_buffer_nombre equ $-Buffer_nombre
    Buffer_edad resb 4
    len_buffer_edad equ $-Buffer_edad
section .text
    global _start:

_start:
    mov eax, nombre     ;mensaje de pregunta
    call sprint       ; lo imprimimos
;nos preparamos para preguntar por system
    mov ecx, Buffer_nombre      ;aquí guardamos el nombre
    mov edx, len_buffer_nombre  ;long max del nombre
    call LeerTexto              ;cedemos control al system

    mov eax, edad           ;guardamos la edad
    call sprint             ;imprimimos pregunta

    mov ecx, Buffer_edad
    mov edx, len_buffer_edad
    call LeerTexto

    mov eax, Buffer_nombre
    call sprintLF


    mov eax, Buffer_edad
    call atoi
    call iprintLF

    jmp salida

LeerTexto:
    mov ebx, stdin
    mov eax, sys_read
    int 0x80
    ret
