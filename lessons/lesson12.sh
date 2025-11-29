#!/usr/bin/env bash
set -euo pipefail
echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo

# /tmp → lessons/tmp 로 변경
# sed -E 확장 정규식 사용
# p, d, s///, 구분자 @ 예제까지 포함
# VS Code에서 바로 생성 파일을 확인할 수 있게 설계

# ▣ [1] 공통 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
mkdir -p "$TMP_DIR"

source "$SCRIPT_DIR/utils.sh"

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 12) sed 입문: 치환 & 필터
========================================
B

echo "[목표]"
echo "- sed의 기본 구조(s///, p, d)를 익히고"
echo "- 주소 지정(범위)와 정규식 패턴을 활용한다."
echo "- 파일을 직접 수정하지 않고 결과를 확인한다."
echo

# ------------------------------------------------------------
echo "1️⃣  테스트용 설정파일 생성"

CFG_FILE="$TMP_DIR/sample.conf"

cat > "$CFG_FILE" <<'DATA'
# Sample configuration file
host=example.com
port=8080
mode=dev
timeout=30
# end of file
DATA

echo "생성된 파일: $CFG_FILE"
echo "--------------------------------"
nl -ba "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "2️⃣  특정 행(범위)만 출력하기"
echo "2~4행만 출력:"
sed -n '2,4p' "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "3️⃣  특정 패턴으로 시작하는 라인만 보기"
echo "host= 으로 시작하는 행:"
sed -n '/^host=/p' "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "4️⃣  주석 라인(#) 삭제"
echo "(패턴 매칭 후 /PATTERN/d)"
sed -E '/^\s*#/d' "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "5️⃣  문자열 치환 s///"
echo "mode=dev → mode=prod 으로 변경:"
sed -E 's/^mode=dev$/mode=prod/' "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "6️⃣  s@...@...@ 구분자 변경 예시"
echo "URL 경로처럼 / 가 많은 경우:"
sed -E 's@^host=.*$@host=api.example.com@' "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "7️⃣  여러 명령 결합 (-e 옵션)"
echo "주석 제거 후, mode 변경 후, host 변경:"
sed -E -e '/^#/d' -e 's/mode=dev/mode=prod/' -e 's/host=.*/host=local.test/' "$CFG_FILE"
f_pause

# ------------------------------------------------------------
echo "8️⃣  백업 + 인플레이스 수정 예제 (-i.bak)"
echo "(주의: 실제 파일을 수정하므로 마지막에 복원)"
cp "$CFG_FILE" "$CFG_FILE.bak"
echo "mode=dev → mode=release 로 변경 후 저장:"
sed_i_bak -E 's/^mode=dev$/mode=release/' "$CFG_FILE"
cat "$CFG_FILE"
f_pause

echo "백업파일(.bak):"
cat "$CFG_FILE.bak"
f_pause

# 복원
mv "$CFG_FILE.bak" "$CFG_FILE"

# ------------------------------------------------------------
echo "9️⃣  정규표현식으로 숫자 값 증가 (timeout 값 +10)"
echo "(캡처 그룹 사용: \\1)"
# sed /e 플래그는 GNU sed 전용이므로, 셸 루프로 대체하여 호환성 확보
while IFS= read -r line; do
    if [[ "$line" =~ ^timeout=([0-9]+) ]]; then
        val="${BASH_REMATCH[1]}"
        echo "timeout=$((val + 10))"
    else
        echo "$line"
    fi
done < "$CFG_FILE"
f_pause

# 테스트용 데이터 삭제 여부 
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 12 완료!"
echo "결과 파일은 VS Code에서 바로 확인 가능합니다."
echo "→ $CFG_FILE"

echo "========================"
echo "$(basename "$0") End"
echo "========================"
