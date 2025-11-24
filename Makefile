# 日本語 LaTeX を Docker コンテナ内でビルドする Makefile
# 使い方 (例):
#   make image          # イメージビルド
#   make pdf            # main.pdf を生成 (既定: uplatex)
#   make pdf ENGINE=lualatex  # LuaLaTeX で生成
#   make watch          # ファイル監視 (Ctrl+C で終了)
#   make clean          # 生成物削除
#   make open           # macOS で PDF を開く
# 変数上書き例: make TEX=other.tex pdf

IMAGE ?= japanese-latex:latest
DOCKERFILE ?= Dockerfile
WORKDIR_HOST ?= $(PWD)/sample
WORKDIR_CONT ?= /home/latex/work
TEX ?= main.tex
ENGINE ?= uplatex        # uplatex | lualatex | xelatex
LATEXMK_OPTS ?= -silent -interaction=nonstopmode
CONTAINER_NAME ?= japanese-latex-tmp
PDF := $(WORKDIR_HOST)/$(basename $(TEX)).pdf

ENGINE_FLAG_uplatex =
ENGINE_FLAG_lualatex = -lualatex
ENGINE_FLAG_xelatex = -xelatex
ENGINE_FLAG = $(ENGINE_FLAG_$(ENGINE))

.PHONY: image pdf watch clean open shell help

help:
	@echo "Targets: image pdf watch clean open shell"
	@echo "Variables: IMAGE TEX ENGINE (uplatex|lualatex|xelatex)"

image: $(DOCKERFILE)
	docker build -t $(IMAGE) -f $(DOCKERFILE) .

# 一度限りのビルド (コンテナは終了後削除)
pdf: image $(WORKDIR_HOST)/$(TEX)
	@echo "==> Building $(TEX) with ENGINE=$(ENGINE)"
	docker run --rm \
		-v $(WORKDIR_HOST):$(WORKDIR_CONT) \
		-w $(WORKDIR_CONT) \
		$(IMAGE) latexmk $(ENGINE_FLAG) $(LATEXMK_OPTS) $(TEX)
	@echo "==> Output: $(PDF)"
	@test -f $(PDF) || (echo "PDF not generated" && exit 1)

# 監視モード (ログを流す). Ctrl+C で止める
watch: image $(WORKDIR_HOST)/$(TEX)
	@echo "==> Watching $(TEX) (ENGINE=$(ENGINE))"
	docker run --rm -it \
		-v $(WORKDIR_HOST):$(WORKDIR_CONT) \
		-w $(WORKDIR_CONT) \
		$(IMAGE) latexmk $(ENGINE_FLAG) -pvc $(LATEXMK_OPTS) $(TEX)

# 作業用シェルを開く
shell: image
	docker run --rm -it -v $(WORKDIR_HOST):$(WORKDIR_CONT) -w $(WORKDIR_CONT) $(IMAGE) bash

clean:
	@echo "==> Cleaning auxiliary files"
	@rm -f $(WORKDIR_HOST)/*.aux $(WORKDIR_HOST)/*.log $(WORKDIR_HOST)/*.out \
		$(WORKDIR_HOST)/*.dvi $(WORKDIR_HOST)/*.fdb_latexmk $(WORKDIR_HOST)/*.fls \
		$(WORKDIR_HOST)/*.synctex.gz
	@echo "==> Done"

open: $(PDF)
	open $(PDF)
