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
 레슨 14) awk 입문: 필드 처리
========================================
B

echo "[목표]"
echo "- awk가 텍스트를 '레코드(행)'와 '필드(열)'로 어떻게 처리하는지 이해한다."
echo "- '\$0', '\$1', '\$2' 등 필드 변수를 사용하여 특정 열을 출력한다."
echo "- '-F' 옵션으로 필드 구분자를 지정하는 방법을 배운다."
echo "- 내장 변수 'NR'(행 번호)과 'NF'(필드 개수)를 사용한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 데이터 파일 생성"
DATA_FILE="$TMP_DIR/passwd.txt"
cat > "$DATA_FILE" <<'DATA'
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
user:x:1000:1000:Default User:/home/user:/bin/bash
ftp:x:14:50:FTP User:/srv/ftp:/usr/sbin/nologin
DATA

echo "데이터 파일 생성: $DATA_FILE"
echo "--------------------------------"
nl -ba "$DATA_FILE"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  awk 기본 사용법: 필드 출력"
echo "awk는 기본적으로 공백(스페이스, 탭)으로 필드를 구분합니다."
echo "하지만 이 파일은 공백이 없으므로, \$0은 전체 라인을 의미합니다."
echo
echo "실행: awk '{print \$0}' \"$DATA_FILE\""
awk '{print $0}' "$DATA_FILE"
f_pause

# ------------------------------------------------------------
echo "3️⃣  필드 구분자 지정 (-F 옵션)"
echo "'-F' 옵션을 사용하면 콜론(:) 같은 문자를 필드 구분자로 지정할 수 있습니다."
echo "사용자 이름(\$1)과 홈 디렉터리(\$6)를 출력해봅시다."
echo
echo "실행: awk -F':' '{print \$1, \$6}' \"$DATA_FILE\""
awk -F':' '{print $1, $6}' "$DATA_FILE"
f_pause

echo "--- 출력 형식 지정하기 ---"
echo "print 문 안에서 문자열과 필드를 조합하여 원하는 형식으로 출력할 수 있습니다."
echo
echo "실행: awk -F':' '{print \"User:\", \$1, \"Home:\", \$6}' \"$DATA_FILE\""
awk -F':' '{print "User:", $1, "Home:", $6}' "$DATA_FILE"
f_pause

# ------------------------------------------------------------
echo "4️⃣  내장 변수: NR, NF"
echo "- NR: 현재 처리 중인 라인(레코드)의 번호"
echo "- NF: 현재 라인의 총 필드 개수"
echo
echo "각 라인의 번호(NR), 총 필드 수(NF), 그리고 전체 라인(\$0)을 출력합니다."
echo
echo "실행: awk -F':' '{print \"Line\", NR, \"has\", NF, \"fields:\", \$0}' \"$DATA_FILE\""
awk -F':' '{print "Line", NR, "has", NF, "fields:", $0}' "$DATA_FILE"
f_pause

# ------------------------------------------------------------
echo "5️⃣  실전 예제: 사용자 정보 리포트"
echo "목표: 사용자 이름, UID, GID, 셸 정보를 보기 좋게 출력하기"
echo " - 사용자: \$1"
echo " - UID: \$3"
echo " - GID: \$4"
echo " - Shell: \$7"
echo
echo "실행: awk -F':' '{print \"User:\", \$1, \"(UID=\", \$3, \", GID=\", \$4, \") | Shell:\", \$7}' \"$DATA_FILE\""
awk -F':' '{print "User: " $1 " (UID=" $3 ", GID=" $4 ") | Shell: " $7}' "$DATA_FILE"
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 14 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"