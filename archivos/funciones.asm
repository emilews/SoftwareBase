;Recibe direccion de cadena a medir longitud en EAX
;Regresa en EAX el conteo de caracteres de la cadena
strlen:
    push EBX		;salvamos el valor de EBX en la pila (stack)
    mov EBX,EAX		;copiamos la direccion del mensaje a EBX

sigcar:
    cmp byte[EAX],0	;comparamos el byte que esta en la direccion
			;a la que apunta EAX comn 0 (estamos buscando el caracter de terminacion 0)
    jz finalizar 	;JUMP if Zero, salta a finalizar si es cero
    inc EAX		;incrementamos en 1 el acumulador
    jmp sigcar		;salto incondicional al siguiente caracter

finalizar:
    sub EAX,EBX		;restamos al valor inicial de memoria el valor final de memoria
    pop EBX		;establecer EBX
    ret			;regresar al punto en que llamaron a la funcion

sprint:
    push EDX		;salvamos valor de EDX
    push ECX		;salvamos valor de ECX
    push EBX		;salvamos valor de ECX
    push EAX		;salvamos valor de EAX
    call strlen 	;llamamos a la funcion strlen

    mov EDX,EAX 	;movemos la longitud de cadena a EDX
    pop EAX		;traemos del stack el valor de EAX
    mov ECX,EAX 	;la direccion del mensaje a ECx
    mov EBX,1		;descriptor de archivo(stdout)
    mov EAX,4		;sys_write
    int 80h		;ejecuta

    pop EBX		;re-establecemos EBX
    pop ECX		;re-establecemos ECX
    pop EDX		;re-establecemos EDX
    ret

;imprime cadenas de texto con una nueva linea (LF o Line Feed)
sprintLF:

    call sprint		;llama e imprime el mensaje
    push EAX		;salvamos EAX,vamos a utilizarlo en esta funcion
    mov EAX,0xA		;Hexadecimal para caracter de lineFeed
    push EAX		;salvamos el 0xA en el stack
    mov EAX,ESP		;Lo que apunta ESP a EAX
    call sprint		;Imprimimos el LF
    pop EAX		;Recuperamos el caracter 0xA
    pop EAX		;Recuperamos el valor original de 0xA
    ret			;Regresamos

quit:
salida:
  mov ebx, 0          ;codigo de salida
  mov eax, 1          ;SYT_EXIT
  int 0x80

;------------------------------------------------
; int atoi  ( entero)
;convierte ascii a entero
;recibe apuntador a ASCII en eax
;regresa valor en eax
;------------------------------------------------
atoi:
    push ebx  ; preservamos ebx
    push ecx  ; preservamos edx
    push edx  ; preservamos edx
    push esi  ; preservamos esi
    mov  esi,eax ; nuestro numero a convertir va a esi
    mov eax,0   ;inicializamos a cero eax
    mov ecx,0  ; inicializamos a cero ecx

    ciclomult:    ; ciclo multiplicacion

    xor ebx,ebx   ; resetteamos a 0 ebx, tanto  bh como bl
    mov bl,[esi+ecx]     ; movemos un solo byte a ala parte baja de ebx
    cmp bl, 48          ; comparamos con ascii ´0´
    jl  finalizado ; si es menor , saltamos a finalizado.
    cmp bl,57     ; comparamos con ascci "9"
    jg  finalizado ; si es mayor, saltamos a finalizado
    cmp bl, 10   ; comparamos con linefeed
    je  finalizado ; si es igual, saltamos a finalizado
    cmp bl, 0    ; comparamos con caracter null ](fin de caneda)
    jz finalizado ; si es cero saltamos a finalizado
    sub bl,48     ;convertimos el caracter en entero
    add eax,ebx ; agreagamos el valor a eax
    mov ebx,10 ; movemos el decimal 10 a ebx
    mul ebx  ; multiplicamos eax por ebc para obtener el lugar decimal
    inc ecx    ; incrementamos ecx (conttador)
    jmp ciclomult ; seguimos nuestro ciclo de multiplicacion

    finalizado:

    mov ebx,10 ; movemos el valor decimal 10 a ebx
    div ebx ; dividimos eax entre 10
    pop esi ; re-establecemos esi
    pop edx    ; re-establecemos edx
    pop ecx  ; re-establecemos ecx
    pop ebx ; re-establecemos ebx
    ret
; funcion iprint (integer print ) o impresion de enteros
iprint:
	push eax ; salvamos eax en el stack (acumulador)
	push ecx ; salvamos ecx en el stack (contador)
    push edx ; salvamos edx en el stack 	(base)
	push esi ; salvamos esi en el stack ( source index)
	mov ecx,0 ; vamos a contar cuantos bytes necesitamos imprimir

dividirLoop:

	inc ecx      ; incrementamos en 1 ecx
	mov edx,0    ; limpiamos edx
	mov esi,10   ; guardamos 10 en esi , vamos a divir entre 10
	idiv esi     ;divide eax entre esi
	add edx , 48   ; agregamos el caracter 48 '0'
	push edx          ;la representacion de ascii de nuestro numero
	cmp eax,0    ; se puede dividir mas el numero entero ?
	jnz dividirLoop   ; jum if not zero (salta si no es cero)

imprimirloop:

	dec ecx     ; vamos a contar hacia abajo cada byte en el stack
	mov eax,esp ; apuntador del stack a eax
	call sprint ;llamamos ala funcion sprint
	pop eax      ; removemos el ultimo caracter del stack
	cmp ecx ,0   ; ya imprimos todos los bytes del stack ?
	jnz imprimirloop   ; todabia hay numeros que imprimir ?

	pop esi ; re - estabnlecemos el valor de esi
	pop edx    ; re-establecemos el valor de edx
	pop ecx ; re-establecemos el valor de ecx
	pop eax   ; re-establecemos el valor de eax
	ret ; regresamos

; funcion iprintlf (integer print ) o impresion de enteros con line feed
iprintLF:
    call iprint ;imprimimo el numeros
    push eax   ;salvamos el dato que traemos en el acumulador

    mov eax,0xA ; copiamos el line feed a eax
    push eax ; salvamos el line feed en el stack
    mov eax, esp ; copiamos el apuntador del stack a eax  estamos apuntando a una direccion de memoria
    call sprint   ; imiprimos el line feed
	pop EAX		;remomovemos el linefeed del stack
    pop EAX		;re-establecemos el dato que traiamos en eax
    ret			;Regresamos


;funcion leer_archivo
;recibe en ebx: la dirección con el nombre del file
;recibe en esi: la dirección del buffer de lectura

leer_archivo:
    mov eax, sys_open
    mov ecx, O_RDONLY
    int 80h
    cmp eax, 0
    jle .error

    ;lee el archivo
    mov ebx, eax
    mov eax, sys_read
    mov ecx, esi
    int 80h
    call sprintLF


    ;cerrar leer_archivo
    mov eax, sys_close
    int 80h

.error:
    mov ebx, eax
    mov eax, sys_exit
    int 80h