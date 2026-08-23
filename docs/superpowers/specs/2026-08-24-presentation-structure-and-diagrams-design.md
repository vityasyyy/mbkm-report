# Presentation Structure and Diagrams Design

## Goal

Restructure and polish the MBKM Beamer presentation so that it follows the
approved academic presentation rhythm demonstrated by
`~/Downloads/MBKM_FAHMI.pdf`, while using the GL architecture documentation as
the source of truth for technical content. The finished deck must be readable
when presented, compile reproducibly, and contain diagrams whose nodes retain
their text after standalone generation and inclusion in Beamer.

## Source of Truth

- `~/Downloads/MBKM_FAHMI.pdf` is a structure and pacing reference only. It
  informs the order of introductory slides, course title cards, syllabus
  slides, evidence/result slides, conclusion, and closing slide.
- `~/GL/ARCHITECTURE_vityasy.md` is the technical source of truth. Product
  families, component names, system relationships, data flows, GL-IAM
  providers, deployment details, testing details, and contribution framing
  must be derived from that document.
- The current repository remains authoritative for the presenter identity,
  company metadata, course codes, SKS values, dates, theme assets, and the
  existing build pipeline.

Claims that cannot be supported by these sources will be removed or phrased
conservatively rather than invented.

## Presentation Flow

The deck will use the following sequence:

1. Title
2. Gambaran Umum Program
3. Profil Perusahaan
4. Program Magang section divider
5. Daftar Mata Kuliah MBKM
6. Hasil Magang overview
7. Project/product landscape
8. MII21-3011: Pengembangan Fitur dan Modul Proyek
   - course title card
   - syllabus
   - problem and solution: Weekly Report and Issue Reoccurrence
   - focused architecture or escalation-flow evidence
9. MII21-3013: Implementasi Prototipe Produk
   - course title card
   - syllabus
   - prototype overview: Pamela/Project Manager and E2B analytics
   - focused implementation/result evidence
10. MII21-3014: Pengembangan Backend
    - course title card
    - syllabus
    - GL-IAM SDK and GL Connectors backend contribution
    - SIMI architecture and atomicity evidence
11. MII21-3015: Pengujian Unit dan Modul Proyek
    - course title card
    - syllabus
    - test strategy and security/regression evidence
12. MII21-3016: Pengujian Integrasi dan Sistem
    - course title card
    - syllabus
    - end-to-end, deployment, and environment-driven integration evidence
13. MII21-4012: Soft Skill: Kemampuan Bekerjasama dan Kolaborasi
    - course title card
    - syllabus
    - collaboration, review, and problem-solving practices grounded in the
      documented work
14. Kesimpulan
15. Terima Kasih

The exact number of evidence slides may be adjusted during implementation if a
slide is redundant or if a diagram needs its own readable view. The six-course
mapping and required syllabus coverage will remain intact.

## Content Treatment

Content slides will be rewritten around one message each rather than being
transformed into prose-heavy report pages.

- Use short, concrete bullets and preserve important technical identifiers in
  monospace where useful.
- Prefer `problem -> contribution -> result` and `challenge -> response ->
  learning` narratives over unstructured lists.
- Keep technical terms from the GL reference, including AIP runtime, GL
  Connectors SDK, Weekly Report, Issue Reoccurrence, Pamela, PM Datasaur,
  GL-IAM, SIMI, PostgreSQL, Keycloak, StackAuth, E2B, and Playwright.
- Merge or remove the current duplicate E2B and testing diagram slides when
  their captions repeat the same message.
- Keep code examples only where they explain a distinctive contribution, such
  as E2B execution/cleanup or atomic user creation. Code must be short enough
  to read on a projected slide.

## Diagram Design

Diagrams will be regenerated from standalone TikZ sources under
`presentation/diagrams/tikz/` and copied to `presentation/diagrams/` by the
existing script.

Priority diagrams:

- product landscape linking Weekly Report, Issue Reoccurrence, Pamela, PM
  Datasaur, GL-IAM, and the cookbook;
- Weekly Report component architecture;
- Issue Reoccurrence five-step escalation flow;
- Pamela and GL Connectors integration;
- GL-IAM SIMI architecture;
- atomic `create_user_with_password` flow;
- agent delegation/authentication flow;
- deployment and testing overview;
- DE-WR/DE-WRI shared data dependency.

Diagram rules:

- Each node contains its own complete, visible label; no meaning depends on a
  group label alone.
- One diagram communicates one architecture or flow. Dense GL reference
  diagrams will be split or simplified rather than scaled until unreadable.
- Arrows have a consistent direction and avoid crossings where possible.
- Group boundaries identify meaningful layers such as runtime, protocol,
  provider, external service, or data layer.
- Use the established UGM-compatible palette: blue for applications/runtime and
  consumers, green for internal orchestration/interfaces, and red for
  providers, external systems, or data stores.
- Long labels use controlled text widths and line breaks. Font size and node
  dimensions are chosen for the final projected slide, not only the standalone
  PDF.
- Standalone PDFs must embed visible text and must remain readable when
  included at the diagram slide width.

## Layout and Typography

- Retain the existing UGM theme and 16:9 aspect ratio.
- Normalize frame-title placement and vertical spacing so titles do not collide
  with content or the footer.
- Use generous margins and whitespace modeled on the reference deck.
- Use a single clear title per frame, with two-column layouts only for a real
  comparison such as problem/solution or challenge/result.
- Add small reusable LaTeX helpers for course title cards, section headings,
  comparison layouts, and diagram frames.
- Normalize Indonesian capitalization, punctuation, dates, course labels, and
  code formatting.
- Ensure the footer and UGM logo remain visually separate from all content.

## Verification

The implementation is accepted only when all of the following are true:

1. Every TikZ source compiles through `presentation/build-diagrams.sh`.
2. The complete presentation compiles with `latexmk -xelatex` using the
   repository configuration.
3. Logs contain no LaTeX errors, missing graphics, missing references, or
   overfull/underfull box warnings caused by the new presentation.
4. Extracted text from representative diagram PDFs contains their node labels,
   and rendered pages visibly show those labels rather than blank boxes.
5. Representative rendered pages are inspected for the title, overview,
   course card, text-heavy content, diagram, code, and closing slide.
6. Git diff contains only related presentation/specification changes; the
   existing unrelated `report/matkul_checklist.pdf` remains untouched.
7. GitHub Actions is green after pushing. Any CI failure is diagnosed and fixed
   locally before another push.

## Risks and Mitigations

- **Diagram labels disappear or become unreadable:** compile standalone PDFs,
  extract their text, and inspect the included slide render before delivery.
- **Technical claims drift from GL:** review every architecture label and
  relationship against `ARCHITECTURE_vityasy.md` during content editing.
- **Over-trimming removes academic coverage:** keep the six course cards and
  each course's syllabus/evidence path even when merging duplicate technical
  slides.
- **Theme changes cause layout regressions:** keep theme changes local and
  validate both ordinary and fragile/code frames.
- **Push or CI introduces unrelated failures:** inspect status and diff before
  committing, stage only presentation-related files, and wait for the required
  checks after pushing.
