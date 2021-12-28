





call newLine
mov si,progstr
call printn



















;;;;;;include files;;;;;;
%include "osfuncs.asm"

;;;;;;;data;;;;;
progstr: db  "Program loaded successfully",0

times 512-($$-$)  db 0
