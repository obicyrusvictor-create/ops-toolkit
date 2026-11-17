#!/usr/bin/env bash
# run.sh — start the deliberately-vulnerable practice target
# LAB ONLY. Binds to loopback by design. Never expose beyond localhost/isolated nets.
set -euo pipefail
cd "$(dirname "$0")"
[[ -f flag.txt ]] || echo "flag{lab_rce_replace_me}" > flag.txt
echo "[*] target: http://127.0.0.1:8081  (flag at lab/flag.txt)"
exec php -S 127.0.0.1:8081 -t app
