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


cmp  word [es:bx],"al"
je p_al


jmp asm_ret



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


mov al,byte [es:bx]
;add al,48
call pchar

call pause


















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



asm_command:    db   "asm"
space:  equ      " "
;filename:   db  50 dup   0
noargs_error_str:   db    "Missing file name argument",0
mov_in:   db    "mov"
er_msg:    db    "Error in line ",0
