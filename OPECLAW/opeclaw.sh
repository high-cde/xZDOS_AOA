#!/usr/bin/env bash
source "$(dirname "$0")/config/social.conf"

clear
echo "──────────────────────────────────────────────"
echo "   OPECLAW · xCLOUD / x-ZDOS · Social Hub"
echo "──────────────────────────────────────────────"
echo
echo "  [1] GitHub · xCLOUD-by-zdos"
echo "  [2] GitHub · Z-GENESIS-OS"
echo "  [3] x-zdos.it"
echo "  [4] xZDOS AOA"
echo "  [5] Discord Workspace"
echo
echo "  [A] Agenti"
echo "  [M] Automi"
echo "  [Q] Esci"
echo
read -rp "Seleziona: " choice

case "$choice" in
  1) termux-open-url "$XCLOUD_REPO_URL" ;;
  2) termux-open-url "$ZGENESIS_REPO_URL" ;;
  3) termux-open-url "$XZDOS_SITE_URL" ;;
  4) termux-open-url "$XZDOS_AOA_URL" ;;
  5) termux-open-url "$DISCORD_URL" ;;
  [Aa]) bash "$(dirname "$0")/agents/agent-menu.sh" ;;
  [Mm]) bash "$(dirname "$0")/automi/automa-menu.sh" ;;
  [Qq]) exit 0 ;;
esac
