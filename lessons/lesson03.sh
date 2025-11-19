#!/usr/bin/env bash
set -euo pipefail

# 절대 경로 얻기
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# tmp 디렉터리를 스크립트 이름 기반으로 생성
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
mkdir -p "$TMP_DIR"

OUTPUT_FILE="$TMP_DIR/output.txt"
ERROR_FILE="$TMP_DIR/errors.txt"
ALL_OUTPUT_FILE="$TMP_DIR/all_output.txt"
INPUT_FILE="$TMP_DIR/input.txt"

# 초기화: 이전 파일 삭제
rm -f "$OUTPUT_FILE" "$ERROR_FILE" "$ALL_OUTPUT_FILE" "$INPUT_FILE"

echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo

echo "Bash 리다이렉션과 파이프라인"
echo "---------------------------------"
echo "파일 디스크립터:"
echo "  0: 표준 입력 (stdin)"
echo "  1: 표준 출력 (stdout)"
echo "  2: 표준 에러 (stderr)"
echo

# 1. 표준 출력 리다이렉션 (>)
echo "1. 표준 출력 리다이렉션 (>) - 파일에 덮어쓰기"
echo "   'echo \"Hello, World\" > $OUTPUT_FILE' 실행"
echo "Hello, World" > "$OUTPUT_FILE"
echo "   '$OUTPUT_FILE' 내용:"
cat "$OUTPUT_FILE"
echo
echo "   '>'는 파일을 덮어씁니다. 'echo \"Overwritten\" > $OUTPUT_FILE' 실행"
echo "Overwritten" > "$OUTPUT_FILE"
echo "   '$OUTPUT_FILE' 내용:"
cat "$OUTPUT_FILE"
echo "---------------------------------"

# 2. 표준 출력 리다이렉션 (>>)
echo "2. 표준 출력 리다이렉션 (>>) - 파일에 추가하기"
echo "   'echo \"Appended Line\" >> $OUTPUT_FILE' 실행"
echo "Appended Line" >> "$OUTPUT_FILE"
echo "   '$OUTPUT_FILE' 내용:"
cat "$OUTPUT_FILE"
echo "---------------------------------"

# 3. 표준 에러 리다이렉션 (2>)
echo "3. 표준 에러 리다이렉션 (2>)"
echo "   'ls /non_existent_dir 2> $ERROR_FILE' 실행 (에러만 파일로)"
ls /non_existent_dir 2> "$ERROR_FILE" || true # `|| true`는 set -e를 우회하기 위함
echo "   표준 출력은 비어있습니다."
echo "   '$ERROR_FILE' 내용:"
cat "$ERROR_FILE"
echo "---------------------------------"

# 4. 표준 출력과 표준 에러 모두 리다이렉션
echo "4. 표준 출력과 에러 모두 리다이렉션"
echo "   방법 1: '... > file 2>&1' (전통적 방식)"
echo "   'ls -l /non_existent_dir > $ALL_OUTPUT_FILE 2>&1' 실행"
ls -l /non_existent_dir > "$ALL_OUTPUT_FILE" 2>&1 || true
echo "   '$ALL_OUTPUT_FILE' 내용:"
cat "$ALL_OUTPUT_FILE"
echo

echo "   방법 2: '... &> file' (최신 Bash 방식)"
echo "   'ls -l /non_existent_dir &> $ALL_OUTPUT_FILE' 실행 (덮어쓰기)"
ls -l /non_existent_dir &> "$ALL_OUTPUT_FILE" || true
echo "   '$ALL_OUTPUT_FILE' 내용:"
cat "$ALL_OUTPUT_FILE"
echo "---------------------------------"

# 5. 표준 입력 리다이렉션 (<)
echo "5. 표준 입력 리다이렉션 (<)"
echo "   'wc -l' 명령어에 사용할 '$INPUT_FILE' 생성"
echo -e "Line 1\nLine 2\nLine 3" > "$INPUT_FILE"
echo "   'wc -l < $INPUT_FILE' 실행 (파일을 표준 입력으로)"
wc -l < "$INPUT_FILE"
echo "---------------------------------"

# 6. 파이프라인 (|)
echo "6. 파이프라인 (|) - 명령어 출력을 다른 명령어 입력으로"
echo "   'ls -1 $SCRIPT_DIR | grep \"lesson\" | wc -l' 실행"
echo "   결과: $(ls -1 "$SCRIPT_DIR" | grep "lesson" | wc -l) (lesson이 포함된 파일 수)"
echo
echo "   복잡한 예제: 현재 디렉터리 파일 목록을 정렬하여 상위 3개 표시"
echo "   'ls -1 $SCRIPT_DIR | sort -r | head -n 3' 실행"
ls -1 "$SCRIPT_DIR" | sort -r | head -n 3
echo "---------------------------------"

# 7. tee 명령어
echo "7. tee 명령어 - 화면과 파일 동시 출력"
echo "   'echo \"Tee Test\" | tee $OUTPUT_FILE' 실행 (덮어쓰기)"
echo "Tee Test" | tee "$OUTPUT_FILE"
echo
echo "   '$OUTPUT_FILE' 내용:"
cat "$OUTPUT_FILE"
echo

echo "   'tee -a' 옵션으로 추가하기"
echo "   'echo \"Tee Append Test\" | tee -a $OUTPUT_FILE' 실행"
echo "Tee Append Test" | tee -a "$OUTPUT_FILE"
echo
echo "   '$OUTPUT_FILE' 내용:"
cat "$OUTPUT_FILE"
echo "---------------------------------"


echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"