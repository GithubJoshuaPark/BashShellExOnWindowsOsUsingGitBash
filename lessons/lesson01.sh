#!/usr/bin/env bash
set -euo pipefail
echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"

# ▣ [2] 실행 중인 스크립트 경로 계산
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "▶ 스크립트 디렉터리: $SCRIPT_DIR"
# tmp 디렉터리를 스크립트 이름 기반으로 생성
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
mkdir -p "$TMP_DIR"

source "$SCRIPT_DIR/utils.sh"

cat <<'B'
========================================
 레슨 01) 쉘 기본기 리프레시
========================================
B

echo "[목표]"
echo "- 현재 사용 중인 셸과 명령의 종류(type/which)를 이해한다."
echo "- 간단한 grep/sed/awk 맛보기를 해본다."
echo

echo "1) 현재 셸 확인:"
echo "   echo \$SHELL"
echo "결과:"
echo "$SHELL"
f_pause

echo "2) 명령의 종류 구분(type, which):"
type echo
type grep
which bash
f_pause

echo "3) 도움말/매뉴얼 확인:"
# OS 종류에 따라 다른 명령 실행
if [[ "$(uname)" == "Darwin" ]]; then # Darwin은 macOS의 커널 이름입니다.
  echo "macOS detected: $(uname)"
  man grep | head -5
else
  echo "Linux detected: $(uname)"
  grep --help | head -n 5
fi
echo "(* man grep 은 인터랙티브 화면이라 생략)"
f_pause

TMP_FILE="$TMP_DIR/tmp.txt"
cat > "$TMP_FILE" <<'DATA'
Error: E100 at module A
WARN: something odd
INFO: start
Error: E200 at module B
INFO: done
DATA
echo "테스트용 데이터 생성: $TMP_FILE"
nl -ba "$TMP_FILE"
f_pause

echo "[grep] ERROR 라인만 추출:"
grep -nE '^Error:' "$TMP_FILE" --color=always
f_pause

echo "[sed] WARN -> WARNING 으로 바꾸기:"
sed -E 's/^WARN:/WARNING:/' "$TMP_FILE"
f_pause

echo "[awk] 라벨별 카운트 요약:"
awk '
  BEGIN {E=0;W=0;I=0}
  /^Error:/ {E++}
  /^WARN:/  {W++}
  /^INFO:/  {I++}
  END {printf("ERROR=%d WARN=%d INFO=%d\n",E,W,I)}
' "$TMP_FILE"
f_pause

echo "레슨 01 완료 🎉"


echo "========================"
echo "$(basename "$0") End"
echo "========================"
