;programa: argumentos.asm
;autor: Emilio Wong
;fecha: oct-1
%include  'constantes.asm'
%include  'funciones.asm'
section .text
  global _start  ;punto de entrada usando gcc

_start:     ;punto de entrada
  pop ecx   ;obtenemos numero de argumentos

  ciclo:
    pop eax       ;obtenemos argumentos
    call sprintLF ;imprimimos el argumento
    dec ecx       ;restamos 1 al numero de argumentos disponibles
    cmp ecx,0     ;checamos si es el ultimo argumentos
    jz ciclo     ;seguimos si no es el ultimo
    jmp quit      ;si fue el ultimo argumento salimos
