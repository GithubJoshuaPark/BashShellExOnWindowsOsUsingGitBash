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
 레슨 25) CSV/TSV 파서 스크립트 (awk 실전)
========================================
B

echo "[목표]"
echo "- 'awk'를 사용하여 CSV (쉼표로 구분된 값) 파일을 파싱한다."
echo "- 'awk'를 사용하여 TSV (탭으로 구분된 값) 파일을 파싱한다."
echo "- '-F' 옵션으로 필드 구분자를 정확하게 지정하는 방법을 익힌다."
echo "- CSV/TSV 파일에서 특정 열을 추출하고, 행을 필터링하며, 데이터를 변환한다."
echo "- CSV와 TSV 형식 간의 변환 방법을 배운다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 CSV 및 TSV 파일 생성"
PRODUCTS_CSV="$TMP_DIR/products.csv"
cat > "$PRODUCTS_CSV" <<'DATA'
ID,Name,Category,Price,Stock
1,Laptop,Electronics,1200.00,50
2,Mouse,Electronics,25.50,200
3,Keyboard,Electronics,75.00,100
4,Desk Chair,Furniture,150.00,30
5,Monitor,Electronics,300.00,70
DATA

SALES_TSV="$TMP_DIR/sales.tsv"
cat > "$SALES_TSV" <<'DATA'
OrderID	CustomerID	Product	Quantity	Total
1001	C001	Laptop	1	1200.00
1002	C002	Mouse	2	51.00
1003	C001	Keyboard	1	75.00
1004	C003	Monitor	1	300.00
DATA

echo "CSV 파일 생성: $PRODUCTS_CSV"
echo "--------------------------------"
cat "$PRODUCTS_CSV"
echo "--------------------------------"
f_pause

echo "TSV 파일 생성: $SALES_TSV"
echo "--------------------------------"
cat "$SALES_TSV"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  CSV 파일 파싱 (필드 구분자: 쉼표)"
echo "--- 모든 제품 정보 출력 (헤더 제외) ---"
echo "실행: awk -F',' 'NR > 1 {print \$0}' \"$PRODUCTS_CSV\""
awk -F',' 'NR > 1 {print $0}' "$PRODUCTS_CSV"
f_pause

echo "--- 'Name'과 'Price' 열만 추출 ---"
echo "실행: awk -F',' 'NR > 1 {print \$2, \$4}' \"$PRODUCTS_CSV\""
awk -F',' 'NR > 1 {print $2, $4}' "$PRODUCTS_CSV"
f_pause

echo "--- 'Category'가 'Electronics'인 제품만 필터링 ---"
echo "실행: awk -F',' 'NR > 1 && \$3 == \"Electronics\" {print \$0}' \"$PRODUCTS_CSV\""
awk -F',' 'NR > 1 && $3 == "Electronics" {print $0}' "$PRODUCTS_CSV"
f_pause

echo "--- 'Electronics' 카테고리의 총 재고 수량 계산 ---"
echo "실행 중..."
awk -F',' '
NR > 1 && $3 == "Electronics" {
    total_stock += $5
}
END {
    print "총 전자제품 재고:", total_stock
}' "$PRODUCTS_CSV"
f_pause

# ------------------------------------------------------------
echo "3️⃣  TSV 파일 파싱 (필드 구분자: 탭)"
echo "--- 모든 판매 기록 출력 (헤더 제외) ---"
echo "실행: awk -F'\t' 'NR > 1 {print \$0}' \"$SALES_TSV\""
awk -F'\t' 'NR > 1 {print $0}' "$SALES_TSV"
f_pause

echo "--- 'OrderID'와 'Product' 열만 추출 ---"
echo "실행: awk -F'\t' 'NR > 1 {print \$1, \$3}' \"$SALES_TSV\""
awk -F'\t' 'NR > 1 {print $1, $3}' "$SALES_TSV"
f_pause

echo "--- 'CustomerID'가 'C001'인 판매 기록 필터링 ---"
echo "실행: awk -F'\t' 'NR > 1 && \$2 == \"C001\" {print \$0}' \"$SALES_TSV\""
awk -F'\t' 'NR > 1 && $2 == "C001" {print $0}' "$SALES_TSV"
f_pause

# ------------------------------------------------------------
echo "4️⃣  CSV <-> TSV 형식 변환"
echo "--- CSV 파일을 TSV 파일로 변환 ---"
echo "OFS (Output Field Separator)를 탭으로 설정합니다."
echo "실행: awk -F',' 'BEGIN {OFS="\t"} {print \$1, \$2, \$3, \$4, \$5}' \"$PRODUCTS_CSV\""
awk -F',' 'BEGIN {OFS="\t"} {print $1, $2, $3, $4, $5}' "$PRODUCTS_CSV"
f_pause

echo "--- TSV 파일을 CSV 파일로 변환 ---"
echo "OFS를 쉼표로 설정합니다."
echo "실행: awk -F'\t' 'BEGIN {OFS=","} {print \$1, \$2, \$3, \$4, \$5}' \"$SALES_TSV\""
awk -F'\t' 'BEGIN {OFS=","} {print $1, $2, $3, $4, $5}' "$SALES_TSV"
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 25 완료!"
echo "awk를 사용하여 CSV/TSV와 같은 구조화된 텍스트 데이터를 효율적으로 파싱하고 조작하는 방법을 익혔습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"