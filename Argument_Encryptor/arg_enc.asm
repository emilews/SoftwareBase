; Name: Encryptor for Assembly 
; Authors: Aileen Palafox, Luis Valdez & Emilio Wong
; Date: 14 Nov 2018
; How to:
; ./encryptor "texto a cifrar" "archivo_para_guardar.txt"

%include 'constantes.asm'
%include 'funciones.asm'


section .data
  ;Message for key input
  key_msg   DB   'Please input a key:',0x0
  ;Message if not enough arguments
  i_a_msg   DB   'Not enough arguments. Use as follows: ./arg_enc "text to encrypt" "file to save"', 0x0
  ;File name of the dictionary
  cifrado   DB   'cifrado.txt',0x0
  ;Test key
  t_key   DB   'hola',0x0

section .bss
  k_val     resb 1          ;Key number value
  x_val     resb 1          ;Char to enc/dec number val
  dict      resb 3538       ;For the dict 
  desc      resb 4          ;memory for storing desc
  buffer    resb 3538       ;Buffer for reading
  b_len     equ  $-buffer   ;length of buffer
  file      resb 1024       ;File x

  ;Arguments in order--------------------------------
  filename      resb $-buffer   ;filename where we save data
  key           resb 32         ;Key to encrypt/decrypt
  key_len       equ  $-key
  t_denc        resb 8192       ;where we save the text
  td_len        equ  $-t_denc
  ;--------------------------------------------------

section .start
  global _start


_start:
  ;Asking for key------------------------------------
  mov eax, key_msg    ;Move msg to eax
  call sprint         ;Print msg
  mov ecx, key        ;Where we'll save input
  mov edx, key_len    ;len buffer
  mov ebx, stdin      ;Starndar input
  mov eax, sys_read   ;We read the input
  int 80h             ;Execute
  ;--------------------------------------------------


  ;Reading cifrado file------------------------------
  mov eax,5           ;open file command
  mov ebx, cifrado
  mov ecx,0           ;read only
  int 80h             ;open filename for read only

  mov [desc],eax      ;storing the desc

  mov eax,3           ;read from file
  mov ebx,[desc]      ;your file desc
  mov ecx,buffer      ;read to buffer
  mov edx,b_len       ;read len bytes
  int 80h             ;read len bytes to buffer from file
  mov esi, buffer     ;Copy buffer (the alphabet) to esi
  mov [dict], esi     ;Copy esi to dict
  mov esi, 0          ;Initialise esi
  ;--------------------------------------------------


  ;Initializer---------------------------------------
  pop eax             ;Number of arguments
  cmp eax, 2          ;We compare the arguments with 2
  jl i_a_handler      ;Call to terminate if not enough args 
  pop eax             ;Name of program
  pop eax             ;Argument or text to encrypt
  mov [t_denc], eax   ;We move the text to t_denc
  pop eax             ;Name of file to save data onto
  mov edi, eax        ;Move name of new file to edi
  mov esi, filename   ;Data address
  ;--------------------------------------------------

  ;GENERAL: 
  ;   It will read the whole cifrado.txt file, first
  ;     looping through the lines to get the key char
  ;     line and then looping through the first line
  ;     to get the position of the char of the text
  ;     to encrypt/decrypt
  ; THIS IS NO LONGER USED----------------------------
  ;   It is doing the following calculations to get that
  ;   number:
  ;     e(x) = (x + k)%59  -> Encryption
  ;     e(x) = (x - k)%59  -> Decryption
  ;   e(x) is the resulting character 
  ;   x is the number value of the character to enc/dec
  ;   k is the number value of the character of the key
  ;   mod(59) is the modulo of the total of characters
  ;   in the cifrado line, which is 59
  ;
  ;   The number values are based on the position of that
  ;   same character on the line at the cifrado txt
  ;---------------------------------------------------
  ;Reading character by character--------------------
  mov eax, [t_denc]         ;Move text argument to eax
  mov edx, [dict]           ;Move dict to edx
  push esp                  ;Save esp
  mov esp, edi              ;Move name of file to esp
  call encrypt              ;We encrypt char by char and move to esi 
  ;--------------------------------------------------

