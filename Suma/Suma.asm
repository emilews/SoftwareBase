%include 'funciones.asm'

section .data
    a DB 5,0x0a
    b DB 3,0x0a

segment .bss
    sum resb 1

section .text
GLOBAL _Start

_Start:
    mov eax, [a]
    sub eax, '0'
    
    mov ebx, [b]
    sub ebx, '0'

    add eax, ebx
    add eax, '0'
    
    mov [sum], eax
    mov eax, sum

    call sprintLF
    jmp salida