#!/usr/bin/env bash
# render-video.sh — assemble slides + voice into a 16:9 (or 9:16) video
#
# Usage:
#   ./render-video.sh <project-dir> <voice.mp4> <slides-dir> <out.mp4> [--vertical]
#
# project-dir : e.g. ../videos/2026-09-30  (contains voice.mp4 optionally)
# slides-dir  : slide-01.png … slide-NN.png (sorted)
# durations   : <slides-dir>/durations.txt — one number of seconds per line,
#               one line per slide, in order. Defaults to 8s per slide.
#
# Requires: ffmpeg
set -euo pipefail

if [ $# -lt 4 ]; then
  echo "usage: $0 <project-dir> <voice> <slides-dir> <out.mp4> [--vertical]" >&2
  exit 1
fi

PROJECT="$1"; VOICE="$2"; SLIDES="$3"; OUT="$4"; VERTICAL="${5:-}"

command -v ffmpeg >/dev/null || { echo "ffmpeg not found — install it first" >&2; exit 1; }

# collect slides in order
mapfile -t slide_files < <(ls "$SLIDES"/slide-*.png 2>/dev/null | sort)
[ ${#slide_files[@]} -gt 0 ] || { echo "no slide-*.png in $SLIDES" >&2; exit 1; }

# durations: from durations.txt or default 8s each
declare -a durs=()
if [ -f "$SLIDES/durations.txt" ]; then
  while IFS= read -r line; do
    [ -n "$line" ] && durs+=("$line")
  done < "$SLIDES/durations.txt"
fi
if [ ${#durs[@]} -lt ${#slide_files[@]} ]; then
  durs=()
  for _ in "${slide_files[@]}"; do durs+=(8); done
fi

# build concat list (still image per slide)
CONC="$PROJECT/concat.txt"
: > "$CONC"
for i in "${!slide_files[@]}"; do
  printf "file '%s'\n" "${slide_files[$i]}" >> "$CONC"
  printf "duration %s\n" "${durs[$i]}" >> "$CONC"
done
# ffmpeg concat quirk: last file must be repeated without duration to be included
printf "file '%s'\n" "${slide_files[-1]}" >> "$CONC"

if [ "$VERTICAL" = "--vertical" ]; then
  VF="scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,fps=24"
else
  VF="scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,fps=24"
fi

ffmpeg -y -f concat -safe 0 -i "$CONC" -i "$VOICE" \
  -vf "$VF" -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
  -c:a aac -b:a 192k -shortest "$OUT"

echo "rendered: $OUT"
