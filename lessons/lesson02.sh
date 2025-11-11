#!/usr/bin/env bash
set -euo pipefail
echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo
pause() { read -rp "계속하려면 엔터를 누르세요..." _; }

cat <<'B'
========================================
 레슨 02) 경로 / 파일 다루기 기초
========================================
B

echo "[목표]"
echo "- pwd, cd, mkdir, touch, rm 명령 사용 익히기"
echo "- 상대/절대 경로와 글로빙(*, ?) 이해하기"
echo

WORK_DIR="/tmp/bash_lesson02"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"
echo "작업 디렉터리 생성 및 이동: $WORK_DIR"
pwd
pause

echo "1) 하위 폴더/파일 생성"
mkdir -p projects/{alpha,beta,gamma}
touch projects/alpha/file1.txt
touch projects/beta/file2.txt
touch projects/gamma/file3.log
tree projects 2>/dev/null || find projects
pause

echo "2) 경로 이동 연습"
cd projects/alpha
echo "현재 경로:"; pwd
echo "cd .. → 상위 디렉터리로 이동"
cd ..
pwd
pause

echo "3) 글로빙(패턴)으로 파일 보기"
echo "   *.txt 파일만:"
ls -1 projects/*/*.txt
echo "   file?.* (file + 한 글자 + 확장자):"
ls -1 projects/*/file?.*
pause

echo "4) grep + 정규식으로 특정 확장자만 필터링"
ls projects/*/* | grep -E '\.log$' || true
pause

echo "5) sed 로 파일명 표시 수정 예시"
ls projects/*/* | sed -E 's#.*/#FILE:#'
pause

echo "6) awk 로 디렉터리 이름만 추출"
ls projects/*/* | awk -F/ '{print "DIR=" $2}'
pause

echo "레슨 02 완료 🎉"

echo "========================"
echo "$(basename "$0") End"
echo "========================"
