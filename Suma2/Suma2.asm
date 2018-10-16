%include 'funciones.asm'

section .data
    a DB 5,0x0
    b DB 3,0x0

section .text
    GLOBAL _Start

_Start:
    pop ecx
    pop eax
    dec ecx
    pop eax
    call sprintLF
    dec ecx
    call atoi
    call iprintLF
    mov ebx, eax
    pop eax
    dec ecx
    call atoi
    add eax, ebx
    call iprintLF
    jmp salida