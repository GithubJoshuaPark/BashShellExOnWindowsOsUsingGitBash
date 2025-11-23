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
=================================
 레슨 19) find & xargs & -exec
=================================
B

echo "[목표]"
echo "- 'find' 명령어를 사용하여 다양한 조건으로 파일을 검색한다."
echo "- 'find -exec' 옵션을 사용하여 검색된 파일에 대해 명령을 실행한다."
echo "- 'xargs' 명령어를 사용하여 'find' 결과를 효율적으로 다른 명령에 전달한다."
echo "- 파일 이름에 공백이나 특수 문자가 포함된 경우를 안전하게 처리하는 방법을 배운다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 파일 시스템 구조 생성"
mkdir -p "$TMP_DIR/docs" "$TMP_DIR/logs" "$TMP_DIR/scripts" "$TMP_DIR/data" "$TMP_DIR/temp_files"

touch "$TMP_DIR/docs/report.txt"
touch "$TMP_DIR/docs/old_notes.txt"
touch -d "2 weeks ago" "$TMP_DIR/docs/old_notes.txt" # 2주 전 파일로 설정

echo "This is an application log." > "$TMP_DIR/logs/app.log"
echo "ERROR: Something went wrong." > "$TMP_DIR/logs/error.log"

echo "#!/bin/bash" > "$TMP_DIR/scripts/backup.sh"
echo "#!/bin/bash" > "$TMP_DIR/scripts/cleanup.sh"

dd if=/dev/zero of="$TMP_DIR/data/large_file.bin" bs=1M count=2 > /dev/null 2>&1 # 2MB 파일 생성
touch "$TMP_DIR/data/empty_file.txt"

touch "$TMP_DIR/temp_files/temp1.tmp"
touch "$TMP_DIR/temp_files/temp2.tmp"
touch "$TMP_DIR/important file with spaces.txt"

echo "생성된 파일 시스템 구조:"
echo "--------------------------------"
ls -R "$TMP_DIR"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  find 기본 사용법"
echo "--- 현재 디렉토리에서 모든 .txt 파일 찾기 ---"
echo "실행: find \"$TMP_DIR\" -name \"*.txt\""
find "$TMP_DIR" -name "*.txt"
f_pause

echo "--- 현재 디렉토리에서 1주일보다 오래된 파일 찾기 (-mtime +7) ---"
echo "실행: find \"$TMP_DIR\" -type f -mtime +7"
find "$TMP_DIR" -type f -mtime +7
f_pause

echo "--- 1MB보다 큰 파일 찾기 (-size +1M) ---"
echo "실행: find \"$TMP_DIR\" -type f -size +1M"
find "$TMP_DIR" -type f -size +1M
f_pause

echo "--- 비어있는 파일 또는 디렉토리 찾기 (-empty) ---"
echo "실행: find \"$TMP_DIR\" -empty"
find "$TMP_DIR" -empty
f_pause

# ------------------------------------------------------------
echo "3️⃣  find -exec: 검색된 파일에 대해 명령 실행"
echo "--- .log 파일을 .log.bak으로 복사하기 ---"
echo "실행: find \"$TMP_DIR\" -name \"*.log\" -exec cp {} {}.bak \;"
find "$TMP_DIR" -name "*.log" -exec cp {} {}.bak \;
echo "복사 후 logs 디렉토리 내용:"
ls "$TMP_DIR/logs"
f_pause

echo "--- .tmp 파일을 삭제하기 ---"
echo "실행: find \"$TMP_DIR/temp_files\" -name \"*.tmp\" -exec rm {} \;"
find "$TMP_DIR/temp_files" -name "*.tmp" -exec rm {} \;
echo "삭제 후 temp_files 디렉토리 내용:"
ls "$TMP_DIR/temp_files" || echo "(비어있음)"
f_pause

# ------------------------------------------------------------
echo "4️⃣  xargs: find 결과를 효율적으로 전달"
echo "find -exec는 검색된 파일마다 명령을 한 번씩 실행하지만, xargs는 여러 파일을 묶어 한 번에 명령을 실행할 수 있어 효율적입니다."
echo "--- 파일 이름에 공백이 있는 경우 안전하게 처리 (-print0 | xargs -0) ---"
echo "목표: 모든 .txt 파일의 내용을 출력 (공백 포함 파일명 처리)"
echo "실행: find \"$TMP_DIR\" -name \"*.txt\" -print0 | xargs -0 cat"
find "$TMP_DIR" -name "*.txt" -print0 | xargs -0 cat
f_pause

echo "--- .sh 스크립트 파일에 실행 권한 부여하기 ---"
echo "실행: find \"$TMP_DIR/scripts\" -name \"*.sh\" -print0 | xargs -0 chmod +x"
find "$TMP_DIR/scripts" -name "*.sh" -print0 | xargs -0 chmod +x
echo "권한 변경 후 scripts 디렉토리 내용:"
ls -l "$TMP_DIR/scripts"
f_pause

# ------------------------------------------------------------
echo "✅  레슨 19 완료!"
echo "'find', 'xargs', '-exec'를 조합하여 파일 시스템을 효과적으로 관리하는 방법을 익혔습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"