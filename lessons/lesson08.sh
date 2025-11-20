#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
pause() { read -rp "계속하려면 [Enter] 키를 누르세요..." _; echo; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo "========================"
echo "$(basename "$0") Start"
echo "========================"

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 08) 함수 & 스코프
========================================
B

echo "[목표]"
echo "- 함수를 정의하고 호출하는 방법을 익힌다."
echo "- 함수에 인자를 전달하고, 반환 값(종료 코드)과 출력 값을 다룬다."
echo "- 전역(global) 변수와 지역(local) 변수의 스코프 차이를 이해한다."
echo

# ------------------------------------------------------------
echo "1️⃣  함수 정의와 호출"
# 함수 정의 (가장 일반적인 방식)
greet() {
  echo "  -> Hello from the greet function!"
}

echo "함수 정의: greet() { ... }"
echo "함수 호출: greet"
greet # 함수 호출
pause

# ------------------------------------------------------------
echo "2️⃣  인자(Argument) 전달"
# $1, $2, ... : 위치 인자
# $# : 인자의 개수
# "$@" : 모든 인자를 개별적으로 전달 (가장 안전하고 일반적인 방법)
print_args() {
  echo "  - 인자의 개수(\$#): $#"
  echo "  - 첫 번째 인자(\$1): $1"
  echo "  - 두 번째 인자(\$2): $2"
  echo "  - 모든 인자(\"\$@\"): $@"
  echo "  ---"
  # "$@"는 for문과 함께 사용할 때 각 인자를 정확히 분리해준다.
  for arg in "$@"; do
    echo "    - Arg: '$arg'"
  done
}

echo "함수 호출: print_args \"First Arg\" \"Second Arg\""
print_args "First Arg" "Second Arg"
pause

# ------------------------------------------------------------
echo "3️⃣  반환 값 (종료 코드)"
echo "함수는 0~255 사이의 '종료 코드'를 반환하며, 0은 '성공'을 의미합니다."
echo "'return' 키워드를 사용합니다."

check_file_exists() {
  if [[ -f "$1" ]]; then
    echo "  -> 파일 '$1'을 찾았습니다."
    return 0 # 성공
  else
    echo "  -> 파일 '$1'이 없습니다."
    return 1 # 실패
  fi
}

# 테스트 파일 생성
touch "$TMP_DIR/my_file.txt"

echo
echo "성공 케이스:"
check_file_exists "$TMP_DIR/my_file.txt"
echo "  - 종료 코드(\$?): $?"

echo
echo "실패 케이스:"
check_file_exists "$TMP_DIR/non_existent_file.txt" || true # set -e 우회
echo "  - 종료 코드(\$?): $?"
echo

echo "if문과 함께 사용:"
if check_file_exists "$TMP_DIR/my_file.txt"; then
  echo "  -> 작업 성공!"
fi
pause

# ------------------------------------------------------------
echo "4️⃣  출력 값 (문자열 등)"
echo "문자열 같은 결과는 'echo'로 출력하고, '명령어 치환'으로 받습니다."

get_line_count() {
  local file_path="$1"
  # 파일이 존재하는지 먼저 확인
  if ! [[ -f "$file_path" ]]; then
    echo "Error: File not found." >&2 # 에러 메시지는 stderr로 출력
    return 1
  fi
  wc -l < "$file_path" | tr -d ' ' # 라인 수를 세고 공백 제거
}

# 테스트 파일 생성
echo -e "line 1\nline 2\nline 3" > "$TMP_DIR/my_file.txt"

echo "함수 호출: line_count=\$(get_line_count \"$TMP_DIR/my_file.txt\")"
line_count=$(get_line_count "$TMP_DIR/my_file.txt")
echo "  -> 라인 수: $line_count"
pause

# ------------------------------------------------------------
echo "5️⃣  스코프 (Scope): 전역 변수 vs 지역 변수"
my_var="I am global"
echo "함수 밖에서 변수 선언: my_var=\"$my_var\""

scope_test() {
  echo "  --- 함수 안 ---"
  echo "  [Before] 함수 안에서 본 my_var: $my_var"

  # 전역 변수를 수정
  my_var="Modified by function"

  # 'local' 키워드로 지역 변수 선언
  local local_var="I am local to the function"
  echo "  'local' 변수: $local_var"
  echo "  --- 함수 끝 ---"
}

scope_test
echo
echo "함수 밖에서 다시 확인:"
echo "  [After] 함수 실행 후 my_var: $my_var"
echo "  -> 함수 안에서 변경한 내용이 함수 밖에도 영향을 미칩니다 (전역 변수)."
echo
echo "함수 안의 지역 변수에 접근 시도:"
echo "  local_var: ${local_var:-'(접근 불가)'}"
echo "💡 'local'을 사용해 의도치 않은 수정을 방지하는 것이 매우 중요합니다."
pause

# ------------------------------------------------------------
echo "✅  레슨 08 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"