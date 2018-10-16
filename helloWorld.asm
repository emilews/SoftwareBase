Section .data
    msg DB "Hola mundo! :)", 0x0a,0x00
    lon EQU $-msg
Section .text
    GLOBAL _Start
_Start:
    mov ecx, msg ;dirección del mensaje
    mov edx, lon ;solicitud de mensaje
    mov ebx, 1   ;std_out
    mov eax, 4   ;sys_write
    int 0x80     ;llamada kernel

    mov ebx, 0   ;codigo salida ok
    mov eax, 1   ;sys_exit
    int 0x80     ;llamada kernel 