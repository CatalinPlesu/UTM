# Definirea variabilelor pentru numele fișierelor
INPUT_MD = ./tor.md
OUTPUT_ODT = plesu_catalin_tor.odt
TEMPLATE_ODT = ./template.odt

pdf: odt
	libreoffice --headless --convert-to pdf $(OUTPUT_ODT)

odt:
	# pandoc $(INPUT_MD) -o $(OUTPUT_ODT) --variable lang=ro --wrap=none --listings --reference-doc=$(TEMPLATE_ODT)
	pandoc $(INPUT_MD) -o $(OUTPUT_ODT) --variable lang=ro --wrap=none


