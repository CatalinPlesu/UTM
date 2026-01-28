INPUT = raport.md
OUTPUT = out/raport_daa_echipa_3.odt

pdf: odt
	libreoffice --headless --convert-to pdf $(OUTPUT) --outdir out
	mv out/raport_daa_echipa_3.pdf out/tmp.pdf
	pdfunite titlu.pdf out/tmp.pdf out/raport_daa_echipa_3.pdf
	rm out/tmp.pdf

odt: out
	pandoc $(INPUT) -o $(OUTPUT) --variable lang=ro --wrap=none --reference-doc=template.odt

out:
	mkdir out


docker-build:
	docker build -t pandoc-libreoffice .

# Nu merge cu make, de copiat aparte in terminal
docker-run:
	docker run --rm -v "$(pwd):/app" -v "$(pwd)/out:/app/out" pandoc-libreoffice
