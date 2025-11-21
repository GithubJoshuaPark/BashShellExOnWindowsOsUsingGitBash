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
 레슨 15) awk 고급: 조건/형식화/딕셔너리/함수
========================================
B

echo "[목표]"
echo "- 패턴/조건을 사용하여 특정 레코드(행)만 처리한다."
echo "- BEGIN, END 블록의 사용법을 이해한다."
echo "- printf를 사용하여 출력 형식을 정교하게 제어한다."
echo "- 연관 배열(딕셔너리)을 사용하여 데이터를 집계하고 요약한다."
echo "- 함수를 정의하고 사용하며, 스크립트 파일을 통해 awk를 실행한다."
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
echo "실행: awk 'BEGIN {print \"--- Start ---\"} {print} END {print \"--- End ---\"} ' \"$SALES_LOG\""
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
echo "6️⃣  awk 스크립트 파일 사용하기 (-f 옵션)"
echo "복잡한 awk 로직은 별도의 .awk 파일로 분리하는 것이 좋습니다."
AWK_SCRIPT_1="$TMP_DIR/total_quantity.awk"
cat > "$AWK_SCRIPT_1" <<'AWK'
# 품목별 총 수량을 계산하는 awk 스크립트
# 주석도 자유롭게 사용할 수 있습니다.
BEGIN {
    FS="," # 필드 구분자를 콤마로 설정
}
# 데이터 라인(헤더 제외)만 처리
NR > 1 {
    totals[$2] += $3
}
END {
    print "--- Item-wise Total Quantity (from file) ---"
    for (item in totals) {
        printf "% -10s : %d\n", item, totals[item]
    }
}
AWK
echo ".awk 스크립트 파일 생성:"
echo "--------------------------------"
cat "$AWK_SCRIPT_1"
echo "--------------------------------"
echo "실행: awk -f \"$AWK_SCRIPT_1\" \"$SALES_LOG\""
awk -f "$AWK_SCRIPT_1" "$SALES_LOG"
f_pause

# ------------------------------------------------------------
echo "7️⃣  종합 예제: 함수를 이용한 판매 리포트 생성"
echo "함수를 사용하여 로직을 모듈화하고, 최종 리포트를 생성합니다."
AWK_SCRIPT_2="$TMP_DIR/sales_report.awk"
cat > "$AWK_SCRIPT_2" <<'AWK'
# 판매 리포트를 생성하는 awk 스크립트

# 함수 정의: 매출(revenue) 계산
function calculate_revenue(quantity, price) {
    return quantity * price
}

BEGIN {
    FS=","
    print "========== Sales Report =========="
    printf "%-12s | %-10s | %10s\n", "Date", "Item", "Revenue"
    print "------------------------------------"
}

NR > 1 {
    # 각 라인의 매출 계산
    revenue = calculate_revenue($3, $4)
    
    # 품목별 총 매출 집계
    total_revenue_by_item[$2] += revenue
    
    # 전체 총 매출 집계
    grand_total_revenue += revenue
    
    # 현재 라인 출력
    printf "%-12s | %-10s | %10.2f\n", $1, $2, revenue
}

END {
    print "------------------------------------"
    print "\n--- Summary by Item ---"
    for (item in total_revenue_by_item) {
        printf "%-10s Total: %10.2f\n", item, total_revenue_by_item[item]
    }
    
    print "\n--- Grand Total ---"
    printf "Grand Total Revenue: %10.2f\n", grand_total_revenue
    print "===================================="
}
AWK
echo "최종 리포트 스크립트 생성:"
echo "--------------------------------"
cat "$AWK_SCRIPT_2"
echo "--------------------------------"
echo "실행: awk -f \"$AWK_SCRIPT_2\" \"$SALES_LOG\""
awk -f "$AWK_SCRIPT_2" "$SALES_LOG"
f_pause

# ------------------------------------------------------------
echo "✅  레슨 15 완료!"
echo "생성된 임시 파일들은 $TMP_DIR 에서 확인할 수 있습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"
