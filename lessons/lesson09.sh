#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"
source "$SCRIPT_DIR/utils.sh"

echo "========================"
echo "$(basename "$0") Start"
echo "========================"

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 09) 실전: 배치 리네이밍 스크립트
========================================
B

echo "[목표]"
echo "- 여러 파일의 이름을 일괄적으로 변경하는 스크립트를 작성한다."
echo "- 'dry run'과 사용자 확인 등 안전장치를 추가하는 방법을 익힌다."
echo "- for 반복문, 조건문, 문자열 치환을 실전적으로 활용한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 파일 생성"
# 스크립트가 실행될 때마다 깨끗한 환경을 제공하기 위해
# 임시 디렉터리에 테스트 파일을 생성합니다.
TARGET_DIR="$TMP_DIR/rename_practice"
mkdir -p "$TARGET_DIR"

touch "$TARGET_DIR/report-2023-01.txt"
touch "$TARGET_DIR/report-2023-02.txt"
touch "$TARGET_DIR/image_final.jpg"
touch "$TARGET_DIR/summary.docx"
touch "$TARGET_DIR/file with spaces.txt"

echo "다음 파일들이 생성되었습니다:"
ls -1 "$TARGET_DIR"
f_pause

# ------------------------------------------------------------
echo "2️⃣  Dry Run: 변경될 이름 미리보기"
echo "실제로 파일을 변경하기 전에, 어떻게 바뀔지 먼저 확인합니다."
echo "목표: '.txt' 확장자를 가진 파일 이름에 '_final'을 추가합니다."
echo "      (예: report.txt -> report_final.txt)"
echo

# `-P` 옵션은 심볼릭 링크의 경우 원본 경로를 보여주지 않게 합니다. (여기선 큰 의미 없음)
# `find` 명령어는 공백 등 특수문자가 포함된 파일 이름을 안전하게 처리합니다.
# `while read -r file` 구문은 find의 출력을 한 줄씩 안전하게 읽습니다.
find "$TARGET_DIR" -type f -name "*.txt" | while read -r file; do
  # Parameter Expansion: ${VAR%PATTERN} -> 뒤에서부터 가장 짧게 일치하는 PATTERN 제거
  # 'file' 변수에서 '.txt'를 제거합니다.
  basename="${file%.txt}"

  # 새로운 파일 이름 생성
  new_name="${basename}_final.txt"

  echo "  - [변경 전] $(basename "$file")"
  echo "  - [변경 후] $(basename "$new_name")"
  echo
done
f_pause

# ------------------------------------------------------------
echo "3️⃣  사용자 확인 및 실제 변경 실행"
read -p "위와 같이 변경을 진행할까요? (yes/no): " answer

# 사용자의 답변이 'yes'가 아니면 스크립트를 종료합니다.
if [[ "$answer" != "yes" ]]; then
  echo "작업을 취소했습니다."
  echo
else
  echo
  echo "파일 이름 변경을 시작합니다..."
  find "$TARGET_DIR" -type f -name "*.txt" | while read -r file; do
    basename="${file%.txt}"
    new_name="${basename}_final.txt"

    # mv 명령어 실행
    # 변수를 큰따옴표로 감싸 공백이 포함된 파일 이름도 안전하게 처리
    mv "$file" "$new_name"
    echo "  - 완료: $(basename "$new_name")"
  done
fi

f_pause

# ------------------------------------------------------------
echo "4️⃣  최종 결과 확인"
echo "작업 완료 후 디렉터리 상태:"
ls -1 "$TARGET_DIR"
echo
echo "'.txt' 파일들의 이름이 성공적으로 변경되었습니다."
f_pause

# ------------------------------------------------------------
echo "✅  레슨 09 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"