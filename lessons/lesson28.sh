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
 레슨 28) 멀티스레드 흉내: xargs -P 병렬 처리
========================================
B

echo "[목표]"
echo "- 'xargs -P' 옵션을 사용하여 여러 명령을 병렬로 실행하는 방법을 배운다."
echo "- 순차 처리와 병렬 처리의 성능 차이를 이해한다."
echo "- CPU 코어를 효율적으로 활용하여 작업 시간을 단축하는 방법을 익힌다."
echo "- 병렬 처리 시 발생할 수 있는 출력 순서 문제 등을 인지한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 더미 파일 생성"
NUM_FILES=10
for i in $(seq 1 $NUM_FILES); do
    echo "file_$i.txt" > "$TMP_DIR/file_$i.txt"
done
echo "더미 파일 $NUM_FILES개 생성 완료."
ls "$TMP_DIR"
f_pause

# ------------------------------------------------------------
echo "2️⃣  순차 처리 (Sequential Processing)"
echo "--- 각 파일을 0.5초씩 처리하는 작업 시뮬레이션 ---"
echo "총 예상 시간: $(echo "$NUM_FILES * 0.5" | bc)초"
echo
START_TIME=$(date +%s)
for file in "$TMP_DIR"/file_*.txt; do
    echo "순차 처리 중: $(basename "$file")"
    sleep 0.5
done
END_TIME=$(date +%s)
echo "순차 처리 완료. 총 소요 시간: $((END_TIME - START_TIME))초"
f_pause

# ------------------------------------------------------------
echo "3️⃣  병렬 처리 (Parallel Processing) with xargs -P"
echo "--- 'xargs -P' 옵션으로 병렬 처리 ---"
echo "-P 옵션은 동시에 실행할 프로세스(잡)의 최대 개수를 지정합니다."
echo "여기서는 4개의 프로세스를 동시에 실행합니다."
echo "총 예상 시간: 약 $(echo "$NUM_FILES * 0.5 / 4" | bc)초 (CPU 코어 수에 따라 달라짐)"
echo
START_TIME=$(date +%s)
find "$TMP_DIR" -name "file_*.txt" -print0 | xargs -0 -P 4 -I {} bash -c 'echo "병렬 처리 중: {}"; sleep 0.5'
END_TIME=$(date +%s)
echo "병렬 처리 완료. 총 소요 시간: $((END_TIME - START_TIME))초"
f_pause

echo "--- -P 옵션 없이 xargs (순차 처리와 유사) ---"
echo "실행: find \"$TMP_DIR\" -name \"file_*.txt\" -print0 | xargs -0 -I {} bash -c 'echo \"순차 xargs 처리 중: {}\"; sleep 0.5'"
START_TIME=$(date +%s)
find "$TMP_DIR" -name "file_*.txt" -print0 | xargs -0 -I {} bash -c 'echo "순차 xargs 처리 중: {}"; sleep 0.5'
END_TIME=$(date +%s)
echo "순차 xargs 처리 완료. 총 소요 시간: $((END_TIME - START_TIME))초"
f_pause

# ------------------------------------------------------------
echo "4️⃣  병렬 처리 시 출력 순서 문제"
echo "병렬로 실행되는 작업의 출력은 순서가 뒤섞일 수 있습니다."
echo "실행: find \"$TMP_DIR\" -name \"file_*.txt\" -print0 | xargs -0 -P 4 -I {} bash -c 'echo \"$(basename {}) 처리 시작\"; sleep 0.1; echo \"$(basename {}) 처리 완료\"'"
find "$TMP_DIR" -name "file_*.txt" -print0 | xargs -0 -P 4 -I {} bash -c 'echo "$(basename {}) 처리 시작"; sleep 0.1; echo "$(basename {}) 처리 완료"'
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 28 완료!"
echo "xargs -P를 사용하여 Bash 스크립트에서 병렬 처리를 구현하는 방법을 익혔습니다."
echo "이는 대규모 파일 처리나 독립적인 작업을 빠르게 수행할 때 매우 유용합니다."

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"