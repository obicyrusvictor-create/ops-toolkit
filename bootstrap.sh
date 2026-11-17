#!/usr/bin/env bash
# bootstrap.sh — provision the ops-toolkit toolset on a fresh Kali box
# v2: correct Debian package names, per-package fallbacks, resilient to unknowns.
# Verified package-name fixes: metasploit-framework, exploitdb, set, golang-go.
set -uo pipefail
[[ $EUID -eq 0 ]] || { echo "run with sudo or as root"; exit 1; }

echo "[*] apt update"
DEBIAN_FRONTEND=noninteractive apt-get update -y

install_pkg() {
  # usage: install_pkg <binary-to-verify> <candidate-package> [more candidates...]
  local bin="$1"; shift
  if command -v "$bin" >/dev/null 2>&1; then echo "[=] $bin already present"; return 0; fi
  local p
  for p in "$@"; do
    if apt-cache show "$p" >/dev/null 2>&1 \
       && DEBIAN_FRONTEND=noninteractive apt-get install -y "$p" >/dev/null 2>&1; then
      echo "[+] $bin installed via $p"; return 0
    fi
  done
  echo "[!] could not install $bin (tried: $*)"; return 1
}

install_pkg nmap nmap
install_pkg masscan masscan
install_pkg rustscan rustscan
install_pkg gobuster gobuster
install_pkg ffuf ffuf
install_pkg feroxbuster feroxbuster
install_pkg wfuzz wfuzz
install_pkg nikto nikto
install_pkg sqlmap sqlmap
install_pkg wpscan wpscan
install_pkg nuclei nuclei
install_pkg subfinder subfinder
install_pkg amass amass
install_pkg whatweb whatweb
install_pkg wafw00f wafw00f
install_pkg dnsrecon dnsrecon
install_pkg enum4linux enum4linux
install_pkg smbclient smbclient
install_pkg netexec netexec crackmapexec
install_pkg impacket-smbexec impacket-smbexec python3-impacket
install_pkg responder responder
install_pkg hydra hydra
install_pkg medusa medusa
install_pkg patator patator
install_pkg john john
install_pkg hashcat hashcat
install_pkg hashid hashid
install_pkg searchsploit exploitdb
install_pkg msfconsole metasploit-framework
install_pkg setoolkit set
install_pkg bettercap bettercap
install_pkg tcpdump tcpdump
install_pkg tshark tshark
install_pkg socat socat
install_pkg ncat ncat
install_pkg proxychains4 proxychains4
install_pkg sslscan sslscan
install_pkg sslyze sslyze
install_pkg testssl testssl.sh
install_pkg aircrack-ng aircrack-ng
install_pkg hcxdumptool hcxdumptool
install_pkg hcxpcapngtool hcxtools
install_pkg go golang-go
install_pkg git git
install_pkg python3 python3

if [[ -d /usr/share/seclists ]]; then
  echo "[=] seclists already present"
else
  DEBIAN_FRONTEND=noninteractive apt-get install -y seclists >/dev/null 2>&1 \
    && echo "[+] seclists installed" || echo "[!] seclists missing"
fi

echo "[*] verifying core tools"
MISS=0
for t in nmap rustscan ffuf gobuster nuclei sqlmap netexec msfconsole hashcat; do
  command -v "$t" >/dev/null 2>&1 || { echo "MISS $t"; MISS=1; }
done
[[ $MISS -eq 0 ]] && echo "[+] all core tools present" || echo "[!] gaps remain — review [!] lines above"
ls /usr/share/seclists >/dev/null 2>&1 && echo "[+] seclists in place"
