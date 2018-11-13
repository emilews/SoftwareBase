%include 'constantes.asm'
%include 'funciones.asm'


section .data
    p_nombre DB "nombre alumno", 0x0
    p_archivo DB "nombre archivo", 0x0

segment .bss
    buffer_alumno resb 30
    len_alumno equ $-buffer_alumno
    filename resb 30
    len_filename equ $-filename

section .text
    global _start

_start:
    pop ecx                     ;num de argumentos
    pop eax                     ;nombre programa
    dec ecx                     ;decrementamos ecx
    cmp ecx, 0                  ;
    jz quit
    pop eax                     ;nombre archivo
    mov esi, filename           ;direccion memoria

    call copystring             ; cipiamos eax -> esi

    mov eax, p_nombre           ;preguntar nombre
    call sprint                 ;imprime mensaje
    mov ecx, buffer_alumno      ;captura buffer
    mov edx, len_alumno         ;lon buffer
    call LeerTexto              ;captura

;crear file
    mov eax, sys_creat
    mov ebx, filename
    mov ecx, 664O
    int 80h
    cmp eax, 0
    jle error

    mov eax, sys_open
    mov ebx, filename
    mov ecx, O_RDWR
    int 80h
    cmp eax, 0

    jle error


    ;escritura en file

    mov ebx, eax
    mov eax, sys_write
    mov ecx, buffer_alumno
    mov edx, len_alumno
    int 80h
    mov eax, sys_sync
    int 80h

    ;cerrar file
    mov eax, sys_close
    int 80h

error:
    mov ebx, eax
    mov eax, sys_exit
    int 80h
