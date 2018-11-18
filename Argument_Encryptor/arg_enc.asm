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
  dict      resb 59         ;For the dict 
  desc      resb 4          ;memory for storing desc
  buffer    resb 59       ;Buffer for reading
  b_len     equ  $-buffer   ;length of buffer
  file      resb 1024       ;File x

  ;Arguments in order--------------------------------
  filename      resb $-buffer   ;filename where we save data
  key           resb 32         ;Key to encrypt/decrypt
  key_len       equ  $-key
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
  mov ebx, eax        ;We move the text to ebx
  pop eax             ;Name of file to save data onto
  mov edi, eax        ;Move name of new file to edi
  mov esi, filename   ;Data address
  ;--------------------------------------------------

  ;GENERAL: 
  ;1.- It will read only one line in the cifrado txt file
  ;     and it will look for a number, that number is the 
  ;     position in that line of the encrypted/decrypted
  ;     character. 
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

  ;Reading character by character--------------------
  mov eax, ebx        ;Move text argument to eax
  mov edx, [key]      ;Move key to edx
  push edi            ;Saving edi
  mov edi, [dict]     ;Move dict to edi
  call encrypt        ;We encrypt char by char and move to esi 
  pop edi             ;Name of the file to edi
  ;--------------------------------------------------



  ;Writing encrypted text to file--------------------
  mov eax, sys_creat  ;Create a file
  mov ebx, edi        ;Name of the file
  mov ecx, 664O       ;O character?
  int 80h             ;Execute

  mov eax, sys_open   ;Open file
  mov ebx, edi        ;Name of the file to open
  mov ecx, O_RDWR     ;Read/Write mode
  int 80h             ;Execute
  
  mov ebx, eax        ;From eax, we use the opened file
  mov eax, sys_write  ;Write mode
  mov ecx, esi        ;What will be written in the file
  mov edx, 35        ;The bytes that will be written
  int 80h             ;Execute
  mov eax, sys_sync   ;Sync
  int 80h             ;Execute

  mov eax,6           ;close file
  int 80h             ;close your file

  ;---------------------------------------------------


  ;Printing in terminal-------------------------------
  mov eax, esi        ;Moving whole encrypted text to eax
  call sprintLF       ;Printing
  ;---------------------------------------------------
  mov eax, sys_exit   ;Exit code
  int 80h             ;Execute/quit



i_a_handler:
  mov eax, i_a_msg    ;Move the error code to eax
  call ins_args       ;Printing and exiting