i_a_handler:
  mov eax, i_a_msg    ;Move the error code to eax
  call ins_args       ;Printing and exiting

;--------------------------------------------------------------------
;--------------------------------------------------------------------
;Works with eax (which is the index where we search) and edx (the key index)
encrypt:
  mov ecx, 0              ;Initialise ecx
  mov ebx, 0              ;Initialise ebx
  mov edi, 0              ;Initialise edi
  mov ebp, 0              ;Initialise ebp
.sigcar:
  cmp byte[key+ecx], 0x0a ;Check if it is the end of the key string
  je .restart             ;Jump to restart index
  mov bl, byte[edx+edi]   ;Move a byte from dict (K)
  cmp byte[key+ecx], bl   ;Compare to know the value number of key char
  je .preFirstFound       ;Handler to prepare for next loop
  jne .incre              ;Handler to add 59 to edi and ret to loop
.incre:
  lea edi, [edi+60]       ;Calculate edi adding 60 to read next char
  jmp .sigcar             ;Returns to loop
.preFirstFound:
  mov [k_val], edi        ;Saving index in memory
  push ebp                ;Saving ebp
  mov ebp, 0              ;Initialise ebp
  jmp .firstFound         ;next block
.restart:                 
  mov ecx, 0              ;Restart ecx to 0
  jmp .sigcar             ;Loop to next char
.firstFound:
  mov bl, byte[edx+ebp]   ;Move a byte from edi (X)
  cmp byte[eax], bl       ;compare if it is the char we want
  je .secondFound         ;next block
  jne .increb             ;if not, add 1 to index
.increb:  
  inc ebp                 ;add 1 rto ebp
  jmp .firstFound         ;loop again
.secondFound:
  add edi, ebp              ;add edi and ebp to get encrypted char
  mov ebp, 0                ;initialise ebp
  pop ebp                   ;restoring ebp
  mov bl, byte[edx+edi]     ;We get the encrypted char
  mov byte[esi+ebp], bl     ;Saving position in memory
  cmp byte[eax+ebp], 0x0    ;We check if it is the end
  jz .finalizar             ;Jump to the end
  inc eax                   ;add 1 to eax
  inc ecx                   ;add 1 to ecx
  inc ebp                   ;add 1 to ebp
  mov ebx, 0                ;Restore ebx
  mov edi, 0                ;restore edi
  mov bl, 0                 ;restore bl
  jmp .sigcar               ;Loop
.finalizar:
  mov eax, 0          ;restore eax
  mov ebx, 0          ;restore ebx
  mov ecx, 0          ;restore ecx
  mov edx, 0          ;restore edx
  mov eax, sys_creat  ;Create a file
  mov ebx, esp        ;Name of the file
  mov ecx, 664O       ;O character?
  int 80h             ;Execute
  mov eax, 0          ;initialise eax
  mov eax, sys_open   ;Open file
  mov ebx, esp        ;Name of the file to open
  mov ecx, O_RDWR     ;Read/Write mode
  int 80h             ;Execute
  pop ebp             ;restore ebp
  pop esp             ;restore esp
  mov ebx, eax        ;From eax, we use the opened file
  mov eax, 0          ;initialise eax
  mov eax, sys_write  ;Write mode
  mov ecx, esi        ;What will be written in the file
  mov edx, td_len     ;The bytes that will be written
  int 80h             ;Execute
  mov eax, sys_sync   ;Sync
  int 80h             ;Execute
  mov eax,6           ;close file
  int 80h             ;close your file
  ;Printing in terminal-------------------------------
  mov eax, 0          ;restore eax
  mov ebx, 0          ;restore ebx
  mov ecx, 0          ;restore ecx
  mov edx, 0          ;restore edx
  mov edi, 0          ;restore edi
  mov eax, key        ;Moving whole encrypted text to eax
  call sprintLF       ;Printing
  ;---------------------------------------------------
  mov eax, sys_exit   ;Exit code
  int 80h             ;Execute/quit

ins_args:
  call sprintLF          ;Printing error code
  call quit              ;Quitting
