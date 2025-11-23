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
 레슨 30) 통합 프로젝트: 로그 분석 및 리포트 생성기
========================================
B

echo "[목표]"
echo "- 'grep', 'awk', 'sed' 등 배운 도구들을 조합하여 실제 문제를 해결한다."
echo "- 웹 서버 로그 파일을 분석하여 통계 및 리포트를 생성한다."
echo "- 함수, 조건문, 파이프라인 등을 활용하여 복잡한 스크립트를 구조화한다."
echo "- 견고하고 재사용 가능한 로그 분석 스크립트를 작성하는 경험을 한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 웹 서버 액세스 로그 파일 생성"
ACCESS_LOG="$TMP_DIR/complex_access.log"
cat > "$ACCESS_LOG" <<'DATA'
192.168.1.10 - - [21/Nov/2025:08:00:01 +0000] "GET /index.html HTTP/1.1" 200 150
192.168.1.11 - - [21/Nov/2025:08:00:05 +0000] "GET /css/style.css HTTP/1.1" 200 500
192.168.1.10 - - [21/Nov/2025:08:00:10 +0000] "GET /images/logo.png HTTP/1.1" 200 12000
192.168.1.12 - - [21/Nov/2025:08:00:15 +0000] "GET /api/data HTTP/1.1" 404 230
192.168.1.13 - - [21/Nov/2025:08:00:20 +0000] "POST /submit HTTP/1.1" 201 50
192.168.1.10 - - [21/Nov/2025:08:00:25 +0000] "GET /admin/login HTTP/1.1" 500 100
192.168.1.14 - - [21/Nov/2025:08:00:30 +0000] "GET /index.html HTTP/1.1" 200 150
192.168.1.12 - - [21/Nov/2025:08:00:35 +0000] "GET /nonexistent HTTP/1.1" 404 230
192.168.1.15 - - [21/Nov/2025:08:00:40 +0000] "GET /api/status HTTP/1.1" 200 20
192.168.1.10 - - [21/Nov/2025:08:00:45 +0000] "GET /admin/dashboard HTTP/1.1" 503 120
DATA

echo "로그 파일 생성: $ACCESS_LOG"
echo "--------------------------------"
cat "$ACCESS_LOG"
echo "--------------------------------"
f_pause

# ------------------------------------------------------------
echo "2️⃣  로그 분석 함수 정의"

# 로그 파일에서 특정 필드를 추출하는 함수
extract_field() {
    local log_file="$1"
    local field_num="$2"
    awk -v field="$field_num" '{print $field}' "$log_file"
}

# 로그 파일에서 상태 코드별 개수를 세는 함수
count_status_codes() {
    local log_file="$1"
    awk '{print $9}' "$log_file" | sort | uniq -c | sort -nr
}

# 로그 파일에서 상위 N개 URL을 추출하는 함수
get_top_urls() {
    local log_file="$1"
    local top_n="${2:-5}" # 기본값 5
    awk '{print $7}' "$log_file" | sort | uniq -c | sort -nr | head -n "$top_n"
}

# 로그 파일에서 상위 N개 IP 주소를 추출하는 함수
get_top_ips() {
    local log_file="$1"
    local top_n="${2:-5}" # 기본값 5
    awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -n "$top_n"
}

# ------------------------------------------------------------
echo "3️⃣  로그 분석 리포트 생성"

generate_report() {
    local log_file="$1"
    local report_file="$TMP_DIR/log_report.txt"
    local top_n="${2:-5}"

    echo "========== 로그 분석 리포트 ==========" > "$report_file"
    echo "분석 대상: $(basename "$log_file")" >> "$report_file"
    echo "분석 시간: $(date)" >> "$report_file"
    echo "------------------------------------" >> "$report_file"

    # 총 요청 수
    local total_requests=$(wc -l < "$log_file")
    echo "총 요청 수: $total_requests" >> "$report_file"

    # 상태 코드별 통계
    echo "" >> "$report_file"
    echo "--- 상태 코드별 통계 ---" >> "$report_file"
    count_status_codes "$log_file" >> "$report_file"

    # 성공 (2xx), 클라이언트 에러 (4xx), 서버 에러 (5xx)
    local success_2xx=$(grep -c " 20[0-9] " "$log_file")
    local client_error_4xx=$(grep -c " 40[0-9] " "$log_file")
    local server_error_5xx=$(grep -c " 50[0-9] " "$log_file")

    echo "" >> "$report_file"
    echo "--- 요청 유형별 통계 ---" >> "$report_file"
    echo "성공 (2xx): $success_2xx" >> "$report_file"
    echo "클라이언트 에러 (4xx): $client_error_4xx" >> "$report_file"
    echo "서버 에러 (5xx): $server_error_5xx" >> "$report_file"

    # 상위 N개 요청 URL
    echo "" >> "$report_file"
    echo "--- 상위 $top_n개 요청 URL ---" >> "$report_file"
    get_top_urls "$log_file" "$top_n" >> "$report_file"

    # 상위 N개 IP 주소
    echo "" >> "$report_file"
    echo "--- 상위 $top_n개 IP 주소 ---" >> "$report_file"
    get_top_ips "$log_file" "$top_n" >> "$report_file"

    echo "------------------------------------" >> "$report_file"
    echo "리포트 생성 완료: $report_file"
    cat "$report_file"
}

echo "--- 로그 분석 리포트 생성 시작 (상위 3개 항목) ---"
generate_report "$ACCESS_LOG" 3
f_pause

# ------------------------------------------------------------
echo "✅  레슨 30 완료!"
echo "배운 Bash 스크립팅 기술을 통합하여 실제 로그 분석 리포트 생성기를 만들었습니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"