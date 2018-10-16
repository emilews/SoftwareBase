section .data
  msg DB "Las funciones", 0x0A, 0x00

  msg2 DB "como sprint y strlen", 0x0A, 0x00

  msg3 DB "hacen la vida mas facil", 0x0A, 0x00

section .txt

GLOBAL _start
_start:
                    ;imprimir Hola mundo
    mov eax, msg
    call sprint

    mov eax, msg2
    call sprint

    mov eax, msg3
    call sprint

    mov ebx, 0
    mov eax, 1
    int 0x80

  ;funcion strlen
  strlen:
    push  ebx     ;salvamos el valor de EBX en la pila/stack
    mov   ebx, eax  ;copiamos la direccion del mensaje a EBX

  sigcar:
    cmp byte [eax], 0   ;comparamos el byte qye esta en al direcciòn a la que paunte EAX con 0
                        ;(estamos buscando el caracter de terminacion 0)

    jz finalizar       ;jump if zero
    inc eax             ;incrementamos en 1 el acumulador
    jmp sigcar          ;salto incodicional al siguiente caracter

  finalizar:
    sub eax, ebx      ;restamos al valor incial de memoria
    pop ebx             ;reestablecer EBX
    ret                 ;regresar al punto en que llamaron la funcion

  ;sprint: recibe direccion de mensaje a imprimir en EAX
  sprint:
    push edx ;salavmos EDX
    push ecx
    push ebx
    push eax ;salvamos direccion de mensaje
    call strlen ;calcula longitud
    mov edx, eax ;longitud a EDX
    pop eax     ;recuperamos direccion del mensaje
    mov ecx, eax ;mensaje
    mov ebx, 1
    mov eax, 4
    int 0x80    ;ejecutar
    pop ebx     ;recupera valor de EBX
    pop ecx
    pop edx
    ret         ;regresamos al punto de llamada


