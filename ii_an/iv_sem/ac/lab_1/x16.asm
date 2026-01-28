;exemplu de program pe 16 biti
INCLUDE Irvine16.inc
.DATA
Promt  DB  'Doresti sa devii programator?(da/nu)-[y/n]$'
Dad  DB  13,10,'Vei deveni!',13,10,'$'
Nud  DB  13,10,'Vei deveni filosof!',13,10,'$'
.CODE                       ;directiva ce declara inceputul segmentului de cod
main PROC                   ;se indica procedura cu numele main
mov ax,@data                ;Initializarea segmentului de date ds 
mov ds,ax                   ;cu adresa datelor
mov dx,OFFSET Promt         ;in dx- deplasamentul (offset) sirului Promt
mov ah,9                    ;functia MSDOS, codul functiei 9 - afisarea sirului
Int 21h                     ;intreruperea 21h - apel la serviciul MSDOS
mov ah,1                    ;functia MSDOS, codul functiei 1 - introducerea de la tastatura(codul tastei)
Int 21h                     ;codul tastei in registrul al
cmp al,'y'                  ;compararea continutului registrului al cu codul ASCII a literei y 
jz IsDad                    ;salt conditionat (jz-jump if zero), daca rezultatul compararii este zero, salt la eticheta IsDad
cmp al,'n'                  ;compararea- din al se scade codul ASCII a literei n
jz IsNud                    ;da, rezultatul compararii este zero, salt la eticheta IsNud
IsDad: mov dx,OFFSET Dad    ;in dx- offsetul sirului Dad
Jmp SHORT Disp              ;Salt neconditionat la eticheta "Disp"
IsNud: mov dx,OFFSET Nud    ;in dx- offsetul sirului "Nud"
Disp: mov ah,9              ;functia MSDOS - afisarea sirului
Int 21h                     ;apel la serviciul MSDOS
mov ah,1                    ;asteptarea unui clic
Int 21h 
Exit                        ;apel la procedura de iesirea din program, din fisierul Irvine16.inc
main ENDP                   ;sfarsitul procedurii main
END main                    ;finalizarea programului/ punctul de intrare in program

