# Presentation Structure and Diagrams Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the MBKM Beamer deck around the approved academic presentation structure, use the GL architecture document as technical truth, and deliver readable diagrams with green local and GitHub CI verification.

**Architecture:** Keep the current UGM Beamer theme and standalone TikZ build pipeline. Centralize diagram styling in a nested style file so the build script continues compiling only diagram entrypoints, then rewrite `contents/slides.tex` into a concise course-oriented narrative with dedicated diagram/code/result frames.

**Tech Stack:** XeLaTeX, Beamer, TikZ, `latexmk`, `pdflatex` for standalone diagrams, GitHub Actions, Makefile/Docker build targets.

## Global Constraints

- `~/Downloads/MBKM_FAHMI.pdf` is a structure and pacing reference only.
- `~/GL/ARCHITECTURE_vityasy.md` is the technical source of truth.
- The current repository is authoritative for presenter identity, company metadata, course codes, SKS values, dates, theme assets, and the build pipeline.
- Retain the existing UGM theme and 16:9 aspect ratio.
- Each node contains its own complete, visible label.
- Keep the six-course mapping and required syllabus coverage intact.
- Do not modify the unrelated untracked `report/matkul_checklist.pdf`.
- Do not introduce new LaTeX dependencies unless the existing TeX installation already provides them.
- Push to the configured GitHub remote only after local verification and diff review; wait for required CI checks.

---

### Task 1: Centralize Diagram Styling and Rebuild Diagram Entry Points

**Files:**
- Create: `presentation/diagrams/tikz/style/diagram-style.tex`
- Modify: `presentation/diagrams/tikz/00_high_level_arch.tex`
- Modify: `presentation/diagrams/tikz/01_gl_iam_high_level.tex`
- Modify: `presentation/diagrams/tikz/02_dewri.tex`
- Modify: `presentation/diagrams/tikz/03_dewr.tex`
- Modify: `presentation/diagrams/tikz/04_e2b_analytics.tex`
- Modify: `presentation/diagrams/tikz/05_gl_iam_atomicity.tex`
- Modify: `presentation/diagrams/tikz/05b_gl_iam_agent_auth.tex`
- Modify: `presentation/diagrams/tikz/06_deployment.tex`
- Modify: `presentation/diagrams/tikz/07_testing.tex`
- Modify: `presentation/diagrams/tikz/11_dewr_dewri_data_dependency.tex`
- Generated: matching PDFs under `presentation/diagrams/` and `presentation/diagrams/tikz/`

**Interfaces:**
- Consumes: GL architecture names and relationships from `~/GL/ARCHITECTURE_vityasy.md`.
- Produces: standalone diagram PDFs with embedded, extractable node labels for use by `\diagramslide`.

- [ ] **Step 1: Add the shared TikZ style file**

Define UGM-compatible colors and reusable `appbox`, `processbox`, `externalbox`, `groupbox`, `arrow`, and `grouplabel` styles. Use explicit `text width`, `align=center`, `inner sep`, and a projected-slide-safe font size in the node styles. Keep the file free of `\begin{document}` so it is included by diagram entrypoints but is not itself an entrypoint.

```tex
\definecolor{ugmblue}{HTML}{194168}
\definecolor{ugmyellow}{HTML}{F6D648}
\definecolor{diagramgreen}{RGB}{76,175,80}
\definecolor{diagramred}{RGB}{198,83,83}
\tikzset{
  appbox/.style={rectangle, rounded corners=3pt, draw=ugmblue,
    fill=ugmblue!8, text width=3.0cm, minimum height=0.78cm,
    align=center, inner sep=4pt, font=\sffamily\small},
  processbox/.style={rectangle, rounded corners=3pt, draw=diagramgreen,
    fill=diagramgreen!10, text width=3.0cm, minimum height=0.78cm,
    align=center, inner sep=4pt, font=\sffamily\small},
  externalbox/.style={rectangle, rounded corners=3pt, draw=diagramred,
    fill=diagramred!10, text width=3.0cm, minimum height=0.78cm,
    align=center, inner sep=4pt, font=\sffamily\small},
  groupbox/.style={rectangle, rounded corners=5pt, draw=#1,
    fill=#1!5, inner sep=8pt, line width=1.1pt},
  arrow/.style={-{Latex[length=2mm]}, draw=gray!75, line width=0.9pt},
  grouplabel/.style={font=\sffamily\bfseries\small}
}
```

