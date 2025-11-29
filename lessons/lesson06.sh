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
 레슨 06) 조건식 & 테스트
========================================
B

echo "[목표]"
echo "- if/elif/else 구조와 종료 코드(\$?)의 관계를 이해한다."
echo "- 파일(-f, -d), 문자열(=, -z), 숫자(-eq, -gt) 테스트 방법을 익힌다."
echo "- [ ] (test)와 [[ ]] (확장 테스트)의 차이점을 안다."
echo

# ------------------------------------------------------------
echo "1️⃣  if문의 기본 구조와 종료 코드"
echo "'if'문은 명령어의 '종료 코드(Exit Code)'가 0인지 확인합니다."
echo "  - 0: 성공 (True)"
echo "  - 0이 아닌 값: 실패 (False)"
echo
echo "명령어 'true'의 종료 코드 확인:"
true
echo "  -> \$? = $?"
echo
echo "명령어 'false'의 종료 코드 확인:"
false || true # set -e 때문에 || true 추가
echo "  -> \$? = $?"
echo
echo "if true; then ... fi"
if true; then
  echo "  -> 'true'는 성공(0)이므로 이 문장이 출력됩니다."
fi
f_pause

# ------------------------------------------------------------
echo "2️⃣  파일 테스트"
# 테스트용 파일 및 디렉터리 생성
touch "$TMP_DIR/file.txt"
mkdir "$TMP_DIR/dir"
echo "Hello" > "$TMP_DIR/non_empty.txt"
touch "$TMP_DIR/empty.txt"

echo "테스트용 파일/디렉터리 생성:"
echo "  - $TMP_DIR/file.txt"
echo "  - $TMP_DIR/dir/"
echo "  - $TMP_DIR/non_empty.txt"
echo "  - $TMP_DIR/empty.txt"
echo

# -e: 존재하는가?
if [ -e "$TMP_DIR/file.txt" ]; then
  echo "✅ [ -e \"$TMP_DIR/file.txt\" ] : 파일이 존재합니다."
fi
# -f: 일반 파일인가?
if [ -f "$TMP_DIR/file.txt" ]; then
  echo "✅ [ -f \"$TMP_DIR/file.txt\" ] : 일반 파일입니다."
fi
# -d: 디렉터리인가?
if [ -d "$TMP_DIR/dir" ]; then
  echo "✅ [ -d \"$TMP_DIR/dir\" ] : 디렉터리입니다."
fi
# -s: 파일 크기가 0보다 큰가? (비어있지 않은가?)
if [ -s "$TMP_DIR/non_empty.txt" ]; then
  echo "✅ [ -s \"$TMP_DIR/non_empty.txt\" ] : 파일이 비어있지 않습니다."
fi
if [ ! -s "$TMP_DIR/empty.txt" ]; then
  echo "✅ [ ! -s \"$TMP_DIR/empty.txt\" ] : 파일이 비어있습니다. (!는 부정)"
fi
f_pause

# ------------------------------------------------------------
echo "3️⃣  문자열 테스트"
VAR1="hello"
VAR2="world"
EMPTY_VAR=""

# =: 두 문자열이 같은가?
if [ "$VAR1" = "hello" ]; then
  echo "✅ [ \"$VAR1\" = \"hello\" ] : 두 문자열은 같습니다."
fi
# !=: 두 문자열이 다른가?
if [ "$VAR1" != "$VAR2" ]; then
  echo "✅ [ \"$VAR1\" != \"$VAR2\" ] : 두 문자열은 다릅니다."
fi
# -z: 문자열이 비어있는가? (Zero length)
if [ -z "$EMPTY_VAR" ]; then
  echo "✅ [ -z \"$EMPTY_VAR\" ] : 문자열이 비어있습니다."
fi
# -n: 문자열이 비어있지 않은가? (Non-zero length)
if [ -n "$VAR1" ]; then
  echo "✅ [ -n \"$VAR1\" ] : 문자열이 비어있지 않습니다."
fi
echo "💡 변수를 항상 큰따옴표로 감싸는 습관이 중요합니다!"
f_pause

# ------------------------------------------------------------
echo "4️⃣  정수 테스트"
NUM1=10
NUM2=5

# -eq: 같은가? (EQual)
if [ "$NUM1" -eq 10 ]; then
  echo "✅ [ \"$NUM1\" -eq 10 ] : 숫자가 같습니다."
fi
# -ne: 다른가? (Not Equal)
if [ "$NUM1" -ne "$NUM2" ]; then
  echo "✅ [ \"$NUM1\" -ne \"$NUM2\" ] : 숫자가 다릅니다."
fi
# -gt: 큰가? (Greater Than)
if [ "$NUM1" -gt "$NUM2" ]; then
  echo "✅ [ \"$NUM1\" -gt \"$NUM2\" ] : 10은 5보다 큽니다."
fi
# -lt: 작은가? (Less Than)
if [ "$NUM2" -lt "$NUM1" ]; then
  echo "✅ [ \"$NUM2\" -lt \"$NUM1\" ] : 5는 10보다 작습니다."
fi
# -ge: 크거나 같은가? (Greater or Equal)
# -le: 작거나 같은가? (Less or Equal)
f_pause

# ------------------------------------------------------------
echo "5️⃣  [ ] vs [[ ]]"
echo "[ ] (test 명령어)는 오래된 표준이며, [[ ]]는 Bash의 확장 기능입니다."
echo "[[ ]]의 장점:"
echo "  - 단어 분할(word splitting)과 경로명 확장을 하지 않아 더 안전합니다."
echo "  - &&, ||, <, > 같은 연산자를 직접 사용할 수 있습니다."
echo "  - 정규표현식 매칭( =~ )과 패턴 매칭( == )을 지원합니다."
echo
FILENAME="test.log"
# 패턴 매칭
if [[ "$FILENAME" == *.log ]]; then
  echo "✅ [[ \"$FILENAME\" == *.log ]] : 파일 이름이 .log로 끝납니다. (패턴 매칭)"
fi
# 논리 연산
if [[ "$NUM1" -gt 5 && "$NUM2" -lt 10 ]]; then
  echo "✅ [[ \"$NUM1\" -gt 5 && \"$NUM2\" -lt 10 ]] : 두 조건 모두 참입니다. (논리 연산)"
fi
# 정규표현식 매칭
VERSION="v1.2.3"
if [[ "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "✅ [[ \"$VERSION\" =~ ... ]] : 버전 문자열 형식이 맞습니다. (정규표현식)"
fi
echo "💡 특별한 호환성이 필요한 경우가 아니면 [[ ]] 사용을 권장합니다."
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 06 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"