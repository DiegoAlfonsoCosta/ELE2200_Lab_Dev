MAIN=src/main.tex
OUT=out
PDF=$(OUT)/main.pdf

.PHONY: build watch clean open

build:
	latexmk -cd -pdf -outdir=../$(OUT) $(MAIN)

open:
	open $(PDF)

build-open: build open

watch:
	latexmk -cd -pvc -pdf -outdir=../$(OUT) $(MAIN)

clean:
	latexmk -cd -C -outdir=../$(OUT) $(MAIN)
	rm -rf $(OUT)