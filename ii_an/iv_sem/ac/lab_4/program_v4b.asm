INCLUDE Irvine32.inc

    ; Aceeași problemă pentru cazul când nu se cunoaște numărul de
    ; caractere din şir, ci doar că acesta se termină cu un caracter special.

.data
msg    BYTE   "catalin",0
ecxbkp DWORD  ?     ;save ecx if necessary 


.code
    main PROC
    mov ecx, SIZEOF msg                   ;initialize loop counter   
    mov eax, OFFSET msg                   ;address of msg
    mov esi, eax                          ;esi points to start       
    add eax, ecx               
    mov edi, eax               
    dec edi
    dec edi                               ;edi points to end
    shr ecx,1                             ;shift loop counter 

L1: 
    mov al, [esi]                         ;load characters
    mov bl, [edi]
    mov [esi], bl                         ;swap characters
    mov [edi], al
    inc esi                               ;update forward pointer by 1
    dec edi                               ;update backward pointer by 1
loop L1

; display the string

mov  edx,OFFSET msg
call WriteString
call Crlf                       

exit
main ENDP

END main

