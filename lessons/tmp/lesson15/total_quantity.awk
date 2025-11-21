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
