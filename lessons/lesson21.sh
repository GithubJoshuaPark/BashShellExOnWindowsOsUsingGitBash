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
 레슨 21) 파라미터 확장 고급
========================================
B

echo "[목표]"
echo "- Bash의 파라미터 확장을 사용하여 변수 값을 다양하게 조작한다."
echo "- 기본값 설정, 부분 문자열 제거, 교체, 길이 계산 등을 익힌다."
echo "- 외부 명령어(sed, awk 등) 없이 순수 Bash로 문자열을 처리하는 방법을 배운다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 변수 설정"
file="document.tar.gz"
path="/usr/local/bin/myscript.sh"
message="Hello World, hello bash!"
name=""
user="admin"
prefix_var_1="value1"
prefix_var_2="value2"

echo "file = \"$file\""
echo "path = \"$path\""
echo "message = \"$message\""
echo "name = \"$name\" (비어있음)"
echo "user = \"$user\""
echo "prefix_var_1 = \"$prefix_var_1\""
echo "prefix_var_2 = \"$prefix_var_2\""
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  기본값 설정 및 대체"
echo "--- \${parameter:-word}: 변수가 설정되지 않았거나 비어있으면 word 사용 (변수 값 변경 없음) ---"
echo "실행: echo \"이름: \${name:-'Guest'}\""
echo "이름: ${name:-'Guest'}"
echo "실행: echo \"사용자: \${user:-'Guest'}\""
echo "사용자: ${user:-'Guest'}"
f_pause

echo "--- \${parameter:=word}: 변수가 설정되지 않았거나 비어있으면 word를 변수에 할당 후 사용 ---"
echo "실행: echo \"이름: \${name:='Guest'}\""
echo "이름: ${name:='Guest'}"
echo "name 변수 값: \"$name\""
f_pause

echo "--- \${parameter:+word}: 변수가 설정되어 있고 비어있지 않으면 word 사용 (변수 값 변경 없음) ---"
echo "실행: echo \"사용자 상태: \${user:+'Active'}\""
echo "사용자 상태: ${user:+'Active'}"
echo "실행: echo \"이름 상태: \${name:+'Active'}\""
echo "이름 상태: ${name:+'Active'}"
f_pause

echo "--- \${parameter:?word}: 변수가 설정되지 않았거나 비어있으면 에러 메시지 출력 후 스크립트 종료 ---"
echo "실행: echo \"사용자: \${user:?'User variable is not set!'}\""
echo "사용자: ${user:?'User variable is not set!'}"
echo "(name 변수는 이미 'Guest'로 설정되어 있으므로 에러 발생 안함)"
echo "실행: echo \"이름: \${name:?'Name variable is not set!'}\""
echo "이름: ${name:?'Name variable is not set!'}"
f_pause

# ------------------------------------------------------------
echo "3️⃣  부분 문자열 제거"
echo "--- \${parameter#word}: 앞에서부터 가장 짧게 일치하는 패턴 제거 ---"
echo "실행: echo \"${file#*.}\" (첫 번째 점(.)까지 제거)" # file="document.tar.gz"
echo "${file#*.}"
echo "실행: echo \"${path#/usr/}\" (/usr/ 제거)" # path="/usr/local/bin/myscript.sh"
echo "${path#/usr/}"
f_pause

echo "--- \${parameter##word}: 앞에서부터 가장 길게 일치하는 패턴 제거 ---"
echo "실행: echo \"${file##*.}\" (마지막 점(.)까지 제거)"
echo "${file##*.}"
echo "실행: echo \"${path##*/}\" (마지막 슬래시(/)까지 제거, 파일명만 남김)"
echo "${path##*/}"
f_pause

echo "--- \${parameter%word}: 뒤에서부터 가장 짧게 일치하는 패턴 제거 ---"
echo "실행: echo \"${file%.*}\" (마지막 점(.)부터 제거, 확장자 제거)"
echo "${file%.*}"
echo "실행: echo \"${path%/myscript.sh}\" (myscript.sh 제거, 디렉토리 경로만 남김)"
echo "${path%/myscript.sh}"
f_pause

echo "--- \${parameter%%word}: 뒤에서부터 가장 길게 일치하는 패턴 제거 ---"
echo "실행: echo \"${file%%.*}\" (첫 번째 점(.)부터 제거)"
echo "${file%%.*}"
echo "실행: echo \"${path%%/*}\" (가장 긴 / 패턴 제거, 비어있음)"
echo "${path%%/*}"
f_pause

# ------------------------------------------------------------
echo "4️⃣  부분 문자열 교체"
echo "--- \${parameter/pattern/string}: 첫 번째 일치하는 패턴 교체 ---"
echo "실행: echo \"${message/hello/Hi}\"" # message="Hello World, hello bash!"
echo "${message/hello/Hi}"
f_pause

echo "--- \${parameter//pattern/string}: 모든 일치하는 패턴 교체 ---"
echo "실행: echo \"${message//hello/Hi}\""
echo "${message//hello/Hi}"
f_pause

# ------------------------------------------------------------
echo "5️⃣  문자열 길이 계산"
echo "--- \${#parameter}: 변수의 문자열 길이 반환 ---"
echo "실행: echo \"file 변수의 길이: \${#file}\"" # file="document.tar.gz"
echo "file 변수의 길이: ${#file}"
echo "실행: echo \"message 변수의 길이: \${#message}\""
echo "message 변수의 길이: ${#message}"
f_pause

# ------------------------------------------------------------
echo "6️⃣  간접 확장 (Indirect Expansion)"
echo "--- \${!prefix*}: 'prefix'로 시작하는 모든 변수 이름 나열 ---"
echo "실행: echo \"${!prefix*}\""
echo "${!prefix*}"
f_pause

echo "--- \${!variable_name}: 변수 이름의 값을 변수 이름으로 사용 ---"
echo "var_name=\"file\""
echo "실행: echo \${!var_name} (file 변수의 값 출력)"
var_name="file"
echo "${!var_name}"
f_pause

# ------------------------------------------------------------
echo "✅  레슨 21 완료!"
echo "파라미터 확장은 Bash 스크립트에서 문자열을 효율적으로 다루는 강력한 방법입니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"