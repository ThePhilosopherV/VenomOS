
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

mov ah,0x0e
mov al,"0"
int 0x10

mov ah,0x0e
mov al,"x"
int 0x10

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;load program from file table;to memory address 0x8000
;filename is in si
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

load_file:

pusha
add cx,2

mov di,0x1000
mov es,di
mov di,0

;cx has command length
aids:
mov dx,0

push si

lfh:

mov al,byte [si]
mov bl,byte [es:di]

cmp bl,0xed
je ret_lf

inc di
inc si
inc dx
cmp al,bl
je lfh


;xor bx,bx
;mov bl,byte [es:di+4]
;call printHex

;jmp $
cmp cx,dx
je load_tomem

lk:

cmp byte [es:di],0
je hj
inc di
jmp lk
hj:

add di,8


pop si
jmp aids

load_tomem:


;jmp $
mov cl,byte [es:di+4] ; starting sector to read from loadFromDisk
mov al,byte [es:di+5] ;num of sectors to read

mov bx,0x8000
mov es,bx
mov bx,0

mov dh,0 ;head 0
mov dl,0 ;0x00 for first floppy dsik , 0x80 for first hard drive
mov ch,0 ;cylinder 0


mov ah,0x02 ;bios code funtion to read from disk/int 0x13

int 0x13 ; bios interrupt for disk services

jc load_tomem

mov ax,0x8000
mov ds,ax ;data segment
mov fs,ax ; extra segment
mov gs,ax
mov es,ax
mov ss,ax ;stack segment

jmp 0x8000:0

ret_lf:
pop si
popa
ret



















