strlen:
    push  ebx           ;Salvamos el valor de ebx en el tack
    mov ebx, eax        ;Copiamo dirección del menaje a ebx

sigchar:
    cmp byte [eax], 0   ;Comparamos el byte qye espa en la dirección
                        ;con la que apunta eax con 0 (buscando el caracter de terminación 0)
    jz finalizar        ;Jump if zero, salta si es cero
    inc eax             ;Incrementamos el acumulador en 1
    jmp sigchar         ;Salto directo al siguiente caracter

finalizar:
    sub eax, ebx        ;Se resetea el valor en memoria
    pop ebx             ;Reestablecer ebx;
    ret                 ;Return a donde se llamó la función