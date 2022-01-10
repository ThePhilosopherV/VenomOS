;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;si   has the command address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm:
pusha

;call getchar

mov bx,0

asm_hloop:
lodsb

cmp al,[asm_command+bx]
jne jll

inc bx
jmp asm_hloop

jll:
cmp bx,3

je ccb
jmp asm_ret

checkspaces:

lodsb

ccb:
inc bx
cmp al,space

je checkspaces

cmp al,0
je noarg_error
;;;;;;;;;;; lets check if file exists in filetable
sub cx,bx

mov bx,cx
inc cx
;call printHex
;call pause
dec si

;call printn

;call pause

call load_f
;mov cx,10

;fgho:
mov bx,0x8000
mov es,bx
mov bx,0



mov dx,1    ;line counter
;;;;;;;;;;;; lets process  our dear source file
skip_spacesonfirstline:

cmp byte [es:bx],space

jne checkinst
inc bx

jmp skip_spacesonfirstline

checkinst:

mov si,mov_in

mov cx,0
;;;;;;;;;;;;;;is it  mov in ? mov instruction processing
movinstl:

lodsb

cmp al,byte [es:bx]

jne checkvald

inc bx
inc cx
jmp movinstl

checkvald:

cmp cx,3
je pmov

jmp asm_ret

;;;;;;;;;;;; here we're sure it is
pmov:

;lets  skip spaces

mov cx,0
skip_spacess:

cmp byte [es:bx],space

jne check_inst
inc bx
inc cx
jmp skip_spacess



check_inst:
cmp cx,0

je error



;;;;;;;;;;;;;;check register
mov si,registers
mov di,0
mov cx,16

.loly:
mov ax,word [registers + di]
cmp  word [es:bx],ax
je p_al
add di,2
loop .loly

jmp badargerror





p_al:




add bx,2



skip_spaces_al:

cmp byte [es:bx],space

jne check_in_al
inc bx

jmp skip_spaces_al              

check_in_al:
cmp byte [es:bx],","
jne error




inc bx
skip_spaces_al_aftecomma:

cmp byte [es:bx],space

jne check_in_al_arg
inc bx

jmp skip_spaces_al_aftecomma

check_in_al_arg:

cmp word [es:bx],"0x"
je arg_hex_proc
;;;;;;;here process arg as hex

arg_hex_proc:


add bx,2

push bx
mov si,0
hell:
xor cx,cx

xor ax,ax

checkifvalidhex:

cmp byte [es:bx],48
jl afterhell

cmp byte [es:bx],102
jg afterhell


cmp byte [es:bx],57
cmovbe ax,[one]

cmp byte [es:bx],97
cmovge cx,[one]

add ax,cx

cmp ax,0

je afterhell

inc bx
inc si

cmp si,4
jg afterhell

jmp hell

afterhell:
;;;;;;;;;;;lets check that after the arg there is nothing
cmp si,0
je badargerror
looks:

cmp byte [es:bx],space

jne alife
inc bx

jmp looks

alife:

;check if 
cmp byte [es:bx],0x0D
je good_inst


cmp byte [es:bx],0
je good_inst


jmp badargerror

;mov ah,1
good_inst:
;;;;;;;;;;;;;;;; lets decide if the arg is 2 or 4 bytes

xor dx,dx
mov ax,di
mov cx,2
div cx
mov bx,ax
call printHex
call pause


pop bx

mov al,byte [es:bx]
cmp al,57
jle pnum

mov ah,0

sub al,87
mov ch,al
call pchar
call pause

pnum:
cmp ah,1
je numisfirst
sub al,48

numisfirst:
sub al,48
;mov 


badargerror:
pop bx
mov si,arg_er
call newLine


call printn
mov al,dl
add al,48
call pchar

jmp asm_ret



error:
mov si,er_msg
call newLine


call printn
mov al,dl
add al,48
call pchar

jmp asm_ret

noarg_error:
mov si,noargs_error_str
call newLine
call printn



asm_ret:

popa
ret


one:   dw  0x01
two:    dw  0x02
asm_command:    db   "asm"
space:  equ      " "
;filename:   db  50 dup   0
noargs_error_str:   db    "Missing file name argument",0
mov_in:   db    "mov"
er_msg:    db    "Error in line ",0

arg_er:    db   "Bad arg error in line ",0

registers:  db "al" ;b0
            db "cl"
            db "dl"
            db "bl"
            db "ah" 
            db "ch"
            db "dh"
            db "bh"
            db "ax"
            db "cx"
            db "dx"
            db "bx"
            db "sp"
            db "bp"
            db "si"
            db "di";bf
            
offsets:   db  0




















