# CLAUDE.md — federicodecillia.github.io

Repo del **sito portfolio + CV** di Federico De Cillia. Questi due artefatti, insieme
al suo **profilo LinkedIn**, sono i "3 canali" che devono raccontare la stessa storia
con gli stessi numeri. Scopo strategico: candidatura ad **Anthropic Milano** (ruoli
Applied AI / Forward Deployed / Solutions). LinkedIn e' la fonte di verita'; sito e CV
si allineano a quello.

## Cosa c'e' in questa repo

```
src/                Sito Astro 6 (Tailwind v4, deploy GitHub Pages via Actions)
  components/*.astro  Hero (intro+about fusi), MetricStrip, SelectedWork, EarlierWork,
                      Experience, Education, Skills, Contact, Nav, Footer, WorkCard
  pages/index.astro   Ordine delle sezioni della home
  pages/work/         Case study (MDX)
public/             Statici serviti as-is, incl. federico-de-cillia-cv.pdf (il CV scaricabile)
cv/                 SORGENTE del CV (HTML->PDF). Vedi cv/README.md
.github/workflows/  deploy.yml (build Astro + deploy su push a master)
```

## Le due superfici e come si aggiornano

**1. Sito** — componenti `.astro` in `src/components/`. I dati (ruoli, skill, metriche,
education, certificazioni) sono array JS in cima a ciascun componente:
`Experience.astro`, `Education.astro`, `Skills.astro`, `MetricStrip.astro`. L'intro
(headline + about) e' in `Hero.astro`. Per verificare: `npm run dev`.

**2. CV** — cartella `cv/`. E' un file `cv.html` (HTML+CSS, font + foto incorporati)
renderizzato in PDF da Chrome headless via `cv/build.sh`. Il build scrive il PDF in
`cv/` **e** lo copia in `public/federico-de-cillia-cv.pdf`. Procedura completa
(modifiche di testo vs modifiche CSS) in **`cv/README.md`** — leggilo prima di toccare
il CV.

## Regola d'oro: tieni i 3 canali allineati

Se cambi un dato che vive in piu' canali (un numero, un ruolo, un titolo, una
certificazione), aggiornalo **ovunque**:
- LinkedIn (lo fa Federico a mano: fonte di verita')
- Sito: il componente `.astro` giusto
- CV: `cv/cv.html` poi `cd cv && ./build.sh`

I numeri canonici attuali (metriche): **12+ yrs** AI & data science · **100+** AI
projects shipped · **50+** businesses served. Headline/tagline:
"I build reliable AI agents that augment people."

### Skills: CV ↔ sito devono restare coerenti (verifica SEMPRE)

Le skill vivono in due posti e divergono facilmente:
- Sito: `src/components/Skills.astro` (array `groups`, stile a chip).
- CV: `cv/cv.html`, sezione `.band` -> colonna `Skills` (`.skillrow`).

Ogni volta che tocchi le skill di uno dei due, **riallinea l'altro**: i gruppi
condivisi (AI engineering, Data science & ML, Data & cloud, Apps & web, Languages)
devono avere le stesse voci e lo stesso wording, senza contraddizioni. Il sito puo'
tenere gruppi extra che nel CV non stanno per motivi di spazio (oggi:
**BI & visualization**, **Delivery**); va bene, purche' non contraddicano il CV.
Dopo l'allineamento rigenera il CV (`cd cv && ./build.sh`) se l'hai modificato.

## Deploy

Push a `master` -> GitHub Action builda e pubblica su GitHub Pages (~1-2 min). Un
solo push aggiorna sito + CV scaricabile + salva lo storico del CV in git.
Astro builda solo `src/` e `public/`: la cartella `cv/` viene ignorata dal build (e'
solo il sorgente versionato).

```
git add -A && git commit -m "..." && git push
```

## Stile (preferenze di Federico)

- Output conciso, diretto, niente filler. Italiano di default, inglese per i termini
  tecnici. Niente em dash nelle risposte in chat.
- Per modifiche al CV: verifica sempre il render prima di dichiarare fatto
  (`qlmanage -t -s 1700 -o <dir> cv/Federico-De-Cillia-CV-2026.pdf` produce un PNG
  ispezionabile). Il CV deve stare su **una sola pagina A4**.
- Conferma prima di operazioni git distruttive o force-push.
