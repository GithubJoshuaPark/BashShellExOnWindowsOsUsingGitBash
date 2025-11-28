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
 레슨 26) 로그 회전/압축/보관 스크립트
========================================
B

echo "[목표]"
echo "- 로그 파일이 디스크 공간을 과도하게 차지하는 것을 방지한다."
echo "- 오래된 로그 파일을 압축하여 저장 공간을 절약한다."
echo "- 일정 기간이 지난 로그 파일을 자동으로 삭제하여 관리한다."
echo "- 'logrotate'와 같은 전문 도구의 기본 원리를 이해한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 로그 파일 생성 및 내용 추가"
LOG_FILE="$TMP_DIR/app.log"
touch "$LOG_FILE"

echo "--- 초기 로그 내용 ---"
echo "$(date): Application started." >> "$LOG_FILE"
echo "$(date): User 'admin' logged in." >> "$LOG_FILE"
echo "$(date): Processing data..." >> "$LOG_FILE"
cat "$LOG_FILE"
f_pause

# ------------------------------------------------------------
echo "2️⃣  로그 회전 (Rotation) - 파일 이름 변경"
echo "--- 현재 로그 파일을 날짜 접미사를 붙여 백업 ---"
CURRENT_DATE=$(date +%Y%m%d)
BACKUP_LOG_FILE="${LOG_FILE}.${CURRENT_DATE}"

echo "실행: mv \"$LOG_FILE\" \"$BACKUP_LOG_FILE\""
mv "$LOG_FILE" "$BACKUP_LOG_FILE"
echo "로그 파일이 '$BACKUP_LOG_FILE'로 회전되었습니다."
f_pause

echo "--- 새로운 빈 로그 파일 생성 ---"
echo "실행: touch \"$LOG_FILE\""
touch "$LOG_FILE"
echo "새로운 'app.log' 파일이 생성되었습니다."
echo "$(date): Application continued after rotation." >> "$LOG_FILE"
echo "현재 디렉토리 내용:"
ls -l "$TMP_DIR"
f_pause

# ------------------------------------------------------------
echo "3️⃣  로그 압축 (Compression)"
echo "--- 회전된 로그 파일을 gzip으로 압축 ---"
echo "실행: gzip \"$BACKUP_LOG_FILE\""
gzip "$BACKUP_LOG_FILE"
echo "회전된 로그 파일이 '$BACKUP_LOG_FILE.gz'로 압축되었습니다."
echo "현재 디렉토리 내용:"
ls -l "$TMP_DIR"
f_pause

# ------------------------------------------------------------
echo "4️⃣  오래된 로그 보관 및 삭제 (Retention)"
echo "--- 3일보다 오래된 압축 로그 파일 삭제 ---"
# 테스트를 위해 가상의 오래된 파일 생성
touch_d "4 days ago" "$TMP_DIR/app.log.$(date_offset '4 days ago' +%Y%m%d).gz"
touch_d "5 days ago" "$TMP_DIR/app.log.$(date_offset '5 days ago' +%Y%m%d).gz"
echo "가상의 오래된 로그 파일 생성 완료."
ls -l "$TMP_DIR"
f_pause

RETENTION_DAYS=3
echo "실행: find \"$TMP_DIR\" -name \"app.log.*.gz\" -mtime +$RETENTION_DAYS -delete"
find "$TMP_DIR" -name "app.log.*.gz" -mtime +$RETENTION_DAYS -delete
echo "$RETENTION_DAYS일보다 오래된 압축 로그 파일이 삭제되었습니다."
echo "현재 디렉토리 내용:"
ls -l "$TMP_DIR"
f_pause

# ------------------------------------------------------------
echo "✅  레슨 26 완료!"
echo "로그 회전, 압축, 보관의 기본 원리를 이해하고 간단한 스크립트를 작성했습니다."
echo "실제 환경에서는 'logrotate'와 같은 전문 도구를 사용하는 것이 일반적입니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"