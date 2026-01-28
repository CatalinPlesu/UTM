in_filename=document
out_filename=Plesu_Catalin_TI_206_Practica_In_Productie.pdf

run: compile clean

compile:
	xelatex ${in_filename}
	biber ${in_filename}||true
	xelatex ${in_filename}
	# xelatex -interaction=nonstopmode ${in_filename}
	mv ${in_filename}.pdf ${out_filename}

read:
	zathura ${out_filename} &

clean:
	rm -f *.{ps,log,aux,out,dvi,bbl,blg,toc,lof,xml,bcf}

remove:
	rm -f *.{pdf,ps,log,aux,out,dvi,bbl,blg,toc,lof,xml,bcf}

