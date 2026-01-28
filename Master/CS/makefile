# Definirea variabilelor pentru numele fișierelor
INPUT_MD_AI = ./ai.md
INPUT_MD_EU = ./eu.md
OUTPUT_ODT_AI = plesu_catalin_ai.odt
OUTPUT_ODT_EU = plesu_catalin.odt
TEMPLATE_ODT = ./template.odt

odt:
	pandoc $(INPUT_MD_AI) -o $(OUTPUT_ODT_AI) --variable lang=ro --wrap=none --listings --reference-doc=$(TEMPLATE_ODT)
	pandoc $(INPUT_MD_EU) -o $(OUTPUT_ODT_EU) --variable lang=ro --wrap=none --listings --reference-doc=$(TEMPLATE_ODT)

pdf: png odt
	libreoffice --headless --convert-to pdf $(OUTPUT_ODT_AI)
	libreoffice --headless --convert-to pdf $(OUTPUT_ODT_EU)

png:
	Rscript data.r
	Rscript data2.r
	Rscript data3.r
