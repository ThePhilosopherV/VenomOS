;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; This is not an editor 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


call clearScreen
mov ax,vidmem
mov es,ax

mov bx,0x0f00
mov si,mystr
mov ah,0x0e  

call writeto_vidmem
;mov si,word [mystr]

;mov [bx],si

;mov si,mystr

mov ax,0x8000
mov es,ax


h:
call getchar
cmp al,0x11
je quit

cmp al,0x13
je save

mov byte [buffer+di],al
inc di

cmp al,0x0d
je printnewline

call pchar

jmp h

printnewline:
mov byte [buffer+di],0x0A
inc di
call newLine
call pchar
jmp h


quit:
mov si,buffer
call printn
call pause

call jtokernel




save:
mov ax,vidmem
mov es,ax
    
mov bx,0x0e60

mov si,save_str
mov ah,0x0e    

call writeto_vidmem

mov ax,0x8000
mov es,ax
; move cursor
mov ah,0x02    ;AH = 0x02
mov bh,0    ;BH = display page (usually, if not always 0)
mov dh,23    ;DH = row
mov dl,len    ;DL = column
int 0x10    ;int 0x10


mov di,0
kkk:
call getchar

cmp al,0x0D
je addfileto_filetable


mov byte [filename+di],al 
inc di
call pchar

jmp kkk


addfileto_filetable:


mov ax,0x1000
mov es,ax
mov ax,0

anotherlabelhere:

cmp byte [es:bx],0xed

je anotherfuckinglabel
inc bx
jmp anotherlabelhere

anotherfuckinglabel:
;;; now we're in the bottom of the file table,i know you liked the word bottom you sickkunt

mov dl,byte [es:bx-2] ; last sector
mov dh,byte [es:bx-1] ;last file size

push dx


mov si,filename

thisisnotalablemate:

lodsb

cmp al,0
je overthere

mov byte [es:bx],al
inc bx
jmp thisisnotalablemate

overthere:

mov byte [es:bx],0
add bx,1

mov word [es:bx],"da"
add bx,2

mov byte [es:bx],"t"
inc bx

mov word [es:bx],0x0000
add bx,2


pop dx

;push dx
;mov bx,dx
;call printHex
;call pause

add dh,dl



mov byte [es:bx],dh
inc bx

mov byte [es:bx],0x01
inc bx

mov byte [es:bx],0xed

writefilecontentodisk:


call jtokernel





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; include files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

%include  "osfuncs.asm"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;; data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

vidmem:  equ    0x0B800
filename:  db  50  dup 0
mystr:  db   "^Press Ctrl+s to save the file     |    ^Press Ctrl+q to quit",0
save_str:  db   "Save file as (input file name then press enter): ",0
len: equ $-save_str-1

buffer:   db    ""


times 1024-($-$$) db 0


