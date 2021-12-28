
;;;;;;;;;;;;;;;;;;;;;;;
;bios print null terminated string ;string parameter passed to si
;;;;;;;;;;;;;;;;;;;;;;;
printn: 
pusha

mov ah,0x0e ;function code to display a character  

printLoop:

lodsb
cmp al,0
je retprintLoop


int 0x10 ;bios video service

jmp printLoop
retprintLoop:
popa
ret
;;;;;;;;;;;;;;;;;;;;;;;
;print hex representation of an integer,integer should be in bx
;;;;;;;;;;;;;;;;;;;;;;;

printHex:
pusha
mov cl,0

mov dx,bx
printHexhead:

mov bx,dx

shl bx,cl
shr bx,12

cmp bx,9
jg alphab

add bx,48

mov ah,0x0e
mov al,bl
int 0x10

cmp cl,12
je retprintHex


add cl,4
jmp printHexhead
alphab:

add bx,87

mov ah,0x0e
mov al,bl
int 0x10

cmp cl,12
je retprintHex

add cl,4
jmp printHexhead

retprintHex:
popa
ret


;;;;;;;;;;;;;;;;;;;;;;;
;bios print new line
;;;;;;;;;;;;;;;;;;;;;;;
newLine:
pusha
mov ah,0x0e
mov al,0x0A
int 0x10

mov ah,0x0e
mov al,0x0D
int 0x10
popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
;compare two strings ,string addresses are in bx,si
;;;;;;;;;;;;;;;;;;;;;;;
cmpstr:

lodsb


;call newLine
;mov ah,0x0e
;mov al,byte []
;int 0x10



cmp al,byte [bx]
jne noteq

checkNullByte:
cmp al,0

je retcmpstr
inc bx
jmp cmpstr
noteq:
mov al,1

ret
retcmpstr:
mov al,0

ret

;;;;;;;;;;;;;;;;;;;;;;;
;clear screen using text mode
;;;;;;;;;;;;;;;;;;;;;;;


clearScreen:
pusha

mov ah,0x00  ;code for video mode function
mov al,0x3 ; 80x25 , 16 color text mode :video mode  ,will clear the screen as well
int 0x10 ; bios video service

;;change bodrer color, change background color

mov ah,0x0B
mov bh,0x0 ;change background color
mov bl,0x0 ;black
int 0x10


popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
;zeros cmd variable
;;;;;;;;;;;;;;;;;;;;;;;

fillcmdzeros:
pusha
;;fill cmd variable with zeros

mov cx,50
l1:
;cmp byte [cmd],0
;je ret_fillcmdzeros

mov byte [bx],0
inc bx

loop l1


ret_fillcmdzeros:
popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
;display file table
;;;;;;;;;;;;;;;;;;;;;;;

displayft: ;

pusha

mov bx,0x1000
mov es,bx
mov bx,0

fb:

call newLine


mov dx,1
f:
mov al,[es:bx]

cmp al,0xed
je ret_dft

mov ah,0x0e
int 0x10

inc bx

cmp al,0
jne f
cmp dx,0
je prnt_hexvalues
mov al,"|"
int 0x10
mov dx,0
jmp f

prnt_hexvalues:
push ax
mov ah,0x0e
mov al,"|"
int 0x10
pop ax

push bx
xor bx,bx
mov bl,al
call printHex
pop bx

inc bx
inc dx
mov al,[es:bx]
cmp dx,3

je fb
jmp prnt_hexvalues

ret_dft:
popa
ret




















