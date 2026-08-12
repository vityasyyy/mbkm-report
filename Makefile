# Laporan MBKM Makefile
# Mendukung kompilasi lokal (membutuhkan texlive) dan kompilasi Docker

.PHONY: help report presentation clean clean-report clean-presentation report-docker presentation-docker all all-docker

help:
	@echo "Laporan MBKM - Build Options"
	@echo "============================"
	@echo ""
	@echo "Kompilasi Lokal (membutuhkan texlive):"
	@echo "  make report          - Kompilasi report/main.tex (pdflatex)"
	@echo "  make presentation    - Kompilasi presentation/main.tex (xelatex)"
	@echo "  make all             - Kompilasi laporan dan presentasi"
	@echo "  make clean           - Bersihkan file build"
	@echo ""
	@echo "Kompilasi Docker (tanpa texlive):"
	@echo "  make report-docker       - Kompilasi laporan di container"
	@echo "  make presentation-docker - Kompilasi presentasi di container"
	@echo "  make all-docker          - Kompilasi keduanya di container"

report:
	cd report && \
		pdflatex -interaction=nonstopmode main.tex && \
		pdflatex -interaction=nonstopmode main.tex

presentation:
	cd presentation && latexmk -xelatex main.tex

clean: clean-report clean-presentation

clean-report:
	cd report && rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg *.glo || true

clean-presentation:
	cd presentation && latexmk -C && rm -rf build || true

DOCKER_IMAGE := mbkm-report-latex
DOCKER_TAG := latest

build-docker:
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) -f docker/Dockerfile .

report-docker: build-docker
	docker run --rm -v $(PWD)/report:/workspace/report $(DOCKER_IMAGE):$(DOCKER_TAG) sh -c "cd /workspace/report && pdflatex -interaction=nonstopmode main.tex && pdflatex -interaction=nonstopmode main.tex"

presentation-docker: build-docker
	docker run --rm -v $(PWD)/presentation:/workspace/presentation $(DOCKER_IMAGE):$(DOCKER_TAG) sh -c "cd /workspace/presentation && latexmk -xelatex main.tex"

all: report presentation

all-docker: report-docker presentation-docker
