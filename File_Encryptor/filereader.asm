; Name: Encryptor for Assembly 
; Authors: Aileen Palafox, Luis Valdez & Emilio Wong
; Date: 14 Nov 2018
; How to:
; ./encryptor "texto a cifrar" "archivo_para_guardar.txt"

%include 'constantes.asm'
%include 'funciones.asm'


section .data

section .bss
  desc      resb 4          ;memory for storing desc
  buffer    resb 8          ;Buffer for reading
  len       equ  $-buffer   ;length of buffer
  file      resb 1024       ;File x

  ;Arguments in order--------------------------------
  ;fileToRead   resb 10         ;File to encrypt
  filename      resb $-buffer   ;filename where we save data
  key           resb 32         ;Key to encrypt/decrypt
  ;--------------------------------------------------

section .start
  global _start


_start:
  ;Initializer---------------------------------------
  pop eax             ;Number of arguments  
  pop eax             ;Name of program
  pop eax             ;Name of file to read
  mov ebx, eax        ;We move the name to ebx
  pop eax             ;Name of file to save data onto
  mov edi, eax        ;Move name of new file to edi
  mov esi, filename   ;Data address
  pop eax             ;Key
  ;mov r9d, eax        ;We store the key here
  ;--------------------------------------------------
  ;TO DO GENERAL: 
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



  ;Key calculator------------------------------------
  ;TO DO: everything to get the values of the chars

  ;--------------------------------------------------

  ;Reading file to encrypt---------------------------
  mov eax,5           ;open file command
  mov ecx,0           ;read only
  int 80h             ;open filename for read only

  mov [desc],eax      ;storing the desc

  mov eax,3           ;read from file
  mov ebx,[desc]      ;your file desc
  mov ecx,buffer      ;read to buffer
  mov edx,len         ;read len bytes
  int 80h             ;read len bytes to buffer from file
  ;--------------------------------------------------

  ;Reading character by character--------------------
  mov eax, ecx        ;Buffer to eax
  call encrypt     ;eax -> esi
  ;--------------------------------------------------



  ;Copying text from file----------------------------
  mov eax, sys_creat
  mov ebx, edi
  mov ecx, 664O
  int 80h

  mov eax, sys_open
  mov ebx, edi
  mov ecx, O_RDWR
  int 80h
  
  mov ebx, eax
  mov eax, sys_write
  mov ecx, esi
  mov edx, len
  int 80h
  mov eax, sys_sync
  int 80h

  mov eax,6           ;close file
  ;mov ebx,[desc]      ;your file desc
  int 80h             ;close your file

  ;---------------------------------------------------

  mov eax, sys_exit
  int 80h