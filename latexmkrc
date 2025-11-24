# ~/.latexmkrc 日本語設定例
# uplatex + dvipdfmx (伝統的和文) を既定に
$pdf_mode = 3;           # 3 = dvipdfmx
$latex = 'uplatex -synctex=1 -interaction=nonstopmode';
$dvipdf = 'dvipdfmx';

# LuaLaTeX で処理したい場合はコマンドラインで: latexmk -lualatex main.tex
# XeLaTeX で: latexmk -xelatex main.tex

# 自動クリーンファイルリスト追加
$clean_ext = 'synctex.gz aux log out dvi fdb_latexmk fls';

# 連続監視モード時のポーリング間隔
$poll_time = 2;

# エラー時も継続
$halt_on_error = 0;
