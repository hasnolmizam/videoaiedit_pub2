#!/usr/bin/env bash
# Cantum 3 klip (asal atau yang dah diedit AI) jadi satu video dengan audio asal.
# Setiap klip diseragamkan ke 720x1280, 30fps supaya klip dari Runway/Kling boleh disambung.
# Guna: ./cantum.sh [klip1] [klip2] [klip3] [output]
set -euo pipefail
cd "$(dirname "$0")"
K1=${1:-clips/klip1_logo_0-4s.mp4}
K2=${2:-clips/klip2_casis_4-8s.mp4}
K3=${3:-clips/klip3_kereta_8-14s.mp4}
OUT=${4:-output/video_cantum.mp4}
mkdir -p "$(dirname "$OUT")"
NORM="scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,fps=30,setsar=1,format=yuv420p"
ffmpeg -v error -y -i "$K1" -i "$K2" -i "$K3" -i clips/audio_asal.m4a \
  -filter_complex "[0:v]$NORM[a];[1:v]$NORM[b];[2:v]$NORM[c];[a][b][c]concat=n=3:v=1:a=0[v]" \
  -map "[v]" -map 3:a -c:v libx264 -crf 16 -preset slow -c:a copy -shortest -movflags +faststart "$OUT"
echo "Siap: $OUT"
