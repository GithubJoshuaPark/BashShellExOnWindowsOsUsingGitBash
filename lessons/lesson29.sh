#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

source "$SCRIPT_DIR/utils.sh"

echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 29) CLI 미니툴 배포 패키징
========================================
B

echo "[목표]"
echo "- 간단한 Bash 스크립트를 CLI 미니툴로 만드는 방법을 배운다."
echo "- 미니툴을 실행 가능하게 만들고 시스템 PATH에 추가하는 방법을 이해한다."
echo "- 'install.sh' 및 'uninstall.sh' 스크립트를 작성하여 배포를 자동화한다."
echo "- 다른 사용자가 쉽게 설치하고 사용할 수 있는 도구를 만드는 과정을 익힌다."
echo

# ------------------------------------------------------------
echo "1️⃣  샘플 CLI 미니툴 생성"
TOOL_NAME="mytool"
TOOL_PATH="$TMP_DIR/$TOOL_NAME"
cat > "$TOOL_PATH" <<'TOOL_SCRIPT'
#!/usr/bin/env bash
# mytool - 간단한 CLI 미니툴 예제

if [[ -z "$1" ]]; then
    echo "사용법: mytool <메시지>"
    exit 1
fi

echo "MyTool says: $1"
TOOL_SCRIPT

echo "샘플 미니툴 '$TOOL_NAME' 생성 완료:"
cat "$TOOL_PATH"
f_pause

# ------------------------------------------------------------
echo "2️⃣  미니툴 실행 가능하게 만들기"
echo "--- 'chmod +x'로 실행 권한 부여 ---"
echo "실행: chmod +x \"$TOOL_PATH\""
chmod +x "$TOOL_PATH"
echo "실행 권한 부여 완료."
ls -l "$TOOL_PATH"
f_pause

# ------------------------------------------------------------
echo "3️⃣  미니툴 설치 스크립트 작성"
INSTALL_SCRIPT="$TMP_DIR/install.sh"
UNINSTALL_SCRIPT="$TMP_DIR/uninstall.sh"
INSTALL_DIR="/usr/local/bin" # 일반적인 시스템 PATH 디렉토리

cat > "$INSTALL_SCRIPT" <<EOF
#!/usr/bin/env bash
set -euo pipefail

TOOL_NAME="mytool"
SOURCE_PATH="$(dirname "\$0")/\$TOOL_NAME"
INSTALL_DIR="$INSTALL_DIR"

echo "Installing \$TOOL_NAME to \$INSTALL_DIR..."

# 설치 디렉토리가 PATH에 있는지 확인
if [[ ":\$PATH:" != *":\$INSTALL_DIR:"* ]]; then
    echo "경고: \$INSTALL_DIR이 \$PATH에 없습니다. 수동으로 추가해야 할 수 있습니다."
fi

# 실행 권한 부여
chmod +x "\$SOURCE_PATH"

# 설치
sudo cp "\$SOURCE_PATH" "\$INSTALL_DIR/\$TOOL_NAME"

echo "\$TOOL_NAME 설치 완료! 이제 터미널에서 '\$TOOL_NAME <메시지>'로 실행할 수 있습니다."
echo "설치된 경로: \$INSTALL_DIR/\$TOOL_NAME"
EOF

cat > "$UNINSTALL_SCRIPT" <<EOF
#!/usr/bin/env bash
set -euo pipefail

TOOL_NAME="mytool"
INSTALL_DIR="$INSTALL_DIR"

echo "Uninstalling $TOOL_NAME from $INSTALL_DIR..."

if [[ -f "$INSTALL_DIR/$TOOL_NAME" ]]; then
    sudo rm "$INSTALL_DIR/$TOOL_NAME"
    echo "$TOOL_NAME 제거 완료."
else
    echo "$TOOL_NAME이 설치되어 있지 않습니다."
fi
EOF

chmod +x "$INSTALL_SCRIPT" "$UNINSTALL_SCRIPT"

echo "설치 스크립트 '$INSTALL_SCRIPT' 생성 완료:"
cat "$INSTALL_SCRIPT"
f_pause

echo "제거 스크립트 '$UNINSTALL_SCRIPT' 생성 완료:"
cat "$UNINSTALL_SCRIPT"
f_pause

# ------------------------------------------------------------
echo "4️⃣  미니툴 설치 및 테스트 (sudo 필요)"
echo "--- 설치 스크립트 실행 ---"
echo "실행: sudo \"$INSTALL_SCRIPT\""
# 실제 설치는 sudo 권한이 필요하므로, 여기서는 시뮬레이션만 합니다.
# sudo "$INSTALL_SCRIPT"
echo "(실제 환경에서는 위 명령어를 실행하여 설치합니다.)"
echo "설치 시뮬레이션: '$TOOL_NAME'이 '$INSTALL_DIR'에 복사되었다고 가정합니다."
cp "$TOOL_PATH" "$TMP_DIR/installed_mytool" # 임시로 설치된 것처럼 시뮬레이션
chmod +x "$TMP_DIR/installed_mytool"
f_pause

echo "--- 설치된 미니툴 실행 테스트 ---"
echo "실행: \"$TMP_DIR/installed_mytool\" \"Hello from installed tool!\""
"$TMP_DIR/installed_mytool" "Hello from installed tool!"
f_pause

# ------------------------------------------------------------
echo "5️⃣  미니툴 제거 (sudo 필요)"
echo "--- 제거 스크립트 실행 ---"
echo "실행: sudo \"$UNINSTALL_SCRIPT\""
# 실제 제거는 sudo 권한이 필요하므로, 여기서는 시뮬레이션만 합니다.
# sudo "$UNINSTALL_SCRIPT"
echo "(실제 환경에서는 위 명령어를 실행하여 제거합니다.)"
echo "제거 시뮬레이션: '$TOOL_NAME'이 '$INSTALL_DIR'에서 제거되었다고 가정합니다."
rm "$TMP_DIR/installed_mytool" # 임시로 제거된 것처럼 시뮬레이션
echo "제거 후 '$TOOL_NAME' 존재 여부:"
ls "$TMP_DIR/installed_mytool" 2>/dev/null || echo "파일 없음."
f_pause

# ------------------------------------------------------------
echo "✅  레슨 29 완료!"
echo "간단한 CLI 미니툴을 만들고 배포하는 과정을 이해했습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"
