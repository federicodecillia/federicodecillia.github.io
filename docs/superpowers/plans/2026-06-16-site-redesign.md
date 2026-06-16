# Site redesign (Astro) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild federicodecillia.github.io from a legacy jQuery template into a modern Astro static site (warm-editorial design) with clickable case studies, auto-deployed to GitHub Pages.

**Architecture:** Astro + Tailwind, content-collection MDX for case studies, single-page landing + per-project pages, deployed via GitHub Actions to Pages (user-page, root URL, no basePath). Verification is `astro build` success + browser preview checks (no unit tests for a static marketing site).

**Tech Stack:** Astro, TypeScript, Tailwind CSS, MDX, Web3Forms, GitHub Actions.

Spec: `docs/superpowers/specs/2026-06-16-site-redesign-design.md`. Work on branch `redesign-astro`. The old template files (`index.html`, `inner-page.html`, `assets/`, `forms/`, `changelog.txt`) are removed in Task 9, not before, so the live site keeps working until merge.

---

### Task 1: Scaffold Astro project with integrations

**Files:**
- Create: `package.json`, `astro.config.mjs`, `tsconfig.json`, `src/pages/index.astro` (placeholder)
- Keep (for now): legacy files at repo root

- [ ] **Step 1: Scaffold Astro into a temp dir and move into repo root**

The repo root has legacy files, so scaffold in a subfolder then move the generated config up (avoid clobbering legacy until Task 9).

Run:
```bash
cd /Users/decilliaf/ai_projects/federicodecillia.github.io
npm create astro@latest _scaffold -- --template minimal --no-install --no-git --typescript strict
```

- [ ] **Step 2: Move scaffold files to root, keeping legacy intact**

```bash
cp _scaffold/astro.config.mjs _scaffold/tsconfig.json _scaffold/package.json .
cp -r _scaffold/src ./src-new && rm -rf _scaffold
mkdir -p src && cp -r src-new/* src/ 2>/dev/null; rm -rf src-new
```

- [ ] **Step 3: Add integrations**

Run:
```bash
npx astro add tailwind mdx sitemap --yes
npm install
```

- [ ] **Step 4: Configure `astro.config.mjs`**

```js
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import mdx from '@astrojs/mdx';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://federicodecillia.github.io',
  integrations: [tailwind(), mdx(), sitemap()],
});
```

- [ ] **Step 5: Verify dev server boots**

Start the dev server with the preview tooling (preview_start), then preview_snapshot the root URL. Expected: default Astro page renders, no console errors (preview_console_logs).

- [ ] **Step 6: Commit**

```bash
git add -A && git commit -m "chore: scaffold Astro + tailwind + mdx + sitemap"
```

---

### Task 2: Design tokens, fonts, base Layout, Nav, Footer

**Stack note:** Task 1 scaffolded Astro 6 + Tailwind v4 (via `@tailwindcss/vite`). There is NO `tailwind.config.js`. Tokens are defined CSS-natively with `@theme` in `src/styles/global.css`. Tailwind v4 auto-generates utilities from theme vars: `--color-clay` → `bg-clay`/`text-clay`/`border-clay`, `--font-serif` → `font-serif`. So all later components keep using `bg-clay`, `text-muted`, `border-line`, `font-serif` unchanged.

**Files:**
- Modify: `src/styles/global.css` (already created by `astro add`)
- Create: `src/layouts/Layout.astro`, `src/components/Nav.astro`, `src/components/Footer.astro`

- [ ] **Step 1: Define palette + fonts via `@theme` in `src/styles/global.css`**

Replace the file contents with:

```css
@import "tailwindcss";

@theme {
  --color-paper: #FBF8F2;
  --color-ink: #1F1D1A;
  --color-clay: #B5482B;
  --color-muted: #6B655C;
  --color-line: #E7E1D6;
  --font-serif: "Fraunces", Georgia, serif;
  --font-sans: "Inter", system-ui, sans-serif;
  --font-mono: "JetBrains Mono", ui-monospace, monospace;
}

:root { color-scheme: light; }
html { scroll-behavior: smooth; }
body { background: var(--color-paper); color: var(--color-ink); }
a { color: inherit; }
```

- [ ] **Step 2: Ensure `global.css` is imported once (in `Layout.astro`, Step 3 below).** No separate `@tailwind` directives needed in v4 — the single `@import "tailwindcss";` replaces them.

