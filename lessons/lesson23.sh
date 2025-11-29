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
 레슨 23) 프로세스/잡/시그널
========================================
B

echo "[목표]"
echo "- 리눅스/유닉스 시스템에서 프로세스, 잡, 시그널의 개념을 이해한다."
echo "- 'ps', 'jobs', 'kill' 등 관련 명령어를 사용하여 프로세스를 관리한다."
echo "- 백그라운드/포그라운드 잡을 제어하고, 시그널을 통해 프로세스와 통신한다."
echo "- 'nohup'을 사용하여 터미널 종료 후에도 프로세스를 유지하는 방법을 배운다."
echo

# ------------------------------------------------------------
echo "1️⃣  프로세스 이해하기"
echo "--- 'ps' 명령어로 현재 실행 중인 프로세스 확인 ---"
echo "실행: ps aux | head -n 5"
ps aux | head -n 5
f_pause

echo "--- '$$' 변수로 현재 쉘의 PID 확인 ---"
echo "실행: echo \"현재 쉘의 PID: $$\""
echo "현재 쉘의 PID: $$"
f_pause

# ------------------------------------------------------------
echo "2️⃣  잡(Job) 제어: 백그라운드/포그라운드"
echo "--- 백그라운드에서 명령 실행하기 ('&') ---"
echo "오래 걸리는 작업을 백그라운드에서 실행하여 쉘을 계속 사용할 수 있습니다."
echo "실행: sleep 10 &"
sleep 10 &
echo "백그라운드 잡이 시작되었습니다. (PID: $!)"
f_pause

echo "--- 'jobs' 명령어로 백그라운드 잡 확인 ---"
echo "실행: jobs -l"
jobs -l
f_pause

echo "--- 'fg' 명령어로 백그라운드 잡을 포그라운드로 가져오기 ---"
echo "(이 예제에서는 sleep이 짧아 바로 종료될 수 있습니다.)"
echo "실행: fg %1 (첫 번째 잡을 포그라운드로)"
# fg %1 # 실제 실행 시 쉘이 블록되므로 주석 처리
echo "(실제 실행 시에는 'sleep 10'이 포그라운드에서 실행됩니다.)"
f_pause

echo "--- 'Ctrl+Z'로 포그라운드 잡을 일시 중지 후 'bg'로 백그라운드 실행 ---"
echo "(이 예제는 직접 실행해야 합니다. 'sleep 10' 입력 후 Ctrl+Z, 그 다음 'bg' 입력)"
echo "실행: sleep 10 (입력 후 Ctrl+Z) -> bg"
echo "(직접 시연이 필요합니다.)"
f_pause

# ------------------------------------------------------------
echo "3️⃣  시그널(Signal) 보내기: 'kill' 명령어"
echo "--- 'kill' 명령어로 프로세스 종료하기 (SIGTERM) ---"
echo "백그라운드에서 sleep 20을 실행하고 PID를 확인합니다."
sleep 20 &
SLEEP_PID=$!
echo "sleep 20이 백그라운드에서 실행 중입니다. (PID: $SLEEP_PID)"
f_pause

echo "실행: kill $SLEEP_PID (SIGTERM 시그널 전송)"
kill "$SLEEP_PID"
echo "프로세스 $SLEEP_PID 에 SIGTERM 시그널을 보냈습니다."
f_pause

echo "--- 'kill -9' 명령어로 프로세스 강제 종료하기 (SIGKILL) ---"
echo "SIGKILL은 프로세스가 시그널을 무시할 수 없게 강제로 종료합니다."
sleep 20 &
SLEEP_PID=$!
echo "sleep 20이 백그라운드에서 실행 중입니다. (PID: $SLEEP_PID)"
f_pause

echo "실행: kill -9 $SLEEP_PID (SIGKILL 시그널 전송)"
kill -9 "$SLEEP_PID"
echo "프로세스 $SLEEP_PID 에 SIGKILL 시그널을 보냈습니다."
f_pause

# ------------------------------------------------------------
echo "4️⃣  nohup: 터미널 종료 후에도 프로세스 유지"
echo "--- 'nohup'으로 백그라운드에서 명령 실행 ---"
echo "nohup은 터미널이 닫혀도 프로세스가 계속 실행되도록 합니다."
echo "출력은 'nohup.out' 파일로 리다이렉션됩니다."
echo
echo "실행: nohup sleep 10 > \"$TMP_DIR/nohup.out\" 2>&1 &"
nohup sleep 10 > "$TMP_DIR/nohup.out" 2>&1 &
NOHUP_PID=$!
echo "nohup sleep 10이 백그라운드에서 실행 중입니다. (PID: $NOHUP_PID)"
f_pause

echo "nohup.out 파일 내용 확인:"
cat "$TMP_DIR/nohup.out" || echo "(아직 내용 없음)"
f_pause

echo "nohup 프로세스 종료: kill $NOHUP_PID"
kill "$NOHUP_PID" || true # 이미 종료되었을 경우 에러 방지
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 23 완료!"
echo "프로세스, 잡, 시그널 관리는 시스템 관리 및 고급 스크립팅에 필수적인 기술입니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"