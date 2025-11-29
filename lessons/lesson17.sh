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
 레슨 17) 정규표현식 집중 연습(1): 이메일/URL 패턴
========================================
B

echo "[목표]"
echo "- 이메일 주소 패턴을 이해하고 정규표현식으로 매칭한다."
echo "- URL 패턴을 이해하고 정규표현식으로 매칭한다."
echo "- grep -o 옵션을 사용하여 매칭된 부분만 추출한다."
echo "- 정규표현식의 복잡성과 실용적인 접근법을 이해한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 데이터 파일 생성"
DATA_FILE="$TMP_DIR/mixed_data.txt"
cat > "$DATA_FILE" <<'DATA'
Contact us at info@example.com or support@my-company.co.uk.
Visit our website at https://www.example.com/path/to/page?id=123#section.
Also check http://blog.example.org.
Invalid emails: user@.com, .user@domain.com, user@domain, user@domain..com
Invalid URLs: http://.com, ftp://user:pass@host:port/path
Another email: test.user+alias@sub.domain.net
Another URL: www.google.com (should not match without scheme for strict regex)
File path: /usr/local/bin/script.sh
DATA

echo "데이터 파일 생성: $DATA_FILE"
echo "--------------------------------"
nl -ba "$DATA_FILE"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  이메일 주소 패턴 매칭 및 추출"
echo "--- 이메일 정규표현식 설명 ---"
echo " - [a-zA-Z0-9._%+-]+ : 사용자 이름 (알파벳, 숫자, 특수문자 허용)"
echo " - @ : 앳(@) 기호"
echo " - [a-zA-Z0-9.-]+ : 도메인 이름 (알파벳, 숫자, 하이픈, 점 허용)"
echo " - \\.: 점(.) (이스케이프 필요)"
echo " - [a-zA-Z]{2,6} : 최상위 도메인 (2~6자 알파벳)"
echo
echo "실행: grep -E -o '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}' \"$DATA_FILE\""
grep -E -o '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}' "$DATA_FILE"
f_pause

# ------------------------------------------------------------
echo "3️⃣  URL 패턴 매칭 및 추출"
echo "--- URL 정규표현식 설명 (간소화된 버전) ---"
echo " - (https?|ftp):// : 프로토콜 (http, https, ftp 중 하나)"
echo " - [a-zA-Z0-9.-]+ : 호스트 이름"
echo " - (/[]a-zA-Z0-9._~:/?#\\[@ !$&()*+,;=-]*)? : 경로, 쿼리, 프래그먼트 (선택 사항)"
echo "   (URL 정규표현식은 매우 복잡하며, 여기서는 일반적인 경우를 다룹니다.)"
echo
echo "실행: grep -E -o '(https?|ftp)://[a-zA-Z0-9.-]+(/[]a-zA-Z0-9._~:/?#\\[@ !$&()*+,;=-]*)' \"$DATA_FILE\""
grep -E -o '(https?|ftp)://[a-zA-Z0-9.-]+(/[]a-zA-Z0-9._~:/?#\[@!$&()*+,;=-]*)' "$DATA_FILE"
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 17 완료!"
echo "정규표현식은 복잡한 패턴을 다루는 강력한 도구이지만, 완벽한 매칭은 어려울 수 있습니다."
echo "실용적인 수준에서 필요한 패턴을 정확히 찾아내는 연습이 중요합니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"