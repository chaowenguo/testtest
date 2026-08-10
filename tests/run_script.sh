#!/usr/bin/env bash
set -uo pipefail

mkdir -p /logs/verifier
cd /workspace

pytest -v /tests/test_behavior.py > /logs/verifier/pytest_output.log 2>&1 || true
