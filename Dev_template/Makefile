MAIN=main.tex
LATEX=lualatex
OUT=out
PDF=$(OUT)/main.pdf

.PHONY: build watch clean open

build:
	$(LATEX) -output-directory=$(OUT) $(MAIN)

watch:
	latexmk -cd -pvc -pdf -outdir=../$(OUT) $(MAIN)

clean:
	latexmk -cd -C -outdir=../$(OUT) $(MAIN)
	rm -rf $(OUT)