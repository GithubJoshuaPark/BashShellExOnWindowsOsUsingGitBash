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