- [ ] **Step 2: Convert each entrypoint to the shared style**

Replace duplicated color/style blocks with `\input{style/diagram-style}`. Keep each file as a standalone `tikz` document and use the shared node styles. Ensure every displayed component has an explicit label, including group contents currently represented only by a group caption.

- `00_high_level_arch.tex`: show external services, AIP runtime, shared SDKs, and four Digital Employee products, with arrows from runtime to products and SDKs.
- `01_gl_iam_high_level.tex`: show consumers, `IAMGateway`, protocol interfaces, and PostgreSQL/Keycloak/StackAuth providers.
- `02_dewri.tex`: show the coordinator, the five escalation steps in order, and PostgreSQL/GitHub/email side effects.
- `03_dewr.tex`: show ingestion, Q&A, compliance, email, E2B processing, Google Drive, and PostgreSQL as distinct labeled nodes.
- `04_e2b_analytics.tex`: show Meemo input, analytics agent, E2B sandbox execution, PDF output, and email/Drive delivery.
- `05_gl_iam_atomicity.tex`: show caller, gateway delegation, PostgreSQL provider transaction, four writes, single commit, and rollback outcome.
- `05b_gl_iam_agent_auth.tex`: show human session, delegated token issuance, AI agent validation, scope authorization, and revoked/expired denial.
- `06_deployment.tex`: show PR, GitHub Actions, Helm, dev/prod environments, CronJob, and validation/log output.
- `07_testing.tex`: show unit, integration, security, Playwright E2E, and env-driven consolidation as separate paths.
- `11_dewr_dewri_data_dependency.tex`: show DE-WR writers, shared PostgreSQL tables, and DE-WRI reader/escalation path.

- [ ] **Step 3: Build all standalone diagrams**

Run:

```bash
cd presentation
./build-diagrams.sh
```

Expected: every entrypoint prints `building diagram: ...`, exits with status 0, and regenerates the PDFs without trying to compile `style/diagram-style.tex`.

- [ ] **Step 4: Verify diagram text and page geometry**

Run:

```bash
for pdf in presentation/diagrams/*.pdf; do pdftotext "$pdf" -; done
pdfinfo presentation/diagrams/01_gl_iam_high_level.pdf
```

Expected: extracted text includes labels such as `IAMGateway`, `AuthenticationProvider`, `PostgreSQL`, `Keycloak`, and `StackAuth`; every PDF reports one page with a non-zero page size.

- [ ] **Step 5: Commit the diagram batch**

```bash
git add presentation/diagrams/tikz presentation/diagrams
git commit -m "fix(presentation): rebuild diagrams with readable labels"
```

### Task 2: Rewrite Shared Beamer Layout Helpers

**Files:**
- Modify: `presentation/contents/slides.tex`
- Modify: `presentation/themes/ugm1/beamerinnerthemeugm1.sty` only if the local frame-title override cannot be corrected in the deck

**Interfaces:**
- Consumes: generated PDFs from Task 1 and existing UGM theme commands.
- Produces: stable `\courseframe`, `\contentframe`, `\comparisonframe`, `\codeframe`, and `\diagramslide` helpers used by the rewritten deck.

- [ ] **Step 1: Replace conflicting frame-title overrides**

Keep one authoritative frame-title template. Remove the duplicate vertical compensation between the theme’s `\setbeamertemplate{frametitle}`/`\addtobeamertemplate` and the deck-local override, then set a fixed title area with predictable content start and footer clearance. Do not change the title-page or section-page background assets.

- [ ] **Step 2: Add concise reusable frame helpers**

Define helpers in `slides.tex` for course cards, diagram frames, and two-column content. The diagram helper must cap both width and height while preserving aspect ratio; content helpers must not force text into `\scriptsize` unless the code or a deliberately dense syllabus requires it.

