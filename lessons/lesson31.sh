#!/usr/bin/env bash
set -euo pipefail

# ▣ [1] 공통 설정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMP_DIR="$SCRIPT_DIR/tmp/$(basename "$0" .sh)"
mkdir -p "$TMP_DIR"

source "$SCRIPT_DIR/utils.sh"

# To-Do 리스트 파일 경로
TODO_FILE="$TMP_DIR/todos.txt"
touch "$TODO_FILE" # 파일이 없으면 생성

echo
echo "========================"
echo "$(basename "$0") Start"
echo "========================"
echo

# ▣ [2] 헤더
cat <<'B'
========================================
 레슨 31) 통합 프로젝트: To-Do 리스트 관리 툴 (인터랙티브)
========================================
B

echo "[목표]"
echo "- Bash 스크립트로 인터랙티브한 CLI To-Do 리스트 관리 툴을 만든다."
echo "- 메뉴 기반의 사용자 인터페이스를 구현하여 사용자와 상호작용한다."
echo "- 함수, 파일 입출력, 텍스트 처리 도구(grep, sed, awk)를 통합하여 사용한다."
echo "- 사용자 입력 처리 및 조건부 로직을 구현한다."
echo "- 실용적인 도구를 직접 만들어보며 Bash 스크립팅 기술을 강화한다."
echo

# ------------------------------------------------------------
echo "1️⃣  To-Do 리스트 관리 함수 정의"

# To-Do 항목 추가
add_todo() {
    local description="$*"
    if [[ -z "$description" ]]; then
        echo "오류: 추가할 To-Do 내용을 입력해주세요."
        return 1
    fi
    echo "PENDING|$description" >> "$TODO_FILE"
    echo "To-Do 항목이 추가되었습니다: \"$description\""
    return 0
}

# To-Do 항목 목록 출력
list_todos() {
    echo "--- 현재 To-Do 리스트 ---"
    if [[ ! -s "$TODO_FILE" ]]; then
        echo "To-Do 리스트가 비어 있습니다."
        return 0
    fi
    awk -F'|' '{
        status = ($1 == "DONE") ? "[✅️ 완료]" : "[💡 대기]";
        print NR ". " status " " $2;
    }' "$TODO_FILE"
    echo "-------------------------"
    return 0
}

# To-Do 항목 완료 처리
complete_todo() {
    local item_num="$1"
    if [[ -z "$item_num" || ! "$item_num" =~ ^[0-9]+$ ]]; then
        echo "오류: 완료할 To-Do 항목의 번호를 숫자로 입력해주세요."
        return 1
    fi

    local line_content=$(sed -n "${item_num}p" "$TODO_FILE")
    if [[ -z "$line_content" ]]; then
        echo "오류: ${item_num}번 항목이 존재하지 않습니다."
        return 1
    fi

    if echo "$line_content" | grep -q "^DONE|"; then
        echo "${item_num}번 항목은 이미 완료되었습니다."
        return 0
    fi

    sed_i "${item_num}s/^PENDING/DONE/" "$TODO_FILE"
    echo "${item_num}번 To-Do 항목이 완료되었습니다."
    return 0
}

# To-Do 항목 삭제
delete_todo() {
    local item_num="$1"
    if [[ -z "$item_num" || ! "$item_num" =~ ^[0-9]+$ ]]; then
        echo "오류: 삭제할 To-Do 항목의 번호를 숫자로 입력해주세요."
        return 1
    fi

    local line_count=$(wc -l < "$TODO_FILE")
    if [[ "$item_num" -gt "$line_count" ]]; then
        echo "오류: ${item_num}번 항목이 존재하지 않습니다."
        return 1
    fi

    sed_i "${item_num}d" "$TODO_FILE"
    echo "${item_num}번 To-Do 항목이 삭제되었습니다."
    return 0
}

# ------------------------------------------------------------
echo "2️⃣  인터랙티브 To-Do 툴 실행"

# 메뉴 표시 함수
show_menu() {
    echo ""
    echo "========== To-Do 리스트 메뉴 =========="
    echo "1. To-Do 목록 보기"
    echo "2. To-Do 항목 추가"
    echo "3. To-Do 항목 완료 처리 (ID로)"
    echo "4. To-Do 항목 삭제 (ID로)"
    echo "5. 메인 메뉴로 돌아가기"
    echo "-------------------------------------"
    read -rp "선택: " choice
}

# 메인 루프
while true; do
    list_todos # 항상 최신 목록을 보여주는 것이 사용자 경험에 좋음
    show_menu
    case "$choice" in
        1) # List Todos
            f_pause
            ;;
        2) # Add a Todo
            read -rp "추가할 To-Do 내용을 입력하세요: " desc
            add_todo "$desc" || f_pause # 오류 시에만 일시 정지
            ;;
        3) # Complete a Todo
            read -rp "완료할 To-Do 항목의 번호를 입력하세요: " id
            complete_todo "$id" || f_pause # 오류 시에만 일시 정지
            ;;
        4) # Delete a Todo
            read -rp "삭제할 To-Do 항목의 번호를 입력하세요: " id
            delete_todo "$id" || f_pause # 오류 시에만 일시 정지
            ;;
        5) # Exit
            echo "메인 메뉴로 돌아갑니다."
            break
            ;;
        *)
            echo "잘못된 선택입니다. 1-5 사이의 숫자를 입력해주세요."
            f_pause
            ;;
    esac
done

# 테스트용 데이터 삭제 여부
f_delete_tmp

# ------------------------------------------------------------
echo "✅  레슨 31 완료!"
echo "Bash 스크립트로 인터랙티브한 To-Do 리스트 관리 툴을 만들었습니다."
echo "이것으로 모든 레슨이 완료되었습니다. 축하합니다!"

echo
echo "========================"
echo "$(basename "$0") End"
echo "========================"
