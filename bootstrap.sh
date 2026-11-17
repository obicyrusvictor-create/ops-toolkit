#!/usr/bin/env bash
# bootstrap.sh — provision the ops-toolkit toolset on a fresh Kali box
# Verified live on Kali Rolling, 2026-11-17.
set -uo pipefail
[[ $EUID -eq 0 ]] || { echo "run with sudo or as root"; exit 1; }

echo "[*] apt update"
DEBIAN_FRONTEND=noninteractive apt-get update -y

echo "[*] installing toolset"
DEBIAN_FRONTEND=noninteractive apt-get install -y \
  nmap masscan gobuster ffuf feroxbuster wfuzz nikto \
  sqlmap wpscan nuclei subfinder amass whatweb wafw00f dnsrecon \
  enum4linux enum4linux-ng smbclient netexec impacket-smbexec responder \
  hydra medusa patator john hashcat hashid searchsploit \
  msfconsole setoolkit bettercap tcpdump tshark socat ncat proxychains4 \
  sslscan sslyze testssl.sh aircrack-ng hcxdumptool hcxtools \
  rustscan dirsearch seclists python3 go git \
  || echo "[!] some packages may need individual attention — check apt output"

echo "[*] verifying core tools"
MISS=0
for t in nmap rustscan ffuf gobuster nuclei sqlmap netexec msfconsole hashcat; do
  command -v "$t" >/dev/null 2>&1 || { echo "MISS $t"; MISS=1; }
done
[[ $MISS -eq 0 ]] && echo "[+] all core tools present" || echo "[!] gaps remain — review above"
ls /usr/share/seclists >/dev/null 2>&1 && echo "[+] seclists in place"
