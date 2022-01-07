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
;;;;;;;;;;;; lets process  of dear source file





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
