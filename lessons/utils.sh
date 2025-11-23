#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
f_pause() { read -rp "계속하려면 [Enter] 키를 누르세요..." _; echo; }