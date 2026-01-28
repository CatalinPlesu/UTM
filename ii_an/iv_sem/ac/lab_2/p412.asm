INCLUDE Irvine32.inc

; De calculat: z=(2+1/a)/(3+1/(b*b))-1/(c*c)

.data
    two DD 2.0
    one DD 1.0
    three DD 3.0
    aa DD 5.0
    bb DD 6.0
    cc DD 10.0
    interm1 REAL4 ?
    interm2 REAL4 ?
    interm3 REAL4 ?
    rez REAL4 ?

.code
    main proc

    fld one ;push 'one' to ST
    fld aa   ;push 'a' to ST
    fdiv ;divide ST(0) / ST(1, and puts it in ST(0); st(0) = 1  /a
    fld two
    fadd ; st(0) = 2 + 1 / a
    fstp interm1 ; = (2 + 1 / a)

    fld bb
    fld bb
    fmul ;(b*b)
    fld one
    fdivr ;1/(b*b) 
    fld three
    fadd
    fstp interm2 ; = (3 + 1 / (b * b)

    fld cc
    fld cc
    fmul
    fld one
    fdivr 
    fstp interm3; = -1 / (c * c)

    fld interm3
    fld interm2
    fld interm1

    fdivr
    fsubr
    fstp rez
    
    fld rez
    call WriteFloat
    call Crlf ; din rand nou

exit
main ENDP
END main

; Date de test : vom obţine rezultatul 
; z = ((2+1/a)/(3+1/(b*b))-1/(c*c)) = ((2+1/5)/(3+1/(6*6))-1/(10*10)) = 0.71
