#!/usr/bin/env bash
set -euo pipefail

###############################
# 🎲 이모지 배열 정의
###############################
ME_EMOJI=(💡 ✅️ ⛔ 🚫 ⚙️ 🧩 ✨ ⚠️ 💻 🐶 🐱 🐹 🐰 🦊 🐻 🐼 🐯 🦁 🐮 🐸 😺 😸 😹 😻 😼 😽 🙀 🐣 🐳 🌏 🍎 🍳 ⚾️ 🏄 🚴 🎧 🎮 🏍 ✈️🏝️ 🕹️ ❤️💞 ⚽️ 🥊 🐘 🐒 🐨 🐺 🐷 🐧 🐥 🐔 🐦 🐍 🐄 🐟 🐉 🐋 🐌 🐙 🐝 🐞 🐛 🐳 🐐 🐃 🐡 🌸 🌹 🐆 🐫 🐈 🐊 🐩 🐾 🎃 🎅 💾 🎊 📷 🎁 🎇 🌆 ⛪ 🏬 🏤 😁 😝 🙈 🙉 💎 💗)

# 함수: 무작위 이모지를 반환
get_random_emoji() {
    echo "${ME_EMOJI[$((RANDOM % ${#ME_EMOJI[@]}))]}"
}

# ▣ [1] 공통 설정
f_pause() {
    echo;
    read -rp "$(get_random_emoji) 계속하려면 [Enter] 키를 누르세요..." _;
    echo;
}

# OS 감지
OS_TYPE="$(uname)"

# sed -i 호환성 함수
# 사용법: sed_i 's/foo/bar/' filename
sed_i() {
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# sed -i.bak 호환성 함수
# 사용법: sed_i_bak 's/foo/bar/' filename
sed_i_bak() {
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        sed -i .bak "$@"
    else
        sed -i.bak "$@"
    fi
}

# date 날짜 계산 호환성 함수
# 사용법: date_offset "4 days ago" "+%Y%m%d"
date_offset() {
    local offset="$1"
    local format="$2"
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS: date -v-4d (offset 문자열 파싱 필요하지만, 간단히 예제에 맞춰 구현)
        # 예제에서 "N days ago" 형태만 사용하므로 이를 처리
        if [[ "$offset" =~ ([0-9]+)\ days\ ago ]]; then
            local days="${BASH_REMATCH[1]}"
            date -v-"${days}"d "$format"
        else
            date "$format" # fallback
        fi
    else
        # Linux
        date -d "$offset" "$format"
    fi
}

# touch 날짜 지정 호환성 함수
# 사용법: touch_d "4 days ago" filename
touch_d() {
    local offset="$1"
    local file="$2"
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        # macOS: touch -A -4d (offset 파싱 필요) 또는 date로 시간 구해서 -t 사용
        # 여기서는 date_offset을 이용해 YYYYMMDDhhmm 형식으로 변환 후 touch -t 사용
        local target_time
        # date_offset은 현재 포맷 인자를 받도록 되어있음.
        # touch -t [[CC]YY]MMDDhhmm[.ss]
        target_time=$(date_offset "$offset" "+%Y%m%d0000")
        touch -t "$target_time" "$file"
    else
        # Linux
        touch -d "$offset" "$file"
    fi
}

# ▣ [2] Cross-Platform Wrappers

# OS Detection
OS_NAME="$(uname)"

# Wrapper for sed -i (in-place editing without backup)
# Usage: sed_i [options] 'expression' file
sed_i() {
    if [[ "$OS_NAME" == "Darwin" ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# Wrapper for sed -i.bak (in-place editing with backup)
# Usage: sed_i_bak [options] 'expression' file
sed_i_bak() {
    if [[ "$OS_NAME" == "Darwin" ]]; then
        sed -i .bak "$@"
    else
        sed -i.bak "$@"
    fi
}

# Wrapper for date -d (relative date calculation)
# Usage: date_d "relative_date_string" "format_string"
# Example: date_d "4 days ago" "+%Y%m%d"
date_d() {
    local relative_date="$1"
    local format="$2"

    if [[ "$OS_NAME" == "Darwin" ]]; then
        # macOS: date -v-4d +%Y%m%d (requires parsing "4 days ago")
        # Simple parsing for "N days ago"
        if [[ "$relative_date" =~ ([0-9]+)\ days\ ago ]]; then
            local days="${BASH_REMATCH[1]}"
            date -v-"${days}"d "$format"
        else
            # Fallback or more complex parsing if needed
            echo "Error: Unsupported date format for macOS wrapper: $relative_date" >&2
            return 1
        fi
    else
        # Linux
        date -d "$relative_date" "$format"
    fi
}

# Wrapper for touch -d (set file modification time)
# Usage: touch_d "relative_date_string" file
# Example: touch_d "4 days ago" file
touch_d() {
    local relative_date="$1"
    local file="$2"

    if [[ "$OS_NAME" == "Darwin" ]]; then
        # macOS: touch -t YYYYMMDDhhmm
        # We need to convert relative date to this format
        # Use date_d logic to get the format
        if [[ "$relative_date" =~ ([0-9]+)\ days\ ago ]]; then
            local days="${BASH_REMATCH[1]}"
            local timestamp=$(date -v-"${days}"d +%Y%m%d%H%M)
            touch -t "$timestamp" "$file"
        else
             echo "Error: Unsupported date format for macOS touch wrapper: $relative_date" >&2
             return 1
        fi
    else
        # Linux
        touch -d "$relative_date" "$file"
    fi
}