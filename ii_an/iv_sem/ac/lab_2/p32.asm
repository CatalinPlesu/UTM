INCLUDE Irvine32.inc

	; Sa se calculeze expresia aritmetica:  e=((a+b*c-d)/f+g*h)/i
	; se considera    a, d, f – cuvant  b, c, g, h, i –byte
	; ca sa putem executa impartirea cu f convertim impartitorul la dublucuvânt
	; ne vor interesa doar caturile impartirilor,  rezultatul va fi de tip octet
	
	.data 
	  	a dw 5
		b db 6
		cd db 10
		d dw 5
		f dw 6
		g db 10
		h db 11
		i db 10
		interm dw ?
		rez db ?

	.code 
	 main proc
		mov eax,0
		mov al, b
		imul cd			; in ax avem b*c
		add ax, a		; ax=b*c+a
		sub ax, d		; ax=b*c+a-d
		cwd		; am convertit cuvantul din ax, in dublu cuvantul , retinut in dx:ax
		idiv f			; obtinem câtul în ax  si restul în dx ax=(a+b*c-d)/f
		mov interm, ax	; interm=(a+b*c-d)/f
		mov al, g
		imul h			; ax=g*h
		add ax, interm		; ax=(a+b*c-d)/f+g*h
		idiv i			; se obtine catul în al si restul în ah
		mov rez, al

exit
main ENDP
END main

; Date de test : vom obţine rezultatul ((a+b*c-d)/f+g*h)/i=((5+6*10-5)/6+10*11)/10= 12
