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
 레슨 05) 변수, 환경, export
========================================
B

echo "[목표]"
echo "- 셸 변수와 환경 변수의 차이를 이해한다."
echo "- 'export' 명령으로 환경 변수를 설정하고 자식 프로세스에 전달한다."
echo "- PATH 변수의 역할과 관리 방법을 익힌다."
echo

# ------------------------------------------------------------
echo "1️⃣  셸 변수 (지역 변수)"
echo "현재 셸에서만 유효한 변수입니다."
LOCAL_VAR="I am local"
echo "변수 설정: LOCAL_VAR=\"$LOCAL_VAR\""
echo "현재 셸에서 확인: echo \$LOCAL_VAR -> $LOCAL_VAR"
echo
echo "새로운 셸(자식 프로세스)에서 확인해보기:"
echo "실행: bash -c 'echo \"Subshell sees: \$LOCAL_VAR\"'"
bash -c 'echo "Subshell sees: $LOCAL_VAR"'
echo "→ 자식 셸에서는 변수가 비어있습니다. 전달되지 않았기 때문입니다."
pause

# ------------------------------------------------------------
echo "2️⃣  환경 변수와 'export'"
echo "'export'는 셸 변수를 환경 변수로 만들어 자식 프로세스에 전달합니다."
export EXPORTED_VAR="I am exported"
echo "변수 설정 및 export: export EXPORTED_VAR=\"$EXPORTED_VAR\""
echo "현재 셸에서 확인: echo \$EXPORTED_VAR -> $EXPORTED_VAR"
echo
echo "새로운 셸(자식 프로세스)에서 다시 확인:"
echo "실행: bash -c 'echo \"Subshell sees: \$EXPORTED_VAR\"'"
bash -c 'echo "Subshell sees: $EXPORTED_VAR"'
echo "→ export된 변수는 자식 셸에서도 접근 가능합니다."
pause

# ------------------------------------------------------------
echo "3️⃣  주요 환경 변수들"
echo "시스템에는 이미 여러 환경 변수가 설정되어 있습니다."
echo "  - \$HOME: 현재 사용자의 홈 디렉터리 -> $HOME"
echo "  - \$USER: 현재 사용자 이름 -> ${USER:-$(whoami)}"
echo "  - \$PWD: 현재 작업 디렉터리 -> $PWD"
echo "  - \$PATH: 명령어 검색 경로 -> $PATH"
echo
echo "'env'나 'printenv' 명령으로 모든 환경 변수를 볼 수 있습니다."
echo "실행: env | grep SHELL"
env | grep SHELL
pause

# ------------------------------------------------------------
echo "4️⃣  일시적인 환경 변수 설정"
echo "특정 명령어에만 임시로 환경 변수를 설정할 수 있습니다."
echo "실행: MY_TEMP_VAR=\"Hi\" env | grep MY_TEMP_VAR"
MY_TEMP_VAR="Hi" env | grep MY_TEMP_VAR
echo
echo "명령 실행 후, 현재 셸에서 확인:"
echo "실행: echo \"\$MY_TEMP_VAR\""
echo "${MY_TEMP_VAR:-'(비어 있음)'}"
echo "→ 현재 셸에는 해당 변수가 설정되지 않았습니다."
pause

# ------------------------------------------------------------
echo "5️⃣  PATH 변수 다루기"
echo "PATH는 셸이 명령어를 찾는 디렉터리 목록입니다."
# 1. 임시 실행 파일 생성
cat > "$TMP_DIR/my_tool" <<'EOF'
#!/usr/bin/env bash
echo "🎉 my_tool이 실행되었습니다!"
EOF
chmod +x "$TMP_DIR/my_tool"
echo "임시 실행 파일 생성: $TMP_DIR/my_tool"
echo

# 2. PATH에 추가 전 실행 시도
echo "PATH 추가 전, 'my_tool' 실행 시도:"
if command -v my_tool &> /dev/null; then
    my_tool
else
    echo "-> 'my_tool'을 찾을 수 없습니다."
fi
echo

# 3. PATH에 임시 디렉터리 추가
echo "PATH에 $TMP_DIR 추가: export PATH=\"$TMP_DIR:\$PATH\""
export PATH="$TMP_DIR:$PATH"
echo "현재 PATH: $PATH"
echo

# 4. PATH 추가 후 실행 시도
echo "PATH 추가 후, 'my_tool' 실행 시도:"
if command -v my_tool &> /dev/null; then
    my_tool
else
    echo "-> 'my_tool'을 찾을 수 없습니다."
fi
pause

# ------------------------------------------------------------
echo "✅  레슨 05 완료!"
echo "이 스크립트가 종료되면 PATH 변경 등은 모두 원래대로 돌아갑니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"