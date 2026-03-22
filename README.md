# difflatex

使用 `latexdiff` 比較兩份 LaTeX 文件，並自動編譯出差異 PDF。

本專案提供腳本 `create_difflatex.bash`，會完成以下流程：
- 編譯 `old.tex`（含 BibTeX）
- 編譯 `new.tex`（含 BibTeX）
- 產生 `diff.tex`
- 編譯 `diff.tex`（含 BibTeX）
- 自動開啟 `diff.pdf`

## 1. 安裝 LaTeX（macOS）

請直接從 MacTeX 官方下載頁安裝：

- https://www.tug.org/mactex/mactex-download.html

安裝完成後，重新開啟終端機，並確認指令可用：

```bash
pdflatex --version
bibtex --version
```

## 2. 安裝與確認 `latexdiff`

有些環境下 `latexdiff` 不一定會跟著安裝，請額外確認：

```bash
latexdiff --version
```

若找不到，可用 TeX Live 安裝：

```bash
sudo tlmgr install latexdiff
```

## 3. 下載專案並準備檔案

專案目錄重點：

```text
difflatex/
  create_difflatex.bash
  files/
    old.tex
    old.bib
    new.tex
    new.bib
```

請把要比較的兩版論文放在 `files/`：
- 舊版：`files/old.tex`、`files/old.bib`
- 新版：`files/new.tex`、`files/new.bib`

> `create_difflatex.bash` 目前固定使用 `old` / `new` 當檔名。

## 4. 執行腳本

在專案根目錄執行：

```bash
bash create_difflatex.bash
```

執行成功後會產生：
- `diff_latex/diff.tex`
- `diff_latex/diff.pdf`
- `diff_latex/logs/*.log`（各步驟 log）

並且會自動開啟 `diff_latex/diff.pdf`。

## 5. 輸出清單

- `diff_latex/old.*`：舊版編譯產物
- `diff_latex/new.*`：新版編譯產物
- `diff_latex/diff.tex`：latexdiff 生成的 LaTeX
- `diff_latex/diff.pdf`：最終差異 PDF
- `diff_latex/logs/*.log`：每一步驟記錄
