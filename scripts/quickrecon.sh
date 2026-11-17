#!/usr/bin/env bash
# quickrecon.sh — bounded first-pass recon
# Usage: ./quickrecon.sh <target-ip-or-host>
set -uo pipefail
T="${1:?Usage: quickrecon.sh <target>}"
SAFE=$(echo "$T" | tr '/:.' '__')
OUT="/home/kali/ops/recon/$SAFE"
mkdir -p "$OUT"

echo "[*] fast port sweep: $T"
rustscan -a "$T" --ulimit 3000 -t 1500 --no-banner -g > "$OUT/rustscan.txt" 2>&1 || true

# rustscan -g emits: 127.0.0.1 -> [80,5355,8081,...]
PORTS=$(grep -oE '\[[0-9, ]+\]' "$OUT/rustscan.txt" 2>/dev/null | tr -d '[]' | tr ' ' ',' | sed 's/,\{2,\}/,/g' | sed 's/^,//' | sed 's/,$//')
echo "[*] open ports: ${PORTS:-none}"

if [ -n "${PORTS:-}" ]; then
  echo "[*] service/version scan on $PORTS"
  nmap -sV -sC -Pn -p "$PORTS" -oN "$OUT/nmap-services.txt" "$T" || true
fi

echo "[+] done. results in $OUT"
