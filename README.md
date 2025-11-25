# 日本語対応 LaTeX Docker 環境

日本語文書を uplatex / LuaLaTeX / XeLaTeX で組版できる軽め構成の Docker イメージです。

## 特徴
- Debian slim ベースで不要キャッシュ削除済み
- 日本語フォント: IPAex, Noto CJK
- TeXLive 日本語関連パッケージ (texlive-lang-japanese) + 代表的ラテン拡張
- `latexmk` を使った自動ビルド設定 (`~/.latexmkrc`)
- uplatex + dvipdfmx を標準、オプションで LuaLaTeX / XeLaTeX

## セットアップ
```bash
# ビルド
docker build -t japanese-latex:latest .

# サンプルをボリューム共有して起動
docker run --rm -it -v $(pwd)/sample:/home/latex/work japanese-latex:latest
```

または docker-compose 利用:
```bash
docker compose up --build
# その後: docker exec -it japanese-latex bash
```

## ビルド例 (コンテナ内)
```bash
cd ~/work
bash build.sh              # main.tex を uplatex + dvipdfmx で PDF 化
latexmk -lualatex main.tex # LuaLaTeX
latexmk -xelatex main.tex  # XeLaTeX
```
生成結果は `main.pdf`。

## Bibliography (BibTeX / Biber)
このイメージには `texlive-bibtex-extra` と `biber` が含まれ、BibLaTeX / Biber を利用できます。

サンプル: `sample/main_biblatex.tex` と `sample/refs.bib` を用意しています。
```bash
# BibLaTeX サンプル PDF 生成
make pdf-bib          # => sample/main_biblatex.pdf

# 監視モード (変更自動再ビルド)
make watch TEX=main_biblatex.tex
```
`latexmk` は文書中の `\usepackage{biblatex}` と `.bcf` の変更を検知し自動的に Biber を呼び出します。

従来型 BibTeX を使う場合 (例: \bibliographystyle{jplain} 等) も同梱の `bibtex` コマンドをそのまま利用できます。`latexmk` が必要回数再コンパイルを自動処理します。

## パッケージ追加
さらに必要なパッケージがあれば Dockerfile に追記し再ビルドしてください (例: `texlive-pictures`, `texlive-generic-extra` など)。

## tlmgr について
Debian の TeXLive は OS パッケージ管理下のため tlmgr での更新は推奨されません。追加パッケージは apt 経由で対応してください。

## 典型的トラブルシュート
- フォントが見つからない: `fc-list | grep -i ipa` で確認
- パッケージ不足: `.log` を確認し足りないパッケージを apt で追加
- 文字化け: ソースのエンコーディングを UTF-8 に統一

## ライセンス
この設定ファイル群自体は自由に再利用可能です（TeX Live は各パッケージのライセンスに従います）。
