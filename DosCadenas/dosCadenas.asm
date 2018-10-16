;programa: argumentos.asm
;autor: Emilio Wong
;fecha: oct-1
Section .data
    msg DB "Hola mundo! :)", 0x0a,0x00
    lon EQU $-msg
    msg2 DB "Me llamo Emilio", 0x0a,0x00
    lon2 EQU $-msg2
Section .text
    GLOBAL _Start
_Start:
    mov ecx, msg ;dirección del mensaje
    mov edx, lon ;solicitud de mensaje
    mov ebx, 1   ;std_out
    mov eax, 4   ;sys_write
    int 0x80     ;llamada kernel

    mov ecx, msg2 ;dirección del mensaje
    mov edx, lon2 ;solicitud de mensaje
    mov ebx, 1    ;std_out
    mov eax, 4    ;sys_write
    int 0x80      ;llamada kernel

    mov ebx, 0   ;codigo salida ok
    mov eax, 1   ;sys_exit
    int 0x80     ;llamada kernel 