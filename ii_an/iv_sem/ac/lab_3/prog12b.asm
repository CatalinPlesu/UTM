INCLUDE Irvine32.inc

;b - random
; z = 2(x - y) + 81 | if x > 2y
; z = 2y + x/4 | if  x <= y

.data
    mes1 byte "Valoarea X:",0
    mes2 byte "Valoarea Y:",0
    mes3 byte "Rezutatul este:",0
    f1 byte "z = 2(x - y) + 81 | if x > 2y",0
    f2 byte "z = 2y + x/4 | if  x <= 2y",0
    vrx  dword 0
    vry  dword 0
    interm  dd 0
    rez  dd 0

.code
main PROC
    mov edx,OFFSET mes1
    call WriteString ; afisarea mes1

    mov  eax,100     ;get random 0 to 99
    call RandomRange ;
    sub eax,50
    mov  vrx,eax  ;save random number
    call WriteInt ; afisarea rezultatului cu semn
    call Crlf ; din rand nou

    mov edx,OFFSET mes2
    call WriteString ; afisarea mes2

    mov  eax,100     ;get random 0 to 99
    call RandomRange ;
    sub eax,50
    mov  vry,eax  ;save random number
    call WriteInt ; afisarea rezultatului cu semn
    call Crlf ; din rand nou


    ;controlam conditiile
    xor eax,eax
    mov edx,0

    mov eax,vry
    mov bx,2
    mul bx ; calcul Y*2
    cmp eax,vrx ;compararea 2Y cu X
    jb con1 ; salt la con1, daca X>2Y


    mov edx,OFFSET f2
    call WriteString
    call Crlf

    mov eax,vry  ;realizam expresia 2Y + X/4 
    mov bx,2
    mul bx
    mov interm,eax
    mov eax,vrx
    mov bx,4
    div bx
    add eax,interm
    mov rez,eax
    jmp ex ; salt neconditionat la ex

    con1: 
    mov edx,OFFSET f1
    call WriteString
    call Crlf

    mov eax,vrx  ; realizam expresia 2(X - Y) + 81 
    sub eax,vry
    mov bx,2
    mul bx
    add eax,81
    mov rez,eax

    ex: mov edx,OFFSET mes3
    call WriteString ; afisarea mesajului mes3 
    call WriteInt ; afisarea rezultatului cu semn
    call Crlf ; din rand nou
        
	exit
main ENDP
END main    
