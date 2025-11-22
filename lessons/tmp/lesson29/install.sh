#!/usr/bin/env bash
set -euo pipefail

TOOL_NAME="mytool"
SOURCE_PATH="./$TOOL_NAME"
INSTALL_DIR="/usr/local/bin"

echo "Installing $TOOL_NAME to $INSTALL_DIR..."

# 설치 디렉토리가 PATH에 있는지 확인
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "경고: $INSTALL_DIR이 $PATH에 없습니다. 수동으로 추가해야 할 수 있습니다."
fi

# 실행 권한 부여
chmod +x "$SOURCE_PATH"

# 설치
sudo cp "$SOURCE_PATH" "$INSTALL_DIR/$TOOL_NAME"

echo "$TOOL_NAME 설치 완료! 이제 터미널에서 '$TOOL_NAME <메시지>'로 실행할 수 있습니다."
echo "설치된 경로: $INSTALL_DIR/$TOOL_NAME"
