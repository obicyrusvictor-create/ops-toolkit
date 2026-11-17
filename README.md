# ops-toolkit — personal pentest workspace

Curated offensive-testing toolkit: recon automation, tool bootstrap, and a local
deliberately-vulnerable practice target. Built and live-tested on Kali Rolling.

## Contents
- `scripts/quickrecon.sh` — bounded first-pass recon: rustscan sweep → nmap service/version scan on discovered ports. Usage: `./scripts/quickrecon.sh <target>`; output lands in `recon/<sanitized-target>/`.
- `bootstrap.sh` — installs the full toolset used by this workspace on a fresh Kali box (apt-based; ~40 tools incl. metasploit, netexec, impacket, nuclei, ffuf, sqlmap, hashcat, responder, bettercap, aircrack-ng).
- `lab/` — intentionally vulnerable PHP app ("SysMon Portal", OS command injection, CWE-78) with a plantable flag. For attacker-skill practice in isolated labs ONLY.
- `lab/run.sh` — starts the practice target on 127.0.0.1:8081.

## Quick start
```
./bootstrap.sh            # once, on a fresh Kali
./lab/run.sh &            # start practice target
./scripts/quickrecon.sh 127.0.0.1
```

## Layout conventions (recreate locally)
```
ops/
  targets/ recon/ exploits/ loot/ reports/ evidence/ scripts/
```
Rule of thumb: every scan writes its own output file; loot and evidence never
leave the workspace; use task-unique PoC filenames (`poc_<taskid>.py`).

## Legal / ethics
For use only against systems you own or are explicitly authorized to test
(contract, bug-bounty scope). The lab app is deliberately vulnerable — never
expose it beyond localhost/isolated networks.

## Requirements
Kali Linux (Rolling), sudo, ~2 GB disk for tooling. Wordlists via seclists
(`/usr/share/seclists`).
