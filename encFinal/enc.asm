; Name: Encryptor for Assembly 
; Authors: Aileen Palafox, Luis Valdez & Emilio Wong
; Date: 14 Nov 2018
; How to:
; ./enc "Text to encrypt" "file_to_save.txt"

%include 'constantes.asm'
%include 'funciones.asm'


section .data
  ;Message for key input
  key_msg   DB   'Please input a key:',0x0
  ;Message if not enough arguments
  i_a_msg   DB   'Not enough arguments. Use as follows: ./enc "text to encrypt" "file to save"', 0x0
  ;Message if too many arguments
  tm_a_msg  DB   'Too many arguments. Use as follows: ./enc "text to encrypt" "file to save"', 0x0
  ;File name of the dictionary
  cifrado   DB   'cifrado.txt',0x0


section .bss
  k_val         resb 1          ;Key number value
  x_val         resb 1          ;Char to enc/dec number val
  dict          resb 3538       ;For the dict 
  desc          resb 4          ;memory for storing desc
  buffer        resb 3539       ;Buffer for reading cifrado.xt
  b_len         equ  $-buffer   ;length of buffer
  filename      resb $-buffer   ;filename where we save data
  key           resb 32         ;Key to encrypt/decrypt
  key_len       equ  $-key      ;Key length
  text          resb 8192       ;Where we save the text
  t_len         equ  $-text     ;Text length

section .start
  global _start

_start:
  ;Counting arguments--------------------------------
  ;This is to know if there are enough arguments or too many
  pop eax             ;Number of arguments
  cmp eax, 3          ;We compare the arguments with 3
  jl i_a_handler      ;Call to terminate if not enough args 
  jg tm_a_handler     ;Call to terminate if too much arguments
  ;--------------------------------------------------
  ;Asking for key------------------------------------
  ;We ask for the key to encrypt the argument
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
  mov ebx, cifrado    ;What we want to open
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

  ;Initialiser---------------------------------------
  ;Poping arguments and saving them
  pop eax             ;Name of program
  pop eax             ;Argument or text to encrypt
  mov [text], eax     ;We move the text to text
  pop eax             ;Name of file to save data onto
  mov edi, eax        ;Move name of new file to edi
  mov esi, filename   ;Data address
  ;--------------------------------------------------
  
  ;------------------------------------------------------
  ;THE FOLLOWING WAS NOT USED, IT WAS THE FIRST METHOD 
  ;THAT WE TESTED, IT REALLY DIDN'T WORK FOR MANY 
  ;REASONS, THE MAIN BEING THAT WE NEEDED TOO MANY
  ;REGISTERS TO HOLD DATA.
  ;
  ;
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
  ;-------------------------------------------------------

  ;Encrypting character by character--------------------------
  ;We set up the registers and start the encryption
  mov eax, [text]     ;Move text argument to eax
  mov edx, [dict]     ;Move dict to edx
  push edi            ;Save edi
  push ebp            ;Save ebp
  call encrypt        ;We encrypt char by char and move to esi 
  ;-----------------------------------------------------------

  ;Handlers for error in arguments-----------------------------------
  ;This only helps in displaying errors and exiting
i_a_handler:
  mov eax, i_a_msg     ;Move the error code to eax
  call args_handler    ;Printing and exiting

tm_a_handler:
   mov eax, tm_a_msg   ;Move the error code to eax
   call args_handler   ;Printing and exiting
;--------------------------------------------------------------------

;--------------------------------------------------------------------
;Works with eax (the text reg) and edx (the key reg)
;It first looks for a coincidence between the start of 
;line of the dict chars and the first char of the key 
;and saves the index of the line where it found the 
;coincidence,then looks for a coincidence with a char 
;of dict on the first line and saves the index 
;(which is an integer and not a register pointer),
;it then proceeds to add the two indexes to get the
;encrypted or shifted char and copies it to esi.
;When we get to the end of the key, we restart the
;index to 0.
;When we get to the end of the text, we break out of 
;the loop and start creating the file and writing
;in it. 
;
encrypt:
  mov ecx, 0                ;Initialise ecx
  mov ebx, 0                ;Initialise ebx
  mov edi, 0                ;Initialise edi
  mov ebp, 0                ;Initialise ebp
