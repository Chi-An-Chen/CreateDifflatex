#!/bin/bash

set -euo pipefail

OLD="old"
NEW="new"
DIFF="diff"
SRC_DIR="files"
OUT_DIR="diff_latex"
LOG_DIR="${OUT_DIR}/logs"

check_cmd() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "Error: '$1' not found. Please install it first."
        exit 1
    }
}

run_quiet() {
    local name="$1"
    shift
    local log_file="${LOG_DIR}/${name}.log"

    if ! "$@" >"${log_file}" 2>&1; then
        echo "Error: ${name} failed. See ${log_file}"
        exit 1
    fi
}

check_cmd pdflatex
check_cmd bibtex
check_cmd latexdiff
check_cmd open

[[ -f "${SRC_DIR}/${OLD}.tex" ]] || { echo "Error: ${SRC_DIR}/${OLD}.tex not found."; exit 1; }
[[ -f "${SRC_DIR}/${NEW}.tex" ]] || { echo "Error: ${SRC_DIR}/${NEW}.tex not found."; exit 1; }

mkdir -p "${OUT_DIR}"
mkdir -p "${LOG_DIR}"

# Allow TeX/BibTeX to locate shared inputs under files/.
export TEXINPUTS="${SRC_DIR}//:${TEXINPUTS:-}"
export BIBINPUTS="${SRC_DIR}:${BIBINPUTS:-}"

echo "== Building ${OLD}.tex =="
run_quiet "${OLD}_pdflatex_1" pdflatex -output-directory "${OUT_DIR}" "${SRC_DIR}/${OLD}.tex"
run_quiet "${OLD}_bibtex" bibtex "${OUT_DIR}/${OLD}"
run_quiet "${OLD}_pdflatex_2" pdflatex -output-directory "${OUT_DIR}" "${SRC_DIR}/${OLD}.tex"
run_quiet "${OLD}_pdflatex_3" pdflatex -output-directory "${OUT_DIR}" "${SRC_DIR}/${OLD}.tex"

echo "== Building ${NEW}.tex =="
run_quiet "${NEW}_pdflatex_1" pdflatex -output-directory "${OUT_DIR}" "${SRC_DIR}/${NEW}.tex"
run_quiet "${NEW}_bibtex" bibtex "${OUT_DIR}/${NEW}"
run_quiet "${NEW}_pdflatex_2" pdflatex -output-directory "${OUT_DIR}" "${SRC_DIR}/${NEW}.tex"
run_quiet "${NEW}_pdflatex_3" pdflatex -output-directory "${OUT_DIR}" "${SRC_DIR}/${NEW}.tex"

echo "== Generating ${DIFF}.tex =="
if ! latexdiff "${SRC_DIR}/${OLD}.tex" "${SRC_DIR}/${NEW}.tex" >"${OUT_DIR}/${DIFF}.tex" 2>"${LOG_DIR}/${DIFF}_latexdiff.log"; then
    echo "Error: ${DIFF}_latexdiff failed. See ${LOG_DIR}/${DIFF}_latexdiff.log"
    exit 1
fi

echo "== Building ${DIFF}.tex =="
run_quiet "${DIFF}_pdflatex_1" pdflatex -output-directory "${OUT_DIR}" "${OUT_DIR}/${DIFF}.tex"
run_quiet "${DIFF}_bibtex" bibtex "${OUT_DIR}/${DIFF}"
run_quiet "${DIFF}_pdflatex_2" pdflatex -output-directory "${OUT_DIR}" "${OUT_DIR}/${DIFF}.tex"
run_quiet "${DIFF}_pdflatex_3" pdflatex -output-directory "${OUT_DIR}" "${OUT_DIR}/${DIFF}.tex"

echo "== Opening ${DIFF}.pdf =="
run_quiet "${DIFF}_open" open "${OUT_DIR}/${DIFF}.pdf"

echo "All done."