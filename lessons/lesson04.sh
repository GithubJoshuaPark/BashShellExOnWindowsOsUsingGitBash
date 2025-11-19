#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
pause() { read -rp "계속하려면 [Enter] 키를 누르세요..." _; echo; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 04) 따옴표 & 확장 규칙 완전정복
========================================
B

echo "[목표]"
echo "- 작은따옴표(''), 큰따옴표(\"\"), 백슬래시(\\)의 차이를 이해한다."
echo "- 변수, 명령어, 산술, 브레이스 확장의 규칙을 익힌다."
echo

# ------------------------------------------------------------
echo "1️⃣  변수 설정 및 기본 확장"
MY_VAR="Hello, Bash"
echo "변수 설정: MY_VAR=\"$MY_VAR\""
echo "기본 확장: echo \$MY_VAR -> $MY_VAR"
pause

# ------------------------------------------------------------
echo "2️⃣  작은따옴표('') - 모든 확장을 억제"
echo "작은따옴표는 모든 문자를 있는 그대로(literal) 취급합니다."
echo "실행: echo '변수: \$MY_VAR, 실행: \$(pwd)'"
echo "결과: '변수: \$MY_VAR, 실행: \$(pwd)'"
pause

# ------------------------------------------------------------
echo "3️⃣  큰따옴표(\"\") - 변수, 명령어, 산술 확장 허용"
echo "큰따옴표는 \$, \`, \\ 문자를 제외한 모든 것을 리터럴로 취급합니다."
echo "실행: echo \"변수: \$MY_VAR, 실행: \$(pwd)\""
echo "결과: \"변수: $MY_VAR, 실행: $(pwd)\""
echo
echo "💡 중요: 단어 분할(Word Splitting) 방지"
SPACY_VAR="하나 둘 셋"
echo "따옴표 없이 출력: echo \$SPACY_VAR"
# shellcheck disable=SC2086
echo $SPACY_VAR
echo "→ 각 단어가 별개의 인자로 취급됨"
echo
echo "큰따옴표로 출력: echo \"\$SPACY_VAR\""
echo "$SPACY_VAR"
echo "→ 전체가 하나의 인자로 취급됨 (권장!)"
pause

# ------------------------------------------------------------
echo "4️⃣  백슬래시(\\) - 단일 문자 이스케이프"
echo "특정 문자의 특별한 의미를 제거합니다."
echo "실행: echo \"큰따옴표(\\\")를 출력하고 싶어요.\""
echo "결과: \"큰따옴표(\")를 출력하고 싶어요.\""
pause

# ------------------------------------------------------------
echo "5️⃣  명령어 치환(Command Substitution)"
echo "명령어의 실행 결과를 문자열로 사용합니다."
echo "최신 방식: \$(...)"
echo "실행: echo \"현재 디렉터리에는 \$(ls | wc -l)개의 파일/폴더가 있습니다.\""
echo "결과: \"현재 디렉터리에는 $(ls | wc -l)개의 파일/폴더가 있습니다.\""
echo
echo "구식 방식: \`...\` (백틱)"
echo "실행: echo \"현재 사용자는 \`whoami\` 입니다.\""
# shellcheck disable=SC2046
echo "결과: \"현재 사용자는 `whoami` 입니다.\""
echo "💡 \`...\`는 중첩이 어렵고 가독성이 떨어져 \$(...) 사용이 권장됩니다."
pause

# ------------------------------------------------------------
echo "6️⃣  산술 확장(Arithmetic Expansion)"
echo "정수 연산을 수행하고 결과를 반환합니다."
X=10
Y=5
echo "실행: echo \"$X + $Y = \$((X + Y))\""
echo "결과: \"$X + $Y = $((X + Y))\""
pause

# ------------------------------------------------------------
echo "7️⃣  브레이스 확장(Brace Expansion)"
echo "쉼표로 구분된 문자열이나 범위로 시퀀스를 생성합니다."
echo "실행: echo file_{a,b,c}.txt"
echo "결과: file_{a,b,c}.txt"
echo
echo "실행: touch $TMP_DIR/log_{2023,2024,2025}.txt"
touch $TMP_DIR/log_{2023,2024,2025}.txt
echo "$TMP_DIR 내용:"
ls "$TMP_DIR"
echo
echo "조합도 가능합니다."
echo "실행: echo {A,B}{1,2}"
echo "결과: {A,B}{1,2}"
pause

# ------------------------------------------------------------
echo "✅  레슨 04 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"