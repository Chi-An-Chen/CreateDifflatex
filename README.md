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

## 5. 手動流程（不使用腳本）

若你要手動執行，可參考：

```bash
cd files

pdflatex old.tex
bibtex old
pdflatex old.tex
pdflatex old.tex

pdflatex new.tex
bibtex new
pdflatex new.tex
pdflatex new.tex

latexdiff old.tex new.tex > diff.tex
pdflatex diff.tex
bibtex diff
pdflatex diff.tex
pdflatex diff.tex
open diff.pdf
```

## 6. 常見問題

### `Error: 'pdflatex' not found`
代表 LaTeX 未安裝完成，或 PATH 尚未包含 `/Library/TeX/texbin`。

### `Error: 'latexdiff' not found`
請執行：

```bash
sudo tlmgr install latexdiff
```

### 編譯失敗但不知道原因
請查看 `diff_latex/logs/` 內對應 log，例如：
- `diff_latex/logs/old_pdflatex_1.log`
- `diff_latex/logs/new_bibtex.log`
- `diff_latex/logs/diff_latexdiff.log`

## 7. 輸出清單

- `diff_latex/old.*`：舊版編譯產物
- `diff_latex/new.*`：新版編譯產物
- `diff_latex/diff.tex`：latexdiff 生成的 LaTeX
- `diff_latex/diff.pdf`：最終差異 PDF
- `diff_latex/logs/*.log`：每一步驟記錄
