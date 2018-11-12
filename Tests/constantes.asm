;constantes.asm
;constantes que se utilizan el las funciones de ensamblador
;para la familia x86
sys_exit        equ     1       ;salida
sys_read        equ     3       ;lectura
sys_write       equ     4       ;escritura
sys_open        equ     5       ;apertura de archivo
sys_close       equ     6       ;cierre de archivo
sys_creat       equ     8       ;crear archivo
sys_sync        equ    36       ;sincronizar con disco (forzar escritura)
stdin           equ     0       ;entrada estandar (teclado)
stdout          equ     1       ;salida estandar (pantalla)
stderr          equ     3       ;salida de error estandar
O_RDONLY        equ     0       ;open for read only
O_RDWR          equ     1       ;open for read and write
