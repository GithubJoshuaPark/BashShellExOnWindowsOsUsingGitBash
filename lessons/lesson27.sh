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
 레슨 27) 설정파일 키-값 편집기 (sed 중심)
========================================
B

echo "[목표]"
echo "- 'sed'를 사용하여 설정 파일에서 특정 키의 값을 추출한다."
echo "- 'sed'를 사용하여 기존 키의 값을 변경한다."
echo "- 'sed'와 'grep'을 조합하여 새로운 키-값 쌍을 추가한다."
echo "- 'sed'를 사용하여 특정 키-값 쌍을 삭제한다."
echo "- 설정 파일 편집 시 주석 및 공백 라인을 처리하는 방법을 배운다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 설정 파일 생성"
CONFIG_FILE="$TMP_DIR/app.conf"
cat > "$CONFIG_FILE" <<'DATA'
# Application Configuration
server_port=8080
database_host=localhost
database_port=5432
debug_mode=false

# Logging settings
log_level=INFO
log_file=/var/log/app.log

# This is a commented out setting
# max_connections=100
DATA

echo "설정 파일 생성: $CONFIG_FILE"
echo "--------------------------------"
cat "$CONFIG_FILE"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  특정 키의 값 추출하기"
echo "--- 'server_port' 값 추출 ---"
echo "실행: sed -n '/^server_port=/s/^server_port=//p' \"$CONFIG_FILE\""
sed -n '/^server_port=/s/^server_port=//p' "$CONFIG_FILE"
f_pause

echo "--- 'log_level' 값 추출 (주석 및 공백 라인 무시) ---"
echo "실행: grep '^log_level=' \"$CONFIG_FILE\" | sed 's/^log_level=//'"
grep '^log_level=' "$CONFIG_FILE" | sed 's/^log_level=//'
f_pause

# ------------------------------------------------------------
echo "3️⃣  기존 키의 값 변경하기"
echo "--- 'server_port'를 '8080'에서 '9000'으로 변경 ---"
echo "실행: sed -i.bak 's/^server_port=8080/server_port=9000/' \"$CONFIG_FILE\""
sed_i_bak 's/^server_port=8080/server_port=9000/' "$CONFIG_FILE"
echo "변경 후 파일 내용:"
cat "$CONFIG_FILE"
f_pause

echo "--- 'debug_mode'를 'false'에서 'true'로 변경 ---"
echo "실행: sed -i 's/^debug_mode=false/debug_mode=true/' \"$CONFIG_FILE\""
sed_i 's/^debug_mode=false/debug_mode=true/' "$CONFIG_FILE"
echo "변경 후 파일 내용:"
cat "$CONFIG_FILE"
f_pause

# ------------------------------------------------------------
echo "4️⃣  새로운 키-값 쌍 추가하기 (존재하지 않을 경우)"
echo "--- 'timeout=60' 추가 (이미 존재하면 추가 안함) ---"
KEY_TO_ADD="timeout"
VALUE_TO_ADD="60"
if ! grep -q "^${KEY_TO_ADD}=" "$CONFIG_FILE"; then
    echo "실행: echo \"${KEY_TO_ADD}=\${VALUE_TO_ADD}\" >> \"$CONFIG_FILE\""
    echo "${KEY_TO_ADD}=${VALUE_TO_ADD}" >> "$CONFIG_FILE"
    echo "'${KEY_TO_ADD}' 추가 완료."
else
    echo "'${KEY_TO_ADD}'는 이미 존재합니다. 추가하지 않습니다."
fi
echo "변경 후 파일 내용:"
cat "$CONFIG_FILE"
f_pause

# ------------------------------------------------------------
echo "5️⃣  키-값 쌍 삭제하기"
echo "--- 'log_file' 설정 삭제 ---"
echo "실행: sed -i '/^log_file=/d' \"$CONFIG_FILE\""
sed_i '/^log_file=/d' "$CONFIG_FILE"
echo "변경 후 파일 내용:"
cat "$CONFIG_FILE"
f_pause

# ------------------------------------------------------------
echo "6️⃣  주석 처리된 설정 변경 및 활성화"
echo "--- '# max_connections=100'을 'max_connections=200'으로 변경 및 활성화 ---"
echo "실행: sed -i 's/^# *max_connections=.*/max_connections=200/' \"$CONFIG_FILE\""
sed_i 's/^# *max_connections=.*/max_connections=200/' "$CONFIG_FILE"
echo "변경 후 파일 내용:"
cat "$CONFIG_FILE"
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 27 완료!"
echo "sed를 활용하여 설정 파일을 효율적으로 관리하는 방법을 익혔습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"