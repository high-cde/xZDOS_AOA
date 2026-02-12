#!/usr/bin/env bash
clear
echo "── Automi OPECLAW ──"
echo
echo "  [1] Auto-sync"
echo "  [2] Health-check"
echo "  [Q] Indietro"
read -rp "Scelta: " c
case "$c" in
  1) bash "$(dirname "$0")/auto-sync.sh" ;;
  2) bash "$(dirname "$0")/health-check.sh" ;;
  [Qq]) exit 0 ;;
esac
