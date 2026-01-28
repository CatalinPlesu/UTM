INCLUDE Irvine32.inc
.data
Promt DB 'Doresti sa devii programator?(da/nu)-[y/n]', 0
Dad DB 13, 10, 'Vei deveni!', 13, 10, 0
Nud DB 13, 10, 'Vei deveni filosof!', 13, 10, 0
.code                     ;directiva ce declara inceputul segmentului de cod
main PROC                 ;se indica procedura cu numele main
mov edx, OFFSET Promt
call WriteString
call ReadChar
cmp al,'y'                ;compararea continutului registrului al cu codul ASCII a literei y 
jz IsDad                  ;salt conditionat (jz-jump if zero), daca rezultatul compararii este zero, salt la eticheta IsDad
cmp al,'n'                ;compararea- din al se scade codul ASCII a literei n
jz IsNud                  ;da, rezultatul compararii este zero, salt la eticheta IsNud

IsDad: mov edx,OFFSET Dad ;in edx offsetul sirului Dad
call WriteString
jmp ex
IsNud: mov edx,OFFSET Nud ;in edx offsetul sirului "Nud"
call WriteString

ex:
    exit                  ;apel la procedura de iesirea din program, din fisierul Irvine32.inc 
main ENDP                 ;sfarsitul procedurii main                                           
END main                  ;finalizarea programului/ punctul de intrare in program              