```tex
\newcommand{\courseframe}[3]{%
  {\usebackgroundtemplate{\backgroundcontent}\begin{frame}[plain]
    \vfill
    \begin{center}
      {\usebeamerfont{section title}\color{ugmblue}#1\par}
      \vspace{0.5cm}
      \large\textbf{Kode}: #2 \hspace{1cm} \textbf{SKS}: #3
    \end{center}
    \vfill
  \end{frame}}
}
\newcommand{\diagramslide}[2][0.62\textheight]{%
  \begin{center}
    \includegraphics[width=0.94\textwidth,height=#1,keepaspectratio]{#2}
  \end{center}
}
```

- [ ] **Step 3: Normalize text defaults**

Set consistent list spacing, paragraph spacing, column separation, code font, and caption/note treatment. Use one short `\smallnote` below diagrams only when it adds interpretation rather than repeating the diagram labels.

- [ ] **Step 4: Compile the layout helpers against the current deck**

Run:

```bash
make presentation
```

Expected: the current deck compiles with the new helpers before the content rewrite begins. If a helper change produces a frame-title collision or missing command, fix it before proceeding.

### Task 3: Rewrite the Presentation Content and Structure

**Files:**
- Modify: `presentation/contents/slides.tex`

**Interfaces:**
- Consumes: repository metadata, six-course mapping, Task 1 diagrams, and technical facts from `~/GL/ARCHITECTURE_vityasy.md`.
- Produces: a complete presentation with the approved sequence and no duplicate technical slides.

- [ ] **Step 1: Rebuild the front matter**

Keep the existing identity and dates. Use the reference rhythm for title, `Gambaran Umum Program`, `Profil Perusahaan`, `Program Magang`, `Daftar Mata Kuliah MBKM`, `Hasil Magang`, and a concise product landscape. Add the documented three product families and GL-IAM/cookbook relationship rather than generic product prose.

- [ ] **Step 2: Rebuild the MII21-3011 section**

Use a course card and syllabus frame, then present:

- the operational problem: weekly reports, recurring issues, and missing escalation visibility;
- the contribution: Weekly Report ingestion plus Issue Reoccurrence escalation/synchronization;
- the five-step escalation diagram and a short result statement.

Use `00_high_level_arch.pdf`, `01` only where identity is relevant, and `02_dewri.pdf`/`11_dewr_dewri_data_dependency.pdf` for the focused evidence. Remove captions that claim unsupported implementation details.

- [ ] **Step 3: Rebuild the MII21-3013 section**

Use a course card and syllabus frame, then present the Pamela/Project Manager and PM Datasaur context, GL Connectors migration, E2B analytics prototype, and one concise implementation/code/result frame. Keep only a short code sample that demonstrates sandbox execution, explicit timeout, or resource cleanup.

- [ ] **Step 4: Rebuild the MII21-3014 section**

Use a course card and syllabus frame, then present GL-IAM SDK/cookbook as the backend contribution, SIMI provider switching, atomic `create_user_with_password`, agent authentication, and deployment. Use `01_gl_iam_high_level.pdf`, `05_gl_iam_atomicity.pdf`, `05b_gl_iam_agent_auth.pdf`, and `06_deployment.pdf` as separate focused diagrams.

- [ ] **Step 5: Rebuild the MII21-3015 section**

Use a course card and syllabus frame, then present the testing strategy: unit coverage around `FetchEmployeeIssuesTool`, SQL-injection validation, real database integration coverage, and regression cases. Use one `07_testing.pdf` slide and avoid duplicating it in the next course section.

- [ ] **Step 6: Rebuild the MII21-3016 section**

Use a course card and syllabus frame, then present Playwright E2E flows, deployment validation, CronJob/log checks, and env-driven integration-test consolidation. Reuse the testing diagram only if the caption explains a distinct integration-system message; otherwise use a concise text/result slide.

- [ ] **Step 7: Rebuild the MII21-4012 section**

Use a course card and syllabus frame, then present collaboration through PR review, GitHub Projects, mentor feedback, documentation, systematic debugging, and the human-review boundary for AI-assisted work. Use challenge/response/result wording and avoid unsupported claims about team processes.

- [ ] **Step 8: Rebuild conclusion and closing**

