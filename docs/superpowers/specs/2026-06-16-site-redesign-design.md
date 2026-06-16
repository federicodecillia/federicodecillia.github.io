# Redesign sito personale — design spec

Date: 2026-06-16
Status: approved (brainstorm), pronto per implementation plan
Owner: Federico De Cillia

## Contesto e obiettivo
Il sito attuale (`federicodecillia.github.io`) e' il template BootstrapMade "iPortfolio": jQuery + Bootstrap 4.5, statico, posizionamento fermo al 2021 ("Lead DS, AI researcher, Big Data Analyst"), form contatti in PHP morto su GitHub Pages. Va ricostruito da zero come vetrina moderna, coerente col posizionamento [[anthropic-positioning]]: enterprise AI leader + hands-on builder, GenAI/agenti in produzione, "built with Claude Code".

Obiettivo: sito molto appealing, credibile per un recruiter Anthropic (ruolo SA/Applied AI), che ospiti case study cliccabili come proof-of-work. Il rebuild stesso e' narrativa (52 tips / proof-of-work).

Success criteria:
- Posizionamento aggiornato (LLM, agenti, produzione) coerente con LinkedIn e CV.
- Almeno 2 case study cliccabili linkati a repo pubblici (ai-second-brain, wegrocery).
- Deploy automatico su GitHub Pages, form contatti funzionante.
- Estetica "warm editorial + sostanza", non un clone di anthropic.com.

## Stack
- Astro (ultima) + TypeScript.
- Tailwind CSS (integrazione ufficiale Astro).
- Case study in MDX via content collections (collection `work`).
- Deploy: GitHub Actions (`withastro/action`) -> GitHub Pages. User-page servita alla root: `site: 'https://federicodecillia.github.io'`, nessun `base`/basePath.
- Form: Web3Forms (endpoint serverless free, POST con access key). Niente PHP/backend.
- Font: serif editoriale display (Fraunces), sans corpo (Inter), mono per tag tecnici (es. JetBrains Mono). Google Fonts o self-host.
- Solo light mode in v1 (dark toggle = out of scope).

## Direzione visiva (blend A + C)
Linguaggio warm/editoriale (A) + sostanza/metriche/card (C). Tocco mono sui tag tecnici (accento da B).

Palette:
- Background: off-white caldo `#FBF8F2`.
- Inchiostro: near-black caldo `#1F1D1A`.
- Accento unico: terracotta/clay `#B5482B` (link, CTA, dettagli).
- Grigi caldi per bordi/testo secondario.

Tipografia: display serif (Fraunces) per H1/H2 hero e titoli sezione; Inter per corpo; mono per i tag stack. Sentence case ovunque. Molto whitespace.

## Sitemap
Single-page scroll per la landing + pagine dedicate per i case study.

Landing (`/`):
1. Hero — nome, "I build AI that ships.", sottotitolo posizionamento, CTA (Work, Contact, LinkedIn, GitHub).
2. Metric strip — 18,000+ store · 100+ deployment · 12+ anni AI & data science.
3. About — versione breve dell'About LinkedIn (enterprise + builder + frontier + drive) + foto.
4. Selected work — griglia di card; ognuna linka alla pagina MDX. Tag tecnici in mono.
5. Now / frontier — 2-3 righe su cosa esplora ora.
6. Contact — form Web3Forms + LinkedIn/GitHub/email.
- Footer — "Built with Astro + Claude Code", anno, link social.

Case study (`/work/<slug>`): layout MDX con problema, approccio, stack, impatto, link repo/demo, nota "built with Claude Code".

## Case study v1 (collection `work`)
1. ARIEL — agente di retail intelligence (Databricks/LLM, natural-language su dati enterprise). Numeri EL anonimizzati (no cifre in chiaro).
2. AI enablement — formazione + eventi AI interni (generico, niente nomi sensibili).
3. ai-second-brain — repo pubblico (lead magnet). Link a GitHub. Proof-of-work.
4. wegrocery / GAS — repo pubblico + demo live. Link a demo e repo. Proof-of-work.

Contenuti: riuso dell'About e delle voci esperienza gia' redatte. Nessun brand "gptchatbot.it" (resa come "independent AI practice"); attivita' freelance generica finche' Federico e' in EL (vedi vincolo art. 2105 in [[transizione-freelance]]). Numeri coerenti con LinkedIn/CV (una sola versione di ogni cifra).

## Architettura componenti (Astro)
- `Layout.astro` — shell, meta/SEO, font, base styles.
- `Nav.astro`, `Footer.astro`.
- `Hero.astro`, `MetricStrip.astro`, `About.astro`, `NowSection.astro`, `Contact.astro`.
- `WorkCard.astro` — card progetto (titolo, 1-liner, tag mono, link).
- `src/content/work/*.mdx` + `src/content/config.ts` (schema: title, slug, summary, stack[], repo?, demo?, order, draft).
- `src/pages/index.astro` (landing), `src/pages/work/[...slug].astro` (case study).
- `src/styles/` token Tailwind (palette, font).

Principio: componenti piccoli a responsabilita' singola, contenuto separato dalla presentazione (case study in content collection, non hardcoded).

## Deploy e config
- `.github/workflows/deploy.yml` con `withastro/action` + deploy su Pages. Branch di pubblicazione gestito da Actions (no `gh-pages` manuale).
- Pages settings: source = GitHub Actions.
- `astro.config.mjs`: `site` impostato, integrazioni tailwind + mdx + sitemap.
- Form: access key Web3Forms in variabile pubblica (e' una public key lato client, ok).

## Out of scope (YAGNI v1)
- Dark mode toggle.
- CMS / blog dinamico (i 52 tips restano su LinkedIn; eventuale "Writing" e' solo link esterni).
- Animazioni pesanti / vendor lib legacy (jQuery, owl.carousel, AOS, venobox).
- Dominio custom (resta `.github.io`; CNAME eventuale piu' avanti).
- i18n (solo EN).

## Open items
- Conferma accento terracotta `#B5482B` (vs teal alternativo).
- Foto hero: riuso headshot LinkedIn.
- Access key Web3Forms: da generare (account free).
- Testi finali dei 4 case study: bozza da contenuti vault, review di Federico.
