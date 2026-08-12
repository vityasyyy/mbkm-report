# Laporan Magang MBKM: Software Engineering di GDP Labs

> Laporan magang mandiri Merdeka Belajar Kampus Merdeka (MBKM) Muhammad Argya Vityasy (23/522547/PA/22475) di PT Sumber Cipta Multiniaga (GDP Labs) sebagai Software Engineer Intern pada platform Digital Employee, periode 9 Februari 2026 sampai 22 Juni 2026.

Repository ini berisi source LaTeX untuk **laporan magang** dan **presentasi sidang** yang dikompilasi otomatis oleh GitHub Actions. Setiap push ke `main` menghasilkan PDF yang bisa diunduh langsung dari halaman [Releases](https://github.com/vityasyyy/mbkm-report/releases).

---

## Quick Start

### Prerequisites

**Opsi A: Kompilasi Lokal (membutuhkan texlive)**
- macOS: `brew install --cask mactex`
- Linux: `sudo apt-get install texlive-full`
- Windows: [MiKTeX](https://miktex.org/) atau [TeX Live](https://tug.org/texlive/)

**Opsi B: Docker (tanpa texlive)**
- [Docker Desktop](https://www.docker.com/products/docker-desktop)

### Kompilasi

```bash
# Lokal
make report          # Kompilasi laporan (report/main.tex)
make presentation    # Kompilasi presentasi (presentation/main.tex, xelatex)
make all             # Kompilasi keduanya
make clean           # Bersihkan file build

# Docker (tidak perlu texlive)
make report-docker
make presentation-docker
make all-docker
```

### Manual (tanpa Makefile)

```bash
cd report
pdflatex main.tex && pdflatex main.tex

cd presentation
latexmk -xelatex main.tex
```

---

## Repository Structure

```
mbkm-report/
├── report/
│   ├── main.tex               # Metadata & struktur laporan
│   ├── sections/              # BAB 1-11
│   │   ├── bab1_pendahuluan.tex
│   │   ├── bab2_transkrip.tex
│   │   ├── bab3_fitur_modul.tex
│   │   ├── bab4_prototipe.tex
│   │   ├── bab5_backend.tex
│   │   ├── bab6_unit_test.tex
│   │   ├── bab7_integrasi.tex
│   │   ├── bab8_softskill.tex
│   │   ├── bab9_kesimpulan.tex
│   │   ├── bab10_pustaka.tex
│   │   └── bab11_lampiran.tex
│   └── gambar/                # Logo dan dokumen lampiran
│
├── presentation/
│   ├── main.tex               # Beamer deck (xelatex)
│   ├── contents/slides.tex    # Slide dan speaker notes
│   ├── themes/ugm1/           # Tema UGM
│   └── fonts/                 # Font Gama Sans
│
├── docker/
│   └── Dockerfile             # Image build LaTeX
├── .github/
│   └── workflows/
│       └── compile-latex.yml  # CI: kompilasi + release pada push
├── Makefile                   # Build automation
└── .gitignore
```

---

## CI/CD dan Release

Setiap push ke `main` (atau `master`) yang mengubah file `.tex`, `.tex` di `presentation/`, `Dockerfile`, atau `Makefile` memicu GitHub Actions:

1. **Compile Report**: kompilasi `report/main.tex` dengan Docker (`make report-docker`).
2. **Compile Presentation**: kompilasi `presentation/main.tex` dengan `latexmk -xelatex` (`make presentation-docker`).
3. **Create Release**: membuat GitHub Release `report-v<run>` berisi `report.pdf` dan `presentation.pdf` yang dapat diunduh langsung.

Trigger manual juga tersedia melalui tombol *Run workflow* di tab Actions.

---

## Konten Laporan

Laporan mencakup enam mata kuliah MBKM:

| Kode MK | Mata Kuliah | SKS |
|---------|-------------|-----|
| MII21-3011 | Internship: Pengembangan Fitur dan Modul Proyek | 4 |
| MII21-3013 | Internship: Implementasi Prototipe Produk | 4 |
| MII21-3014 | Internship: Pengembangan Backend | 4 |
| MII21-3015 | Internship: Pengujian Unit dan Modul Proyek | 3 |
| MII21-3016 | Internship: Pengujian Integrasi dan Sistem | 3 |
| MII21-4012 | Soft Skill: Kemampuan Bekerjasama dan Kolaborasi | 2 |

Konten laporan didasarkan pada riwayat commit dan PR yang ada di repositori kerja magang: monorepo `digital-employee`, `gl-sdk`, `gl-iam-cookbook`, dan `gdplabs-exploration`.

---

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| `logougm` / logo tidak ditemukan | Ganti `report/gambar/logo-*.png` dengan logo resmi |
| References `[?]` | Jalankan `bibtex main` lalu `pdflatex main.tex` 2x |
| Font Gama Sans tidak ditemukan | Pastikan `presentation/fonts/` berisi file `.otf` |
| PDF tidak update | `make clean` lalu kompilasi ulang |
| Docker error | Pastikan Docker Desktop berjalan |
| Unduhan release lama | Release dibuat per push; gunakan tag `report-v<run>` terbaru |

---

Mahasiswa: **Muhammad Argya Vityasy** (23/522547/PA/22475)
Pembimbing: **Guntur Budi Herwanto, S.Kom., M.Cs.**
Program Studi Ilmu Komputer, FMIPA UGM
