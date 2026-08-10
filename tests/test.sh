#!/usr/bin/env bash
set -uo pipefail

mkdir -p /logs/verifier

if [ -f "/tests/run_script.sh" ]; then
  bash /tests/run_script.sh || true
else
  echo "Error: run_script.sh not found!" >&2
fi

if [ -f "/tests/parser.py" ]; then
  python3 /tests/parser.py
else
  echo "0" > /logs/verifier/reward.txt
fi

if [ ! -f "/logs/verifier/reward.txt" ]; then
  echo "0" > /logs/verifier/reward.txt
fi