- [ ] **Step 3: Create `src/layouts/Layout.astro`**

Includes meta/SEO, Google Fonts (Fraunces, Inter, JetBrains Mono), global.css, Nav and Footer slots.

```astro
---
import '../styles/global.css';
import Nav from '../components/Nav.astro';
import Footer from '../components/Footer.astro';
const { title = 'Federico De Cillia', description = 'Enterprise AI leader and hands-on builder. LLMs, agents and automation from prototype to production.' } = Astro.props;
---
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title}</title>
    <meta name="description" content={description} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:type" content="website" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400;9..144,500&family=Inter:wght@400;500&family=JetBrains+Mono:wght@400&display=swap" rel="stylesheet" />
  </head>
  <body class="font-sans antialiased">
    <Nav />
    <main class="mx-auto max-w-3xl px-6">
      <slot />
    </main>
    <Footer />
  </body>
</html>
```

- [ ] **Step 4: Create `src/components/Nav.astro`**

```astro
<header class="mx-auto max-w-3xl px-6 py-6 flex items-center justify-between text-sm">
  <a href="/" class="font-medium">Federico De Cillia</a>
  <nav class="flex gap-5 text-muted">
    <a href="#work" class="hover:text-ink">Work</a>
    <a href="#about" class="hover:text-ink">About</a>
    <a href="#contact" class="text-clay">Contact</a>
  </nav>
</header>
```

- [ ] **Step 5: Create `src/components/Footer.astro`**

```astro
<footer class="mx-auto max-w-3xl px-6 py-12 mt-16 border-t border-line text-sm text-muted flex flex-wrap gap-4 justify-between">
  <span>Built with Astro + Claude Code</span>
  <span class="flex gap-4">
    <a href="https://www.linkedin.com/in/federicodecillia/" class="hover:text-ink">LinkedIn</a>
    <a href="https://github.com/federicodecillia" class="hover:text-ink">GitHub</a>
  </span>
</footer>
```

- [ ] **Step 6: Verify + commit**

preview reload, preview_snapshot (nav + footer render, fonts applied), preview_console_logs (clean). Then:
```bash
git add -A && git commit -m "feat: design tokens, layout, nav, footer"
```

---

### Task 3: Hero + MetricStrip

**Files:**
- Create: `src/components/Hero.astro`, `src/components/MetricStrip.astro`
- Modify: `src/pages/index.astro`

- [ ] **Step 1: Create `src/components/Hero.astro`**

```astro
<section class="pt-10 pb-12">
  <h1 class="font-serif text-5xl leading-tight">Federico De Cillia</h1>
  <p class="font-serif text-2xl text-clay mt-3">I build AI that ships.</p>
  <p class="text-muted text-lg leading-relaxed mt-5 max-w-xl">
    Twelve years turning models that demo well into systems that run in production. Enterprise AI across 18,000+ retail stores, plus an independent practice shipping LLM tools for businesses.
  </p>
  <div class="flex gap-4 mt-7 text-sm">
    <a href="#work" class="px-4 py-2 bg-clay text-paper rounded-md">View work</a>
    <a href="#contact" class="px-4 py-2 border border-line rounded-md hover:border-ink">Get in touch</a>
  </div>
</section>
```

- [ ] **Step 2: Create `src/components/MetricStrip.astro`**

```astro
<section class="grid grid-cols-3 gap-4 py-8 border-y border-line">
  {[['18,000+','retail stores'],['100+','AI deployments'],['12+ yrs','AI & data science']].map(([n,l]) => (
    <div>
      <div class="font-serif text-3xl">{n}</div>
      <div class="text-muted text-sm mt-1">{l}</div>
    </div>
  ))}
</section>
```

- [ ] **Step 3: Wire into `src/pages/index.astro`**

```astro
---
import Layout from '../layouts/Layout.astro';
import Hero from '../components/Hero.astro';
import MetricStrip from '../components/MetricStrip.astro';
---
<Layout>
  <Hero />
  <MetricStrip />
</Layout>
```

- [ ] **Step 4: Verify + commit**

preview reload, preview_snapshot (hero + metrics), preview_resize to mobile width to confirm the 3-col strip wraps acceptably. Fix responsive if needed (use `sm:grid-cols-3 grid-cols-1`). Then:
```bash
git add -A && git commit -m "feat: hero and metric strip"
```

