#!/usr/bin/env bash
set -euo pipefail
echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo
pause() { read -rp "계속하려면 [Enter] 키를 누르세요..." _; echo; }

cat <<'B'
========================================
 레슨 02) 경로 / 파일 다루기 기초
========================================
B

echo "[목표]"
echo "- pwd, cd, mkdir, touch, rm 등 기본 명령을 익히고"
echo "- 상대경로와 절대경로 개념을 이해하며"
echo "- 글로빙(*, ?), grep/sed/awk, 정규표현식 간단 연습까지 해봅니다."
echo

# 🧭 실습용 작업 디렉터리 생성
WORK_DIR="/tmp/bash_lesson02"
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "▶ 작업 디렉터리: $WORK_DIR"
echo "현재 위치:"; pwd
pause

# ----------------------------------------------------
echo "1) 디렉터리 및 파일 생성"
mkdir -p project/{alpha,beta,gamma}
touch project/alpha/file1.txt
touch project/beta/file2.txt
touch project/gamma/file3.log
touch project/gamma/error_2025.log

echo "생성된 파일:"
find project -type f | sort
pause

# ----------------------------------------------------
echo "2) 경로 이동과 상대경로, 절대경로 비교"
echo "현재 경로: $(pwd)"
echo "cd project/alpha"
cd project/alpha
echo "pwd 결과(상대경로 이동): $(pwd)"
pause

echo "cd ../../project/gamma (상대경로로 이동)"
cd ../../project/gamma
echo "pwd 결과: $(pwd)"
pause

echo "절대경로 이동 예시:"
cd "$WORK_DIR/project/beta"
echo "pwd 결과(절대경로): $(pwd)"
pause

# ----------------------------------------------------
echo "3) 글로빙(와일드카드) 연습"
cd "$WORK_DIR"
echo "   *.txt 파일:"
ls project/*/*.txt
echo "   file?.* (file + 한 글자 + 확장자):"
ls project/*/file?.*
pause

# ----------------------------------------------------
echo "4) grep으로 확장자별 검색"
echo "모든 .log 파일 중 'error' 단어가 포함된 파일만 찾기:"
grep -ril 'error' project || echo "(결과 없음)"
pause

# ----------------------------------------------------
echo "5) sed로 파일명 보기 좋게 변환"
echo "모든 파일 목록에서 경로 제거:"
find project -type f | sed -E 's#.*/#→ #'
pause

# ----------------------------------------------------
echo "6) awk로 디렉터리별 파일 개수 세기"
echo "(find 결과를 awk로 그룹 카운트)"
find project -type f | awk -F/ '{count[$2]++} END {for (dir in count) printf "폴더 %s: %d개 파일\n", dir, count[dir]}' | sort
pause

# ----------------------------------------------------
echo "7) 정규표현식으로 .log 파일명 중 '숫자' 포함만 찾기"
find project -type f | grep -E '[0-9]+\.log$' || echo "(결과 없음)"
pause

# ----------------------------------------------------
echo "8) 실습 정리"
echo "작업 폴더 내용 확인:"
tree project 2>/dev/null || find project
echo
echo "레슨 02 완료 🎉"

echo "========================"
echo "$(basename "$0") End"
echo "========================"
