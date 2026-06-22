# CV — Federico De Cillia

Sorgente del CV in PDF, versionato insieme al sito portfolio (stessa repo). Il PDF
scaricabile dal sito (`/federico-de-cillia-cv.pdf`) viene generato da qui.

## Come e' fatto

Il CV e' un file **HTML+CSS** (`cv.html`) renderizzato in PDF da Chrome headless.
Nessun Word, nessun `.pages`, nessun tool esterno: controllo tipografico totale e
output identico ogni volta. Font (Inter + Fraunces) e foto sono in questa cartella e
vengono incorporati nel PDF, quindi il file e' autosufficiente.

```
cv/
  cv.html                       <- IL sorgente (testo + layout)
  build.sh                      <- genera il PDF e lo copia nel sito
  headshot.jpg                  <- foto in alto a sinistra
  *.woff2                       <- font incorporati (non toccare)
  Federico-De-Cillia-CV-2026.pdf <- output (versionato in git)
```

## Modifiche semplici (testo / wording) — autonome

Per cambiare parole, numeri, una riga di esperienza, una certificazione:

1. Apri `cv.html` in un editor. E' solo HTML: il testo sta **tra i tag**.
   - Summary: dentro `<div class="summary">...</div>`
   - Un ruolo: dentro un blocco `<div class="job">` (titolo in `<b>`, azienda nello `<span>`, date in `.job-dates`, punti elenco nei `<li>`)
   - Le card numeriche: dentro `.metric` (`.n` = numero, `.l` = etichetta)
   - Certificazioni: una riga `<div class="certline">` ciascuna
   - Contatti / link: dentro `.contact`
2. Salva.
3. Lancia il build:
   ```bash
   ./build.sh
   ```
4. Pubblica (vedi sotto).

Non serve toccare il CSS per questo. Non serve chiedere a nessuno.

## Modifiche strutturali (layout / stile) — richiedono il CSS

Tutto lo stile e' nel blocco `<style>` in cima a `cv.html`. Punti chiave:

- **Colori**: variabili in `:root` (`--clay` accento, `--ink` testo, `--muted`/`--faint` grigi, `--soft` sfondo card).
- **Pagina**: `.page` (`padding` = margini A4) e `@page{size:A4}`. Se il contenuto sfora in una seconda pagina, riduci i `font-size` o i `margin-bottom` delle sezioni, oppure il `padding` di `.page`.
- **Sezioni**: `.sec` e' l'intestazione (clay, maiuscolo, riga sotto). Dentro la banda finale le due colonne usano `.band .sec`.
- **Esperienza**: `.job` blocco normale (con bullet `.bullets li`), `.job.compact` = riga singola senza bullet (usata per i ruoli minori e per Education).
- **Banda finale**: `.band` e' una griglia 2 colonne (Skills | Certifications). `.skillrow` a sinistra, `.certline` a destra.

Regola pratica: cambi di contenuto -> body; cambi di forma -> `<style>`. Dopo ogni
modifica rilancia `./build.sh` e controlla il PDF.

## Sync col sito

`build.sh` fa due cose:
1. genera `Federico-De-Cillia-CV-2026.pdf` in questa cartella;
2. lo copia in `../public/federico-de-cillia-cv.pdf` (il file che il sito mette in download).

Quindi **il sito e il CV sono sempre allineati**: basta rigenerare e committare.

## Pubblicare e salvare lo storico

Tutto e' nella repo del sito (`federicodecillia.github.io`). Un solo push aggiorna il
sito **e** salva la versione del CV nello storico git:

```bash
git add -A
git commit -m "update cv: <cosa hai cambiato>"
git push
```

Il push fa partire la GitHub Action che ridepoia il sito; entro ~1-2 minuti il
"Download CV" del portfolio serve la versione nuova. Per ritrovare una versione
vecchia del CV: `git log -- cv/cv.html` e `git checkout <hash> -- cv/cv.html`.

## Allineamento dei 3 canali

Il CV e' uno dei tre canali (LinkedIn, sito portfolio, CV) che devono raccontare la
stessa storia con gli stessi numeri. Se cambi un dato importante qui (es. un numero,
un ruolo), aggiornalo anche su LinkedIn e nei componenti del sito
(`src/components/Experience.astro`, `Education.astro`, `Skills.astro`, `MetricStrip.astro`).
