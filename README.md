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

## パッケージ追加
容量最適化のためフルインストールではありません。追加が必要な場合:
```bash
# 一時的に root になる
docker run --rm -it --user root japanese-latex:latest bash
apt-get update && apt-get install -y texlive-bibtex-extra biber && rm -rf /var/lib/apt/lists/*
```
あるいは Dockerfile を編集し再ビルド。

## tlmgr について
Debian の TeXLive は OS パッケージ管理下のため tlmgr での更新は推奨されません。追加パッケージは apt 経由で対応してください。

## 典型的トラブルシュート
- フォントが見つからない: `fc-list | grep -i ipa` で確認
- パッケージ不足: `.log` を確認し足りないパッケージを apt で追加
- 文字化け: ソースのエンコーディングを UTF-8 に統一

## ライセンス
この設定ファイル群自体は自由に再利用可能です（TeX Live は各パッケージのライセンスに従います）。
