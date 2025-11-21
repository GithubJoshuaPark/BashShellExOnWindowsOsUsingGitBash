#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
source "$SCRIPT_DIR/utils.sh"

echo "========================"
echo "$(basename "$0") Start"
echo "========================"

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 11) grep 고급: 그룹/대체/단어경계
========================================
B

echo "[목표]"
echo "- 그룹화 '()'와 대체 '|'를 사용하여 복잡한 패턴을 만든다."
echo "- 수량자 '?', '+', '*'를 사용하여 반복 패턴을 검색한다."
echo "- 단어 경계 '\b'를 사용하여 정확한 단어를 매칭한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 텍스트 파일 생성"
TEXT_FILE="$TMP_DIR/data.txt"
cat > "$TEXT_FILE" <<'DATA'
color
colour
colou?r
The item is color.
The item is colour.
A colorful item.
user1@example.com
user2@sample.org
user-admin@test.net
log file
logged in
system log
DATA

echo "테스트 파일 생성: $TEXT_FILE"
echo "--------------------------------"
nl -ba "$TEXT_FILE"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  그룹화 '()'와 대체 '|'"
echo "--- 'color' 또는 'colour' 검색 ---"
echo "그룹화를 사용하면 두 단어 중 하나를 포함하는 라인을 찾을 수 있습니다."
echo
echo "실행: grep -E '(color|colour)' \"$TEXT_FILE\""
grep -E --color=always '(color|colour)' "$TEXT_FILE"
f_pause

# ------------------------------------------------------------
echo "3️⃣  수량자(Quantifiers)"
echo "--- '?' (0회 또는 1회) ---"
echo "'colou?r' 패턴은 'u'가 없거나 한 번 있는 경우를 찾습니다. (color, colour)"
echo
echo "실행: grep -E 'colou?r' \"$TEXT_FILE\""
grep -E --color=always 'colou?r' "$TEXT_FILE"
f_pause

echo "--- '+' (1회 이상) ---"
echo "이메일 주소에서 사용자 이름 부분을 찾습니다. (알파벳, 숫자, '-', '_'가 1회 이상 반복)"
echo
echo "실행: grep -E '[a-zA-Z0-9_-]+@' \"$TEXT_FILE\""
grep -E --color=always '[a-zA-Z0-9_-]+@' "$TEXT_FILE"
f_pause

echo "--- '*' (0회 이상) ---"
echo "'user' 뒤에 숫자나 '-'가 0회 이상 나오는 패턴을 찾습니다."
echo
echo "실행: grep -E 'user[0-9-]*' \"$TEXT_FILE\""
grep -E --color=always 'user[0-9-]*' "$TEXT_FILE"
f_pause

# ------------------------------------------------------------
echo "4️⃣  단어 경계 '\b'"
echo "--- 정확한 단어 'log' 검색 ---"
echo "'\b'는 단어의 시작이나 끝을 의미합니다. 'logged'나 'blog' 등은 제외하고 정확히 'log'만 찾습니다."
echo
echo "실행: grep -E '\blog\b' \"$TEXT_FILE\""
grep -E --color=always '\blog\b' "$TEXT_FILE"
f_pause

echo "--- 응용: 단어로 시작하는 'log' ---"
echo "'log'로 시작하는 단어만 찾습니다. ('log', 'logged'는 포함, 'system log'는 미포함)"
echo
echo "실행: grep -E '\blog' \"$TEXT_FILE\""
grep -E --color=always '\blog' "$TEXT_FILE"
f_pause

# ------------------------------------------------------------
echo "✅  레슨 11 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "======================="
echo "$(basename "$0") End"
echo "======================="