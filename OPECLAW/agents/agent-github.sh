#!/usr/bin/env bash
source "$(dirname "$0")/../config/social.conf"
clear
echo "── Agente GitHub ──"
echo "  [1] Apri xCLOUD"
echo "  [2] Apri Z-GENESIS-OS"
echo "  [3] Apri xZDOS_AOA"
echo "  [Q] Indietro"
read -rp "Scelta: " c
case "$c" in
  1) termux-open-url "$XCLOUD_REPO_URL" ;;
  2) termux-open-url "$ZGENESIS_REPO_URL" ;;
  3) termux-open-url "$XZDOS_AOA_URL" ;;
  [Qq]) exit 0 ;;
esac