---

### Task 4: About + Now sections

**Files:**
- Create: `src/components/About.astro`, `src/components/NowSection.astro`, `public/headshot.jpg`
- Modify: `src/pages/index.astro`

- [ ] **Step 1: Add headshot to `public/`**

Place Federico's headshot at `public/headshot.jpg` (reuse LinkedIn photo). Until provided, use a neutral placeholder of the same dimensions.

- [ ] **Step 2: Create `src/components/About.astro`**

```astro
<section id="about" class="py-12 scroll-mt-20">
  <h2 class="font-serif text-3xl mb-6">About</h2>
  <div class="flex gap-6 items-start">
    <img src="/headshot.jpg" alt="Federico De Cillia" width="96" height="96" class="rounded-lg border border-line" />
    <div class="text-muted leading-relaxed space-y-4">
      <p>As a data science lead at a global eyewear company, I lead a team building AI across 18,000+ retail stores: forecasting, optimization, and most recently LLM-powered and agentic systems that give business teams natural-language access to enterprise data. My bar is the one that matters in the real world: beyond proof-of-concept, into production, with measurable ROI.</p>
      <p>Outside the day job I run an independent AI practice: training teams to use AI well, and shipping chatbots, automations and internal tools into production. My daily driver is Claude, but I reach for whatever tool best solves the problem.</p>
      <p>What drives me is the intersection of powerful technology, real human adoption, and tangible impact. I'm not interested in AI for its own sake. I'm interested in what it changes.</p>
    </div>
  </div>
</section>
```

- [ ] **Step 3: Create `src/components/NowSection.astro`**

```astro
<section class="py-8 border-t border-line">
  <h2 class="font-serif text-2xl mb-3">Now</h2>
  <p class="text-muted leading-relaxed max-w-xl">Living at the frontier: new model releases, agentic workflows, the latest research. If it shipped this week, I've probably already tested it. Currently building with agents, MCP, and Claude Code.</p>
</section>
```

- [ ] **Step 4: Wire into index, verify, commit**

Add `<About />` and `<NowSection />` to index after MetricStrip. preview reload + snapshot. Then:
```bash
git add -A && git commit -m "feat: about and now sections"
```

---

### Task 5: Work content collection + WorkCard + Selected work grid

**Files:**
- Create: `src/content/config.ts`, `src/content/work/ariel.mdx`, `src/content/work/ai-enablement.mdx`, `src/content/work/ai-second-brain.mdx`, `src/content/work/wegrocery.mdx`, `src/components/WorkCard.astro`, `src/components/SelectedWork.astro`
- Modify: `src/pages/index.astro`

- [ ] **Step 1: Define the collection schema `src/content/config.ts`**

```ts
import { defineCollection, z } from 'astro:content';

const work = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    summary: z.string(),
    stack: z.array(z.string()).default([]),
    repo: z.string().url().optional(),
    demo: z.string().url().optional(),
    order: z.number().default(99),
    draft: z.boolean().default(false),
  }),
});

export const collections = { work };
```

- [ ] **Step 2: Create the 4 MDX case studies**

Each file frontmatter + body. Example `src/content/work/ai-second-brain.mdx`:

```mdx
---
title: ai-second-brain
summary: An open-source, self-rewriting Obsidian second brain operated by Claude.
stack: ["claude", "mcp", "skills", "obsidian"]
repo: https://github.com/federicodecillia/ai-second-brain
order: 3
---

## Problem
Knowledge bases rot: notes are written once and never reconciled.

## Approach
A vault where Claude reads, rewrites and links notes, with scheduled maintenance agents.

## Impact
Published as a public lead magnet; used daily as a personal CRM and knowledge system.

Built with Claude Code.
```

