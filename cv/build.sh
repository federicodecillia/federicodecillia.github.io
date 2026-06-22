#!/bin/bash
# Rigenera il PDF del CV da cv.html (font + foto incorporati in questa cartella),
# poi lo copia nella public/ del sito cosi' il "Download CV" del portfolio punta alla versione aggiornata.
# Il PDF resta in QUESTA cartella (cv/), versionato in git insieme al sorgente.
#
# USO:
#   1. modifica il testo in cv.html (e' solo HTML: cambi le parole tra i tag)
#   2. ./build.sh
#   3. git add -A && git commit -m "update cv" && git push   (pubblica sito + salva storico)
set -e
cd "$(dirname "$0")"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
OUT="Federico-De-Cillia-CV-2026.pdf"
SITE_PDF="../public/federico-de-cillia-cv.pdf"

"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer --allow-file-access-from-files \
  --virtual-time-budget=3000 --print-to-pdf="$OUT" "file://$PWD/cv.html"

cp "$OUT" "$SITE_PDF"

echo "PDF generato:    $PWD/$OUT"
echo "Copiato in sito: $(cd "$(dirname "$SITE_PDF")" && pwd)/$(basename "$SITE_PDF")"
echo ">> Per pubblicare: git add -A && git commit -m 'update cv' && git push"
