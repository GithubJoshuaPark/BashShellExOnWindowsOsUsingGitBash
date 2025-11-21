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
 레슨 15) awk 고급: 조건/형식화/딕셔너리
========================================
B

echo "[목표]"
echo "- 패턴/조건을 사용하여 특정 레코드(행)만 처리한다."
echo "- BEGIN, END 블록의 사용법을 이해한다."
echo "- printf를 사용하여 출력 형식을 정교하게 제어한다."
echo "- 연관 배열(딕셔너리)을 사용하여 데이터를 집계하고 요약한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 판매 기록 파일 생성"
SALES_LOG="$TMP_DIR/sales.log"
cat > "$SALES_LOG" <<'DATA'
#date,item,quantity,price
2023-10-01,apple,10,1.50
2023-10-01,banana,5,0.75
2023-10-02,apple,20,1.50
2023-10-02,orange,15,1.25
2023-10-03,banana,10,0.75
2023-10-03,apple,5,1.50
DATA

echo "데이터 파일 생성: $SALES_LOG"
echo "--------------------------------"
nl -ba "$SALES_LOG"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  조건부 처리"
echo "--- 특정 필드 값 비교 ---"
echo "수량(\$3)이 10 이상인 레코드만 출력합니다."
echo
echo "실행: awk -F',' '\$3 >= 10' \"$SALES_LOG\""
awk -F',' '$3 >= 10' "$SALES_LOG"
f_pause

echo "--- 정규표현식 매칭 ---"
echo "날짜(\$1)가 '2023-10-02'인 레코드만 출력합니다."
echo
echo "실행: awk -F',' '/^2023-10-02/' \"$SALES_LOG\""
awk -F',' '/^2023-10-02/' "$SALES_LOG"
f_pause

# ------------------------------------------------------------
echo "3️⃣  BEGIN과 END 블록"
echo "- BEGIN 블록: 파일 처리 전에 한 번 실행 (헤더 출력 등)"
echo "- END 블록: 파일 처리 후에 한 번 실행 (요약, 총계 출력 등)"
echo
echo "실행: awk 'BEGIN {print \"--- Start ---\"} {print} END {print \"--- End ---\"}' \"$SALES_LOG\""
awk 'BEGIN {print "--- Start ---"} {print} END {print "--- End ---"}' "$SALES_LOG"
f_pause

# ------------------------------------------------------------
echo "4️⃣  형식화된 출력 (printf)"
echo "printf를 사용하면 출력 형식을 정교하게 제어할 수 있습니다."
echo " - %-10s: 10칸짜리 문자열, 왼쪽 정렬"
echo " - %5d: 5칸짜리 정수, 오른쪽 정렬"
echo " - %8.2f: 8칸짜리 소수(소수점 이하 2자리), 오른쪽 정렬"
echo
echo "실행: awk -F',' '/apple/ {printf \"Item: %-10s Qty: %5d Price: %8.2f\\n\", \$2, \$3, \$4}' \"$SALES_LOG\""
awk -F',' '/apple/ {printf "Item: %-10s Qty: %5d Price: %8.2f\n", $2, $3, $4}' "$SALES_LOG"
f_pause

# ------------------------------------------------------------
echo "5️⃣  연관 배열 (딕셔너리)을 이용한 집계"
echo "awk의 배열은 문자열을 인덱스로 사용할 수 있어 매우 강력합니다."
echo "목표: 품목(item)별 총 판매 수량(quantity) 계산하기"
echo " - totals[\$2] += \$3 : 품목(\$2)을 키로 하여 수량(\$3)을 누적"
echo " - END 블록에서 최종 결과 출력"
echo
echo "실행 중..."
awk -F',' '
NR > 1 {
    totals[$2] += $3
}
END {
    print "--- Item-wise Total Quantity ---"
    for (item in totals) {
        printf "% -10s : %d\n", item, totals[item]
    }
}' "$SALES_LOG"
f_pause

# ------------------------------------------------------------
echo "✅  레슨 15 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"