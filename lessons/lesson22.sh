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
 레슨 22) 에러처리 & 안전장치
========================================
B

echo "[목표]"
echo "- Bash 스크립트에서 에러를 감지하고 처리하는 방법을 배운다."
echo "- 'set -e', 'set -u', 'set -o pipefail'의 중요성을 이해한다."
echo "- '&&', '||'를 이용한 조건부 실행으로 에러 흐름을 제어한다."
echo "- 'trap' 명령어를 사용하여 스크립트 종료 시 정리 작업을 수행한다."
echo "- 견고하고 안전한 스크립트를 작성하는 습관을 기른다."
echo

# ------------------------------------------------------------
echo "1️⃣  기본 안전장치: set -e, set -u, set -o pipefail"
echo "--- set -e: 에러 발생 시 즉시 스크립트 종료 ---"
echo "이 스크립트 상단에 이미 'set -euo pipefail'이 적용되어 있습니다."
echo "존재하지 않는 명령어를 실행하여 'set -e'의 동작을 확인합니다."
echo
echo "실행: non_existent_command (이 명령어는 실패하고 스크립트가 종료될 것입니다.)"
echo "(스크립트가 종료되지 않도록 '|| true'를 추가하여 에러를 무시합니다.)"
echo
non_existent_command || echo "non_existent_command 실패 (set -e 덕분에 스크립트가 종료될 뻔 했습니다.)"
f_pause

echo "--- set -u: 정의되지 않은 변수 사용 시 에러 발생 및 종료 ---"
echo "정의되지 않은 변수를 사용해봅니다."
echo
echo "실행: echo \"\
oundefined_var\" (스크립트가 종료될 것입니다.)"
echo "(스크립트가 종료되지 않도록 '${UNDEFINED_VAR:-}'와 같이 기본값을 설정합니다.)"
echo "정의되지 않은 변수: ${UNDEFINED_VAR:-'기본값'}"
f_pause

echo "--- set -o pipefail: 파이프라인 중간 명령 실패 시 전체 파이프라인 실패 ---"
echo "존재하지 않는 파일을 cat하여 grep으로 파이프합니다."
echo "set -o pipefail이 없으면 grep이 성공하면 전체 파이프라인이 성공한 것으로 간주됩니다."
echo
echo "실행: cat non_existent_file.txt | grep 'test' (cat이 실패하므로 파이프라인 전체가 실패합니다.)"
cat non_existent_file.txt 2>/dev/null | grep 'test' || echo "파이프라인 실패 (cat 명령 실패)"
f_pause

# ------------------------------------------------------------
echo "2️⃣  조건부 실행: && (AND), || (OR)"
echo "--- &&: 앞 명령이 성공하면 뒤 명령 실행 ---"
echo "실행: mkdir -p \"$TMP_DIR/new_dir\" && echo \"디렉토리 생성 성공\""
mkdir -p "$TMP_DIR/new_dir" && echo "디렉토리 생성 성공"
f_pause

echo "--- ||: 앞 명령이 실패하면 뒤 명령 실행 ---"
echo "실행: rm non_existent_file.txt || echo \"파일 삭제 실패\""
rm non_existent_file.txt || echo "파일 삭제 실패"
f_pause

# ------------------------------------------------------------
echo "3️⃣  trap 명령어: 시그널 처리 및 정리 작업"
echo "--- trap 'cleanup_function' EXIT: 스크립트 종료 시 항상 실행 ---"
cleanup_function() {
    echo "--- cleanup_function 실행 중 ---"
    rm -rf "$TMP_DIR/temp_file.txt"
    echo "임시 파일 정리 완료."
}
trap 'cleanup_function' EXIT

echo "임시 파일 생성: $TMP_DIR/temp_file.txt"
touch "$TMP_DIR/temp_file.txt"
ls "$TMP_DIR"
f_pause

echo "--- trap 'error_handler' ERR: 명령 실패 시 실행 ---"
error_handler() {
    echo "--- 에러 발생! 라인: $BASH_LINENO ---"
    echo "스크립트가 비정상적으로 종료됩니다."
    exit 1 # 에러 핸들러에서 종료
}
trap 'error_handler' ERR # 이 예제에서는 스크립트 종료를 막기 위해 주석 처리

echo "에러 핸들러 테스트 (주석 처리된 trap ERR 활성화 시 동작)"
echo "실행: cp non_existent_source.txt non_existent_dest.txt"
cp non_existent_source.txt non_existent_dest.txt 2>/dev/null || echo "cp 명령 실패 (trap ERR 활성화 시 error_handler 실행)"
f_pause

# ------------------------------------------------------------
echo "4️⃣  함수를 이용한 에러 처리"
execute_command() {
    local cmd="$@"
    echo "실행: $cmd"
    if ! eval "$cmd"; then
        echo "오류: '$cmd' 명령 실행 실패!"
        return 1 # 함수 실패 반환
    fi
    return 0 # 함수 성공 반환
}

echo "--- 성공하는 명령 실행 ---"
execute_command "ls \"$TMP_DIR\""
f_pause

echo "--- 실패하는 명령 실행 ---"
execute_command "cp non_existent_file.txt /dev/null" # 실패 예상 (non_existent_file.txt 없음), error_handler 호출
f_pause

# 테스트용 데이터 삭제 여부
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 22 완료!"
echo "견고한 스크립트 작성을 위한 에러 처리 및 안전장치 사용법을 익혔습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"