#!/usr/bin/env bash
set -euo pipefail

# ビルドスクリプト: コンテナ内で実行想定
# uplatex + dvipdfmx 既定。引数に -lualatex や -xelatex 追加で切替可能
TARGET=${1:-main.tex}

latexmk -silent -interaction=nonstopmode $TARGET

echo "PDF生成完了: $(basename $TARGET .tex).pdf"
