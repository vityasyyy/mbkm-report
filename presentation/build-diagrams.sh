#!/usr/bin/env sh
# Build the standalone TikZ diagrams to PDF and copy them into diagrams/.
# Invoked by `make presentation`, `make presentation-diagrams`, and the Docker
# target. A script is used instead of a make one-liner to avoid shell-quoting
# bugs where `$f` is expanded by the outer make shell (which sees an empty f).
set -eu

cd "$(dirname "$0")"
TIKZ=diagrams/tikz
OUT=diagrams

if [ ! -d "$TIKZ" ]; then
    echo "error: $TIKZ not found" >&2
    exit 1
fi

for f in "$TIKZ"/*.tex; do
    [ -e "$f" ] || continue
    name=$(basename "$f" .tex)
    echo "building diagram: $name"
    if ( cd "$TIKZ" && pdflatex -interaction=nonstopmode "$name.tex" >/dev/null 2>&1 ); then
        cp "$TIKZ/$name.pdf" "$OUT/$name.pdf"
    else
        echo "error: failed to build diagram $name" >&2
        exit 1
    fi
done

echo "all diagrams built"