Create `ariel.mdx` (order 1, EL numbers anonymized, no client name, stack: databricks/llm/genie, no repo), `ai-enablement.mdx` (order 2, generic AI training + internal events, no repo), `wegrocery.mdx` (order 4, repo + demo https://wegrocery-demo.vercel.app, stack: next.js/postgres/vercel). Keep each to Problem/Approach/Impact + "Built with Claude Code."

- [ ] **Step 3: Create `src/components/WorkCard.astro`**

```astro
---
const { title, summary, stack, slug } = Astro.props;
---
<a href={`/work/${slug}`} class="block border border-line rounded-lg p-5 hover:border-ink transition-colors">
  <h3 class="font-medium text-lg">{title}</h3>
  <p class="text-muted text-sm mt-1 leading-relaxed">{summary}</p>
  <div class="flex flex-wrap gap-2 mt-3">
    {stack.map((t) => <span class="font-mono text-xs text-muted border border-line rounded px-2 py-0.5">{t}</span>)}
  </div>
</a>
```

- [ ] **Step 4: Create `src/components/SelectedWork.astro`**

```astro
---
import { getCollection } from 'astro:content';
import WorkCard from './WorkCard.astro';
const items = (await getCollection('work', ({ data }) => !data.draft)).sort((a,b) => a.data.order - b.data.order);
---
<section id="work" class="py-12 scroll-mt-20">
  <h2 class="font-serif text-3xl mb-6">Selected work</h2>
  <div class="grid sm:grid-cols-2 gap-4">
    {items.map((item) => <WorkCard title={item.data.title} summary={item.data.summary} stack={item.data.stack} slug={item.slug} />)}
  </div>
</section>
```

- [ ] **Step 5: Wire `<SelectedWork />` into index (before About), verify, commit**

preview reload + snapshot (4 cards, tags render). Then:
```bash
git add -A && git commit -m "feat: work collection, cards, selected work grid"
```

---

### Task 6: Case study pages `/work/[slug]`

**Files:**
- Create: `src/pages/work/[...slug].astro`

- [ ] **Step 1: Create the dynamic route**

```astro
---
import { getCollection } from 'astro:content';
import Layout from '../../layouts/Layout.astro';

export async function getStaticPaths() {
  const items = await getCollection('work', ({ data }) => !data.draft);
  return items.map((item) => ({ params: { slug: item.slug }, props: { item } }));
}
const { item } = Astro.props;
const { Content } = await item.render();
---
<Layout title={`${item.data.title} — Federico De Cillia`} description={item.data.summary}>
  <article class="py-10 prose-custom">
    <a href="/#work" class="text-sm text-clay">← Back to work</a>
    <h1 class="font-serif text-4xl mt-4">{item.data.title}</h1>
    <p class="text-muted mt-2">{item.data.summary}</p>
    <div class="flex flex-wrap gap-2 mt-3">
      {item.data.stack.map((t) => <span class="font-mono text-xs text-muted border border-line rounded px-2 py-0.5">{t}</span>)}
    </div>
    <div class="flex gap-4 mt-4 text-sm">
      {item.data.repo && <a href={item.data.repo} class="text-clay">Repo ↗</a>}
      {item.data.demo && <a href={item.data.demo} class="text-clay">Live demo ↗</a>}
    </div>
    <div class="mt-8 leading-relaxed space-y-4 [&_h2]:font-serif [&_h2]:text-2xl [&_h2]:mt-8 [&_h2]:mb-2 [&_p]:text-muted">
      <Content />
    </div>
  </article>
</Layout>
```

- [ ] **Step 2: Verify each case study renders**

preview navigate to `/work/ai-second-brain`, `/work/wegrocery`, etc. preview_snapshot each: title, tags, repo/demo links, MDX body. preview_console_logs clean.

- [ ] **Step 3: Commit**

```bash
git add -A && git commit -m "feat: case study pages"
```

---

### Task 7: Contact section (Web3Forms)

**Files:**
- Create: `src/components/Contact.astro`
- Modify: `src/pages/index.astro`

- [ ] **Step 1: Create `src/components/Contact.astro`**

Web3Forms posts to their endpoint with a public `access_key`. Replace `WEB3FORMS_KEY` with the real key from Federico's free account.

```astro
<section id="contact" class="py-12 scroll-mt-20 border-t border-line">
  <h2 class="font-serif text-3xl mb-6">Get in touch</h2>
  <form action="https://api.web3forms.com/submit" method="POST" class="grid gap-3 max-w-lg">
    <input type="hidden" name="access_key" value="WEB3FORMS_KEY" />
    <input type="text" name="name" placeholder="Name" required class="border border-line rounded-md px-3 py-2 bg-white" />
    <input type="email" name="email" placeholder="Email" required class="border border-line rounded-md px-3 py-2 bg-white" />
    <textarea name="message" placeholder="Message" required rows="4" class="border border-line rounded-md px-3 py-2 bg-white"></textarea>
    <button type="submit" class="px-4 py-2 bg-clay text-paper rounded-md justify-self-start">Send</button>
  </form>
  <p class="text-muted text-sm mt-4">Or reach me on <a href="https://www.linkedin.com/in/federicodecillia/" class="text-clay">LinkedIn</a>.</p>
</section>
```

- [ ] **Step 2: Wire into index (last section), verify, commit**

preview reload + snapshot (form renders, inputs styled). Do not submit during preview. Then:
```bash
git add -A && git commit -m "feat: contact section with Web3Forms"
```

---

### Task 8: SEO, favicon, OG image

**Files:**
- Create: `public/favicon.svg`, `public/og.png`, `public/robots.txt`
- Modify: `src/layouts/Layout.astro`

- [ ] **Step 1: Add favicon + og + robots**

Add a simple `favicon.svg` (initials FD on clay), an `og.png` (1200x630 with name + tagline), and `robots.txt` allowing all + sitemap line `Sitemap: https://federicodecillia.github.io/sitemap-index.xml`.

- [ ] **Step 2: Reference favicon + og:image in Layout head**

```astro
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<meta property="og:image" content="https://federicodecillia.github.io/og.png" />
<meta name="twitter:card" content="summary_large_image" />
```

- [ ] **Step 3: Verify build + commit**

Run `npm run build`; expected: success, `dist/` produced, sitemap generated. Then:
```bash
git add -A && git commit -m "feat: seo, favicon, og image"
```

---

### Task 9: Remove legacy template + GitHub Actions deploy

**Files:**
- Delete: `index.html`, `inner-page.html`, `assets/`, `forms/`, `changelog.txt`
- Create: `.github/workflows/deploy.yml`, `Readme.MD` (rewrite)

- [ ] **Step 1: Remove legacy files**

```bash
cd /Users/decilliaf/ai_projects/federicodecillia.github.io
git rm -r index.html inner-page.html assets forms changelog.txt
```

- [ ] **Step 2: Create `.github/workflows/deploy.yml`**

```yaml
name: Deploy to GitHub Pages
on:
  push:
    branches: [main]
  workflow_dispatch:
permissions:
  contents: read
  pages: write
  id-token: write
concurrency:
  group: pages
  cancel-in-progress: true
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: withastro/action@v3
  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

- [ ] **Step 3: Rewrite `Readme.MD`**

Short README: what the site is, stack (Astro + Tailwind), "built with Claude Code", local dev commands (`npm install`, `npm run dev`, `npm run build`), deploy note (auto via Actions on push to main).

- [ ] **Step 4: Commit**

```bash
git add -A && git commit -m "chore: remove legacy template, add Pages deploy workflow"
```

---

### Task 10: Final build verification + merge + deploy

- [ ] **Step 1: Clean build**

```bash
rm -rf dist node_modules/.vite && npm run build
```
Expected: success, no errors, `dist/index.html` + `dist/work/<slug>/index.html` + sitemap present.

- [ ] **Step 2: Full preview pass**

preview_start on the built/dev site. Walk every section (hero, metrics, work, about, now, contact) and every case-study page. preview_console_logs and preview_network clean. preview_resize mobile to confirm responsive. preview_screenshot for the user.

- [ ] **Step 3: Confirm Pages settings**

Tell Federico to set GitHub repo Settings → Pages → Source = "GitHub Actions" (one-time, manual). The Web3Forms key (Task 7) and headshot (Task 4) must be real before merge.

- [ ] **Step 4: Merge to main (with Federico's confirmation)**

Do not merge/push without explicit confirmation. On confirm:
```bash
git checkout main && git merge --no-ff redesign-astro && git push origin main
```
Then watch the Actions run deploy; verify the live site at https://federicodecillia.github.io.

---

## Notes for the executor
- No unit-test framework: verification is `astro build` success + browser preview checks. Do not invent pytest-style tests.
- Keep components small and focused (one section each). Content lives in the `work` collection, never hardcoded in pages.
- Placeholders that MUST be replaced before deploy: `WEB3FORMS_KEY` (Task 7), `public/headshot.jpg` (Task 4), case-study copy review (Task 5).
- Numbers must match LinkedIn/CV exactly (one version of each figure). Keep EL client unnamed and numbers anonymized; no "gptchatbot.it" brand.
