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
 레슨 24) 서브셸 vs 현재 셸
========================================
B

echo "[목표]"
echo "- '현재 셸(Current Shell)'과 '서브셸(Subshell)'의 개념을 이해한다."
echo "- 명령어가 어떤 셸 환경에서 실행되는지 파악한다."
echo "- 서브셸이 부모 셸의 환경에 미치는 영향(또는 미치지 않는 영향)을 확인한다."
echo "- 변수, 현재 디렉토리, 함수 등이 셸 환경에 따라 어떻게 동작하는지 배운다."
echo 

# ------------------------------------------------------------
echo "1️⃣  현재 셸 (Current Shell)"
echo "--- 현재 셸에서 변수 변경 ---"
MY_VAR="Parent"
echo "현재 셸의 MY_VAR: $MY_VAR"
f_pause

echo "--- 현재 셸에서 디렉토리 변경 ---"
echo "현재 디렉토리: $(pwd)"
cd "$TMP_DIR"
echo "변경 후 현재 디렉토리: $(pwd)"
f_pause

# ------------------------------------------------------------
echo "2️⃣  서브셸 (Subshell) 생성 방법"
echo "--- 괄호 '()'를 사용한 서브셸 ---"
echo "괄호 안의 명령은 별도의 프로세스(서브셸)에서 실행됩니다."
echo 
echo "실행: (MY_VAR=\"Subshell\"; echo \"서브셸 안의 MY_VAR: \$MY_VAR\")"
(MY_VAR="Subshell"; echo "서브셸 안의 MY_VAR: $MY_VAR")
echo "서브셸 실행 후 현재 셸의 MY_VAR: $MY_VAR (변화 없음)"
f_pause

echo "실행: (cd /tmp; echo \"서브셸 안의 디렉토리: \$(pwd)\")"
(cd /tmp; echo "서브셸 안의 디렉토리: $(pwd)")
echo "서브셸 실행 후 현재 셸의 디렉토리: $(pwd) (변화 없음)"
f_pause

echo "--- 명령 치환 '\$(command)\' 또는 `` `command` `` ---"
echo "명령 치환도 서브셸에서 실행됩니다."
echo 
echo "실행: RESULT=\$(echo \"Hello from subshell\")\n"
RESULT=$(echo "Hello from subshell")
echo "RESULT 변수 값: $RESULT"
f_pause

echo "--- 파이프라인 '|'의 각 부분 ---"
echo "파이프라인의 각 명령어는 일반적으로 별도의 서브셸에서 실행됩니다."
echo 
echo "실행: echo \"Parent value\" | (read LINE; echo \"Subshell got: \$LINE\")"
echo "Parent value" | (read LINE; echo "Subshell got: $LINE")
f_pause

# ------------------------------------------------------------
echo "3️⃣  스크립트 실행 방식에 따른 셸 환경"
echo "--- 'source' 명령어로 스크립트 실행 (현재 셸에서 실행) ---"
CHILD_SCRIPT="$TMP_DIR/child.sh"
cat > "$CHILD_SCRIPT" <<'CHILD_DATA'
#!/usr/bin/env bash
echo "--- child.sh (source) ---"
echo "child.sh 안의 MY_VAR: $MY_VAR"
MY_VAR="Modified by child (source)"
echo "child.sh 안에서 MY_VAR 변경: $MY_VAR"
CHILD_VAR="Child variable (source)"
echo "child.sh 안의 CHILD_VAR: $CHILD_VAR"
CHILD_DATA

echo "실행 전 현재 셸의 MY_VAR: $MY_VAR"
echo "실행: source \"$CHILD_SCRIPT\""
source "$CHILD_SCRIPT"
echo "실행 후 현재 셸의 MY_VAR: $MY_VAR (변경됨)"
echo "실행 후 현재 셸의 CHILD_VAR: $CHILD_VAR (생성됨)"
f_pause

echo "--- './script.sh'로 스크립트 실행 (서브셸에서 실행) ---"
cat > "$CHILD_SCRIPT" <<'CHILD_DATA'
#!/usr/bin/env bash
echo "--- child.sh (./script.sh) ---"
echo "child.sh 안의 MY_VAR: $MY_VAR"
MY_VAR="Modified by child (subshell)"
echo "child.sh 안에서 MY_VAR 변경: $MY_VAR"
CHILD_VAR="Child variable (subshell)"
echo "child.sh 안의 CHILD_VAR: $CHILD_VAR"
CHILD_DATA

echo "실행 전 현재 셸의 MY_VAR: $MY_VAR"
echo "실행: \"$CHILD_SCRIPT\""
chmod +x "$CHILD_SCRIPT" # 실행 권한 부여
"$CHILD_SCRIPT"
echo "실행 후 현재 셸의 MY_VAR: $MY_VAR (변경 없음)"
echo "실행 후 현재 셸의 CHILD_VAR: $CHILD_VAR (생성되지 않음)"
f_pause

# ------------------------------------------------------------
echo "4️⃣  'export' 명령어로 변수 상속"
echo "'export'된 변수는 서브셸로 상속됩니다."
export EXPORTED_VAR="Exported from parent"
echo "현재 셸의 EXPORTED_VAR: $EXPORTED_VAR"
echo 
echo "실행: (echo \"서브셸 안의 EXPORTED_VAR: \$EXPORTED_VAR\")"
(echo "서브셸 안의 EXPORTED_VAR: $EXPORTED_VAR")
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 24 완료!"
echo "서브셸과 현재 셸의 차이를 이해하는 것은 복잡한 Bash 스크립트를 작성하고 디버깅하는 데 필수적입니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"