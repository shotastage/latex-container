# 日本語対応 LaTeX 環境用 Dockerfile
# ベースイメージ: Debian slim で最小限から構築
FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Tokyo \
    LANG=ja_JP.UTF-8 \
    LC_ALL=ja_JP.UTF-8 \
    USER=latex \
    HOME=/home/latex

# 必要パッケージ & TeX Live 日本語関連
# tlmgr を活用しやすくするため texlive-full ではなく必要パッケージを列挙（サイズ最適化）
# 追加したい場合は README を参照
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    locales tzdata ca-certificates make ghostscript wget perl fontconfig \
    fonts-noto-cjk fonts-ipaexfont \
    texlive-base texlive-latex-base texlive-latex-recommended texlive-latex-extra \
    texlive-fonts-recommended texlive-fonts-extra texlive-lang-japanese texlive-science \
    texlive-xetex texlive-luatex latexmk texlive-bibtex-extra biber && \
    echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen ja_JP.UTF-8 && \
    update-ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# tlmgr 用の PATH 設定（Debian TeXLive の場合既に入っているが念のため）
ENV PATH=/usr/bin:$PATH

# 非 root ユーザ作成
RUN useradd -m -s /bin/bash ${USER}
USER ${USER}
WORKDIR ${HOME}/work

# latexmk のデフォルト設定（uplatex + dvipdfmx / lualatex 等切替可能）
COPY --chown=latex:latex latexmkrc /home/latex/.latexmkrc

# エントリポイント: デフォルトで bash を開く
ENTRYPOINT ["/bin/bash"]
CMD ["-l"]

# ビルド例:
# docker build -t japanese-latex:latest .
# 実行例:
# docker run --rm -it -v $(pwd)/sample:/home/latex/work japanese-latex:latest