.sigcar:
  cmp byte[key+ecx], 0x0a   ;We compare to know if we got to the end of the key
  je .restart               ;If yes, then we restart the index
  mov bl, byte[edx+edi]     ;Move a byte from dict to compare with the key char
  cmp byte[key+ecx], bl     ;Compare to know the index of key char in the lines of dict
  je .preFirstFound         ;Handler to prepare for next loop
  jne .incre                ;Handler to add 60 to edi and ret to loop
.incre:
  lea edi, [edi+60]         ;We calculate the next register value (which is to say that we 
                            ;get to the next line of dict)
  jmp .sigcar               ;Returns to loop
.preFirstFound:
  mov [k_val], edi          ;If found a coincidence, then we save the value in k_val
  mov edi, 0                ;Restart edi to 0
  mov bl, 0                 ;Clean bl just in case
  jmp .firstFound           ;Now we continue with the loop
.restart:
  mov ecx, 0                ;If we get to the end of the key, we restart ecx to 0
  jmp .sigcar               ;And get back to the loop
.firstFound:
  mov bl, byte[edx+edi]     ;Move a byte from dict to compare with the text char
  cmp byte[eax], bl         ;Compare to know the index in the first line (un-shifted one) of the text char
  je .secondFound           ;If coincidence, we get to the next block 
  jne .increb               ;If not, then we increment the index
.increb:                    
  inc edi                   ;Increment edi (index)
  jmp .firstFound           ;Return to loop
.secondFound:
  add edi, [k_val]          ;Adding the line index and char index to know the encrypted char
  mov bl, byte[edx+edi]     ;We get the encrypted char
  mov byte[esi+ebp], bl     ;Saving char in memory
  cmp byte[eax+1], 0x0      ;We check if it is the end of the text
  jz .finalizar             ;If yes, jump to the end
  inc eax                   ;Add 1 to eax (index of eax)
  inc ecx                   ;Add 1 to ecx (index of key)
  inc ebp                   ;Add 1 to ebp (index of esi, of encrypted reg pointer)
  mov ebx, 0                ;Restart to 0
  mov edi, 0                ;Restart to 0
  mov bl, 0                 ;Cleaning bl
  jmp .sigcar               ;Back to loop
.finalizar:
  mov eax, esi              ;Move the amount of bytes the text has to x_val
  call strlen               ;Calling strlen to know the length of the encrypted string
  mov [x_val], eax          ;Move length of encrypted string to x_val
  pop eax                   ;Some argument that was pushed but I don't know where
  pop ebp                   ;Restore ebp
  pop edi                   ;Restore edi (name of file to create and write to)
  mov eax, sys_creat        ;Create a file
  mov ebx, edi              ;Name of the file
  mov ecx, 664O             ;O character?
  int 80h                   ;Execute
  mov eax, sys_open         ;Open file
  mov ebx, edi              ;Name of the file to open
  mov ecx, O_RDWR           ;Read/Write mode
  int 80h                   ;Execute
  mov ebx, eax              ;From eax, we use the opened file
  mov eax, sys_write        ;Write mode
  mov ecx, esi              ;What will be written in the file
  mov edx, [x_val]          ;The bytes that will be written
  int 80h                   ;Execute
  mov eax, sys_sync         ;Sync
  int 80h                   ;Execute
  mov eax,6                 ;close file
  int 80h                   ;close your file
;Printing in terminal----------------------------------------
  mov eax, esi              ;Moving encrypted text to eax
  call sprintLF             ;Printing
;------------------------------------------------------------
  mov eax, sys_exit         ;Exit code
  int 80h                   ;Execute/quit
;------------------------------------------------------------

;Handler for errors------------------------------------------
;Prints and quits
args_handler:
  call sprintLF             ;Printing error code
  call quit                 ;Quitting
;------------------------------------------------------------