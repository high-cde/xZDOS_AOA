#!/usr/bin/env bash
clear
echo "── Agenti OPECLAW ──"
echo
echo "  [1] Agente GitHub"
echo "  [2] Agente Discord"
echo "  [Q] Indietro"
echo
read -rp "Scelta: " c

case "$c" in
  1) bash "$(dirname "$0")/agent-github.sh" ;;
  2) bash "$(dirname "$0")/agent-discord.sh" ;;
  [Qq]) exit 0 ;;
esac
