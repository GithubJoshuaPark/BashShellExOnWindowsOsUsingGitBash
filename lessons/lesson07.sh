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
 레슨 07) 반복문 & 배열
========================================
B

echo "[목표]"
echo "- 배열을 선언하고, 원소를 추가/접근하는 방법을 익힌다."
echo "- for, while, until 반복문의 사용법을 이해한다."
echo "- break와 continue로 반복 흐름을 제어한다."
echo

# ------------------------------------------------------------
echo "1️⃣  배열(Array) 다루기"
# 배열 선언
FRUITS=("Apple" "Banana" "Cherry" "Grape Fruit")
echo "배열 선언: FRUITS=(\"Apple\" \"Banana\" \"Cherry\" \"Grape Fruit\")"
echo

# 원소 접근
echo "첫 번째 원소: \${FRUITS[0]} -> ${FRUITS[0]}"
echo "세 번째 원소: \${FRUITS[2]} -> ${FRUITS[2]}"
echo

# 전체 원소 접근
echo "전체 원소: \${FRUITS[@]} -> ${FRUITS[@]}"
echo "💡 큰따옴표와 함께 \"\${FRUITS[@]}\"로 사용해야 공백이 포함된 원소도 안전하게 처리됩니다."
echo

# 배열 길이
echo "배열 길이: \${#FRUITS[@]} -> ${#FRUITS[@]}"
echo

# 원소 추가
FRUITS+=("Mango")
echo "원소 추가 후: FRUITS+=(\"Mango\")"
echo "전체 원소: ${FRUITS[@]}"
f_pause

# ------------------------------------------------------------
echo "2️⃣  for 반복문"
echo "가장 일반적인 반복문으로, 목록의 모든 항목에 대해 코드를 실행합니다."
echo
echo "--- 기본 for문 ---"
for fruit in "${FRUITS[@]}"; do
  echo "  I like $fruit"
done
f_pause

echo "--- C 스타일 for문 ---"
count=${#FRUITS[@]}
for (( i=0; i < count; i++ )); do
  echo "  - Index $i: ${FRUITS[i]}"
done
f_pause

echo "--- 시퀀스(범위) 사용 ---"
for i in {1..5}; do
  echo "  Number: $i"
done
f_pause

# ------------------------------------------------------------
echo "3️⃣  while 반복문"
echo "조건이 참(true)인 동안 계속 실행됩니다."
echo
counter=1
while [[ $counter -le 5 ]]; do
  echo "  while counter: $counter"
  ((counter++)) # 카운터 증가
done
f_pause

echo "--- 파일을 한 줄씩 읽기 (매우 유용한 패턴) ---"
# 테스트 파일 생성
echo -e "first line\nsecond line\nlast line" > "$TMP_DIR/lines.txt"
echo "파일 내용:"
cat "$TMP_DIR/lines.txt"
echo
echo "읽기 시작:"
while read -r line; do
  echo "  Read line: '$line'"
done < "$TMP_DIR/lines.txt"
f_pause

# ------------------------------------------------------------
echo "4️⃣  until 반복문"
echo "조건이 참(true)이 될 때까지 계속 실행됩니다 (while과 반대)."
echo
until_counter=1
until [[ $until_counter -gt 5 ]]; do
  echo "  until counter: $until_counter"
  ((until_counter++))
done
f_pause

# ------------------------------------------------------------
echo "5️⃣  반복문 제어 (break, continue)"
echo "--- break: 반복을 즉시 중단 ---"
for i in {1..10}; do
  if [[ $i -eq 5 ]]; then
    echo "  -> 5에서 break!"
    break
  fi
  echo "  Number: $i"
done
f_pause

echo "--- continue: 현재 반복을 건너뛰고 다음으로 진행 ---"
for i in {1..5}; do
  if [[ $i -eq 3 ]]; then
    echo "  -> 3에서 continue! (출력 안 함)"
    continue
  fi
  echo "  Number: $i"
done
f_pause

# ------------------------------------------------------------
echo "✅  레슨 07 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"