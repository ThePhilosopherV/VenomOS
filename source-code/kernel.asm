

;;;;;;;;;;;;;;;;;;;;;;;
;Clears the screen and changes the background color
;;;;;;;;;;;;;;;;;;;;;;;

system_start:



call clearScreen ; clear screen

call newLine


mov si,str1 ;print welcome message 

call printn
call newLine

;;;;;;;;;;;;;;;;;;;;;;;
;Shell
;;;;;;;;;;;;;;;;;;;;;;;

shell_start:



call newLine

mov si,shellstr ; prints shell string
call printn

mov bx,cmd
call fillcmdzeros ; lets make sure cmd variable is empty


mov si,bx 
call printn
input_shell:

mov ax,0   ;0x16/0  function to take user input keytroke is stored in al 
int 0x16

cmp al,0x08 ;process delete character
je proc_del



cmp al,0x0D
je proc_command




mov byte [bx],al


mov ah,0x0e ;print character
int 0x10

inc bx

jmp input_shell
;;check command and execute
proc_command:

cmp byte [cmd] , 0 ;lets make sure we have a command
je shell_start

;call newLine


mov si,cmd

mov bx,clr


;call printn

;call newLine

call cmpstr
;xor bx,bx
;mov bl,al
;call printHex

;mov si,clr
;call printn

cmp al,0
je system_start

mov si,cmd
mov bx,dft

call cmpstr

cmp al,0
je proc_dft

mov si,cmd
mov bx,reboot

call cmpstr

cmp al,0
je system_reboot

mov si,cmd
mov bx,magic

call cmpstr

cmp al,0
je graphics

mov si,cmd
mov bx,help

call cmpstr

cmp al,0
je print_help


jmp shell_start


proc_del:

cmp byte [cmd] , 0 ;did  we delete all command characters ?
je input_shell

dec bx
mov byte [bx],0

mov ah,0x0e ;print a backspace which will move the cursor one char to the left
mov al,0x08
int 0x10

mov ah,0x0e ;print a space
mov al," "
int 0x10

mov ah,0x0e ;print a backspace which will move the cursor one char to the left
mov al,0x08
int 0x10

jmp input_shell

proc_dft:
call newLine
call displayft
jmp shell_start


graphics:
call graphics_mode
jmp system_start

print_help:
call newLine
call newLine
mov si,help_commands
call printn
jmp shell_start

system_reboot:

jmp 0xFFFF:0



;mov bx,0xbeef
;call printHex
;call newLine
;mov bx,0xaaee
;call printHex

haltloop:hlt

jmp haltloop

;;include files

%include "osfuncs.asm"

;;data

;;;;;;;;;;;;;;;;;;;;;;;
;commands
;;;;;;;;;;;;;;;;;;;;;;;
reboot:  db  "reboot",0   ;reboot os
dft:    db  "dft",0       ;display file table
clr:     db   "clr",0       ;clear screen
magic:   db  "magic",0  ; graphics mode
help:   db   "help",0

help_commands:  db  "dft    : display file table",0x0A,0x0D
                db  "clr    : clear screen ",0x0A,0x0D
                db  "magic  : travel to graphics land",0x0A,0x0D
                db  "reboot : reboot system",0x0A,0x0D
                db  "help   : print this help message",0x0A,0x0D,0
  



shellstr:   db  "=>vShell_$ ",0

str1 :  db " "
        db 20 dup "*",0xA,0xD

str2:  db   0x0D," Welcome To VenomOS",0xA,0xD," "
str3 : db 20 dup "*",0xA,0xA,0xD,0

filetablestr:  db  "file name         sector",0x0A,0x0D,"---------         ------",0x0A,0x0D,0
                           
cmd:   db ""                          
;;;;;;;;;;;;;;;


times 1024-($-$$) db 0
