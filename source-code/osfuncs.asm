
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

displayft: ;takes address offset as argument

pusha

call newLine
mov si,filetablestr
call printn



mov bx,0x1000
mov es,bx
mov bx,1

mov dx,0
hdft:

inc dx
mov al,[es:bx]
cmp al,0
je retdft


cmp al,"-"
je psectorn


mov ah,0x0e
int 0x10
inc bx
jmp hdft
psectorn:
mov ax,19
sub ax,dx
mov cx,ax
l:
mov ah,0x0e
mov al," "
int 0x10
loop l



l2:
inc bx
mov al,[es:bx]
cmp al,","
je l3
cmp al,"}"
je l3
mov ah,0x0e
int 0x10
jmp l2
l3:


call newLine
inc bx
mov dx,0
;mov bx,es
;call printHex

jmp hdft

retdft:
popa
ret

;;;;;;;;;;;;;;;;;;;;;;;
;process delete character
;;;;;;;;;;;;;;;;;;;;;;;
deleteProcess:

;cmp byte [bx-1],0
;je hshell

dec bx

mov byte [bx],0

;call newLine
;mov si,cmd
;call printn
;call newLine

mov ah,0x0e
mov al,0x0D
int 0x10

mov si,shellstr
call printn

mov si,cmd
call printn

mov ah,0x0e
mov al," "
int 0x10

ret
graphics_mode:
pusha
;;;;;;;;;;;;;;;;;;;;;;;
;graphics mode
;;;;;;;;;;;;;;;;;;;;;;;

mov ah,0x00  ; int 0x10 /ah = 0x00 = set video mode

mov al,0x13 ; 320x200 , 256 color graphics mode

int 0x10

mov ah,0x0C ; int 0x10 / ah = 0x0C write graphics pixel

 ; column
mov dx,80; row 
mov cx,100 ; column
mov al,0x00
square:
; blue
mov bh,0x00 ; page
 

int 0x10

inc cx ; column
cmp cx,200
jne square

inc dx ;row
cmp dx,180

je retgraphicsmode
mov cx,80
inc al
;pusha
;mov ax,0x00
;int 0x16
;popa
jmp square

retgraphicsmode:

mov ax,0x00
int 0x16
popa
ret




















