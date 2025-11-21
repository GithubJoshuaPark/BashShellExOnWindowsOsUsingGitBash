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
 레슨 16) 실전 파이프라인: grep | awk | sed
========================================
B

echo "[목표]"
echo "- Unix 철학 '작은 도구들을 조합하여 강력한 기능을 만든다'를 이해한다."
echo "- grep, awk, sed를 파이프라인(|)으로 연결하여 복잡한 텍스트를 단계별로 처리한다."
echo "- 로그 파일에서 의미 있는 정보를 추출하고, 원하는 형식으로 가공하는 실전 예제를 익힌다."
echo

# ------------------------------------------------------------
echo "1️⃣  분석할 샘플 로그 파일 생성"
ACCESS_LOG="$TMP_DIR/access.log"
cat > "$ACCESS_LOG" <<'DATA'
127.0.0.1 - - [10/Oct/2023:10:55:01 +0000] "GET /index.html HTTP/1.1" 200 150
127.0.0.1 - - [10/Oct/2023:10:55:05 +0000] "GET /style.css HTTP/1.1" 200 500
192.168.1.1 - - [10/Oct/2023:10:55:10 +0000] "GET /nonexistent.html HTTP/1.1" 404 230
127.0.0.1 - - [10/Oct/2023:10:55:15 +0000] "POST /api/submit HTTP/1.1" 201 50
192.168.1.2 - - [11/Nov/2023:11:00:25 +0000] "GET /images/logo.png HTTP/1.1" 200 12000
192.168.1.1 - - [11/Nov/2023:11:00:30 +0000] "GET /admin/login.php HTTP/1.1" 404 230
DATA

echo "로그 파일 생성: $ACCESS_LOG"
echo "--------------------------------"
cat "$ACCESS_LOG"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  1단계: grep으로 원하는 라인 필터링하기"
echo "목표: HTTP 상태 코드가 ' 404 '인 라인만 추출한다."
echo "파이프라인의 첫 단계에서는 대량의 데이터에서 필요한 부분만 걸러내는 것이 중요합니다."
echo
echo "실행: grep \" 404 \" \"$ACCESS_LOG\""
grep --color=always " 404 " "$ACCESS_LOG"
f_pause

# ------------------------------------------------------------
echo "3️⃣  2단계: awk로 필요한 필드(열) 추출하기"
echo "목표: grep으로 걸러낸 라인에서 날짜(\$4)와 요청 URL(\$7)만 뽑아낸다."
echo "awk는 열을 다루는 데 가장 강력한 도구입니다."
echo
echo "실행: grep \" 404 \" \"$ACCESS_LOG\" | awk '{print \$4, \$7}'"
grep " 404 " "$ACCESS_LOG" | awk '{print $4, $7}'
f_pause

# ------------------------------------------------------------
echo "4️⃣  3단계: sed로 최종 형식 다듬기"
echo "목표: awk로 추출한 텍스트를 더 읽기 좋은 형식으로 변경한다."
echo " - 날짜에서 대괄호 '[' 제거"
echo " - 날짜와 URL 사이에 'URL: ' 문자열 추가"
echo
echo "실행: ... | sed -E 's/\\[//; s/ / URL: /'"
grep " 404 " "$ACCESS_LOG" | awk '{print $4, $7}' | sed -E 's/\[//; s/ / URL: /'
f_pause

# ------------------------------------------------------------
echo "5️⃣  최종 파이프라인"
echo "위 3단계를 하나의 명령어로 실행하여 최종 리포트를 생성합니다."
echo "이것이 바로 쉘 스크립팅의 파이프라인 철학입니다."
echo
echo "실행: grep \" 404 \" \"$ACCESS_LOG\" | awk '{print \$4, \$7}' | sed -E 's/\\[//; s/ / - URL: /'"
grep " 404 " "$ACCESS_LOG" | awk '{print $4, $7}' | sed -E 's/\[//; s/ / - URL: /'
f_pause

# ------------------------------------------------------------
echo "✅  레슨 16 완료!"
echo "하나의 목적을 가진 작은 도구들을 파이프로 연결하여 복잡한 문제를 해결했습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"