Summarize the three GL product families, GL-IAM/backend contribution, testing/deployment discipline, and learning outcomes in four or fewer bullets. Keep the theme’s `\quoteslide` closing frame.

- [ ] **Step 9: Compile after the content rewrite**

Run:

```bash
make presentation
```

Expected: the full deck compiles to `presentation/build/main.pdf` with no LaTeX errors and no missing graphics.

- [ ] **Step 10: Commit the deck rewrite**

```bash
git add presentation/contents/slides.tex presentation/themes/ugm1
git commit -m "refactor(presentation): align deck with MBKM structure"
```

### Task 4: Rendered-Output and Log Verification

**Files:**
- Inspect: `presentation/build/main.log`
- Inspect: `presentation/build/main.pdf`
- Inspect: generated PDFs under `presentation/diagrams/`

**Interfaces:**
- Consumes: completed deck and diagrams from Tasks 1-3.
- Produces: evidence that labels, layouts, and structural pages survive PDF inclusion.

- [ ] **Step 1: Scan the presentation log**

Run:

```bash
grep -E "(^!|LaTeX Error|Package .* Error|Missing character|undefined references|Overfull|Underfull|not found)" presentation/build/main.log
```

Expected: no output for errors, missing references, missing graphics, or new overfull/underfull boxes.

- [ ] **Step 2: Confirm slide count and required text**

Run:

```bash
pdfinfo presentation/build/main.pdf
pdftotext -layout presentation/build/main.pdf -
```

Expected: the PDF contains the six course codes, `Hasil Magang`, `GL-IAM`, `Issue Reoccurrence`, `Pamela` or `Project Manager`, `Kesimpulan`, and `Terima Kasih`.

- [ ] **Step 3: Render representative pages**

Create review images outside the repository:

```bash
mkdir -p /var/folders/nk/spb82z6d59g6fd9sl18zz_9r0000gn/T/opencode/mbkm-review
pdftoppm -f 1 -l 1 -png -r 120 presentation/build/main.pdf /var/folders/nk/spb82z6d59g6fd9sl18zz_9r0000gn/T/opencode/mbkm-review/title
pdftoppm -f 7 -l 7 -png -r 120 presentation/build/main.pdf /var/folders/nk/spb82z6d59g6fd9sl18zz_9r0000gn/T/opencode/mbkm-review/course
pdftoppm -f 10 -l 10 -png -r 120 presentation/build/main.pdf /var/folders/nk/spb82z6d59g6fd9sl18zz_9r0000gn/T/opencode/mbkm-review/diagram
```

Inspect the images and verify title placement, footer separation, readable node labels, no clipped content, and no blank diagram boxes. Use the actual page numbers reported by `pdfinfo`/`pdftotext` if the final slide sequence shifts.

- [ ] **Step 4: Run the Docker-equivalent local target when available**

Run:

```bash
make presentation-docker
```

Expected: the same diagram and presentation build succeeds in the CI container. If Docker is unavailable, record that limitation and still run the local TeX checks.

### Task 5: Final Diff Review, Push, and CI Gate

**Files:**
- Inspect: all tracked changes from Tasks 1-4
- Preserve untouched: `report/matkul_checklist.pdf`

- [ ] **Step 1: Review repository state and commits**

Run:

```bash
git status --short --branch
```

Expected: only the design/plan commits and presentation changes are present; the unrelated report PDF is still untracked and unstaged.

- [ ] **Step 2: Run the final local presentation target**

```bash
make presentation
```

Expected: exit status 0, all diagrams rebuilt, and `presentation/build/main.pdf` exists.

- [ ] **Step 3: Push to GitHub**

```bash
git push origin main
```

Expected: the push succeeds and GitHub Actions starts the presentation/report workflow.

- [ ] **Step 4: Wait for and inspect CI**

Use the repository’s GitHub workflow status to inspect all required checks. Do not declare completion while a required check is pending, failed, or unknown.

- [ ] **Step 5: Fix any CI failure and repeat the gate**

For a failure, reproduce the failing command locally, apply the smallest fix, rerun `make presentation`, inspect the diff, commit with a Conventional Commit message, push, and wait for CI again.
