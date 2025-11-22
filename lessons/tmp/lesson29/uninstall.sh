#!/usr/bin/env bash
set -euo pipefail

TOOL_NAME="mytool"
INSTALL_DIR="/usr/local/bin"

echo "Uninstalling mytool from /usr/local/bin..."

if [[ -f "/usr/local/bin/mytool" ]]; then
    sudo rm "/usr/local/bin/mytool"
    echo "mytool 제거 완료."
else
    echo "mytool이 설치되어 있지 않습니다."
fi
