#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
pause() { read -rp "계속하려면 [Enter] 키를 누르세요..." _; echo; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR/logs"

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 10) grep 입문 + 기본 정규표현식(ERE)
========================================
B

echo "[목표]"
echo "- grep의 기본 옵션(-i, -n, -v, -r)을 익힌다."
echo "- 확장 정규표현식(-E)을 사용하여 패턴 매칭을 수행한다."
echo "- 앵커(^, $), 문자 클래스([]) 등 기본 정규식 문법을 이해한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 로그 파일 생성"
LOG_FILE="$TMP_DIR/system.log"
cat > "$LOG_FILE" <<'DATA'
INFO: Server started successfully.
DEBUG: Initializing user-service...
WARNING: Configuration value 'timeout' is deprecated.
INFO: User 'userA' logged in.
ERROR: Connection to database failed. Code: 503.
DEBUG: User 'userB' session created.
info: A minor issue occurred.
ERROR: File not found at /var/log/data.log. Code: 404.
INFO: Server is shutting down.
DATA

echo "로그 파일 생성: $LOG_FILE"
echo "--------------------------------"
nl -ba "$LOG_FILE"
echo "--------------------------------"
pause

# ------------------------------------------------------------
echo "2️⃣  grep 기본 사용법"
echo "--- 특정 문자열 검색 ---"
echo "실행: grep \"ERROR\" \"$LOG_FILE\""
grep "ERROR" "$LOG_FILE" --color=always
pause

echo "--- 대소문자 무시 (-i) ---"
echo "실행: grep -i \"info\" \"$LOG_FILE\""
grep -i "info" "$LOG_FILE" --color=always
pause

echo "--- 결과 반전 (-v) ---"
echo "'DEBUG'가 포함되지 않은 모든 라인 출력"
echo "실행: grep -v \"DEBUG\" \"$LOG_FILE\""
grep -v "DEBUG" "$LOG_FILE"
pause

echo "--- 라인 번호 표시 (-n) ---"
echo "실행: grep -n \"WARNING\" \"$LOG_FILE\""
grep -n "WARNING" "$LOG_FILE" --color=always
pause

# ------------------------------------------------------------
echo "3️⃣  기본 정규표현식 (ERE, Extended Regular Expression)"
echo "'-E' 옵션을 사용하면 더 강력한 패턴 매칭이 가능합니다."
echo

echo "--- 앵커: ^ (라인의 시작), \$ (라인의 끝) ---"
echo "'INFO'로 시작하는 라인:"
echo "실행: grep -E \"^INFO\" \"$LOG_FILE\""
grep -E "^INFO" "$LOG_FILE" --color=always
echo

echo "마침표(.)로 끝나는 라인:"
echo "실행: grep -E \"\.\$\" \"$LOG_FILE\""
grep -E "\.$" "$LOG_FILE" --color=always
pause

echo "--- 문자 클래스: [ ] ---"
echo "A 또는 B가 포함된 사용자 라인:"
echo "실행: grep -E \"user[AB]\" \"$LOG_FILE\""
grep -E "user[AB]" "$LOG_FILE" --color=always
echo

echo "숫자가 포함된 모든 라인:"
echo "실행: grep -E \"[0-9]\" \"$LOG_FILE\""
grep -E "[0-9]" "$LOG_FILE" --color=always
pause

echo "--- OR 연산: | ---"
echo "'ERROR' 또는 'WARNING'이 포함된 라인:"
echo "실행: grep -E \"ERROR|WARNING\" \"$LOG_FILE\""
grep -E "ERROR|WARNING" "$LOG_FILE" --color=always
pause

# ------------------------------------------------------------
echo "4️⃣  실전 예제: 여러 옵션 조합"
echo "목표: 'ERROR'로 시작하는 라인 중, '404' 코드를 가진 라인 찾기"
echo "실행: grep -E \"^ERROR\" \"$LOG_FILE\" | grep -E \"404\""
grep -E "^ERROR" "$LOG_FILE" | grep -E "404" --color=always
pause

# ------------------------------------------------------------
echo "✅  레슨 10 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"