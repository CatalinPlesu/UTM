INCLUDE Irvine32.inc
.data
alfa    DW    3 DUP(?)
.code
main proc
mov    ax,17  ; adresare indirecta a operandului sursa
mov    ax,10101b   ;
mov    ax,11b         ;
mov    ax,21o         ;
mov    alfa,ax          ; Adresare directa a operandului destinatie
mov    cx,ax	  ; Interschimba registrele ax si bx
mov    ax,bx	  ; Folosind registrul cx
mov    ax,cx  	  ;
xchg   ax,bx	  ; Interschimba direct cele 2 registre.
mov	  si,2
;mov	  alfa[si],ax  ; Adresare relativa cu registrul si
mov	  esi,2
mov	  ebx,offset alfa ; Adresare imediata a operandului sursa
lea	  ebx,alfa        ; Acelasi efect
mov     ecx,[ebx][esi]  ; Adresare bazata indexata a sursei
mov     cx,alfa[2]   ; Acelasi efect.
mov     cx,[alfa+2]  ; Acelasi efect
mov     di,4
;mov     byte ptr [ebx][edi],55h  ;
mov     esi,2
mov     ebx,3
mov     alfa[ebx][esi],33h  ; Adresare bazata indexata relativa a 
                                          ; destinatiei
mov     alfa[ebx+esi],33h   ; Notatii echivalente
mov     [alfa+ebx+esi],33h
mov     [ebx][esi]+alfa,33h

exit
main ENDP
END main
