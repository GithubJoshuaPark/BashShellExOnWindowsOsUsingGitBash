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
 레슨 13) sed 고급: 인플레이스, 캡처/백레퍼런스
========================================
B

echo "[목표]"
echo "- '-i' 옵션으로 파일을 직접 수정(in-place)하는 방법을 익힌다."
echo "- 캡처 그룹 '()'을 사용하여 패턴의 일부를 저장한다."
echo "- 백레퍼런스 '\1', '\2'를 사용하여 캡처된 텍스트를 재사용한다."
echo "- 캡처/백레퍼런스를 활용한 데이터 형식 재구성 방법을 배운다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 CSV 파일 생성"
CSV_FILE="$TMP_DIR/users.csv"
cat > "$CSV_FILE" <<'DATA'
id,name,email
1,john doe,john.doe@email.com
2,jane smith,jane.smith@email.com
3,peter jones,peter.jones@email.com
DATA

echo "CSV 파일 생성: $CSV_FILE"
echo "--------------------------------"
nl -ba "$CSV_FILE"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  인플레이스(In-place) 수정 (-i 옵션)"
echo "'-i' 옵션은 결과를 화면에 출력하는 대신 파일을 직접 수정합니다."
echo "실수로 인한 데이터 유실을 막기 위해 백업 파일을 만드는 '-i.bak' 사용을 권장합니다."
echo
echo "실행: sed -i.bak 's/doe/davis/' \"$CSV_FILE\""
sed_i_bak 's/doe/davis/' "$CSV_FILE"

echo
echo "파일이 직접 수정되었고, 원본은 'users.csv.bak'으로 백업되었습니다."
echo "수정된 파일 내용:"
echo "--------------------------------"
cat "$CSV_FILE"
echo "--------------------------------"
f_pause

echo "백업 파일 내용:"
echo "--------------------------------"
cat "$CSV_FILE.bak"
echo "--------------------------------"
# 원상 복구
mv "$CSV_FILE.bak" "$CSV_FILE"
f_pause

# ------------------------------------------------------------
echo "3️⃣  캡처 그룹 '()'과 백레퍼런스 '\1'"
echo "패턴의 일부를 괄호 '()'로 감싸면 '캡처'할 수 있습니다."
echo "캡처된 내용은 '\1', '\2' 와 같은 '백레퍼런스'로 재사용할 수 있습니다."
echo
echo "예제: '이름 성' 형식을 '성, 이름' 형식으로 바꾸기"
echo "패턴: ([a-z]+) ([a-z]+)  => 1:이름, 2:성"
echo "치환: \2, \1"
echo
echo "실행: sed -E 's/([a-z]+) ([a-z]+)/\2, \1/' \"$CSV_FILE\""
sed -E 's/([a-z]+) ([a-z]+)/\2, \1/' "$CSV_FILE"
f_pause

# ------------------------------------------------------------
echo "4️⃣  실전 예제: 데이터 포맷 변경"
echo "목표: 'id,name,email'을 'name (email)' 형식으로 변경"
echo "패턴: ^([^,]+),([^,]+),([^,]+)$"
echo " - ^([^,]+)   : 첫 번째 캡처 그룹(\1) - 라인 시작, 쉼표가 아닌 문자들"
echo " - ,([^,]+)   : 두 번째 캡처 그룹(\2) - 쉼표 이후, 쉼표가 아닌 문자들"
echo " - ,([^,]+)$   : 세 번째 캡처 그룹(\3) - 마지막 쉼표 이후, 라인 끝까지"
echo "치환: \2 (\3)"
echo
echo "실행: sed -E '2,\$s/^([^,]+),([^,]+),([^,]+)$/\2 (\3)/' \"$CSV_FILE\""
echo "실행: sed -E '1!s/^([^,]+),([^,]+),([^,]+)$/\2 (\3)/' \"$CSV_FILE\""
sed -E '1!s/^([^,]+),([^,]+),([^,]+)$/\2 (\3)/' "$CSV_FILE"
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 13 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"