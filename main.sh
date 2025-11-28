#!/usr/bin/env bash
set -euo pipefail

# 실행 경로 고정
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "▶ 스크립트 디렉터리: $SCRIPT_DIR"
LESSON_DIR="$SCRIPT_DIR/lessons"

source "$SCRIPT_DIR/lessons/utils.sh"

# 메뉴 목록
titles=(
    "($(get_random_emoji)) 쉘 기본기 리프레시"
    "($(get_random_emoji)) 경로/파일 다루기 기초"
    "($(get_random_emoji)) 리다이렉션 & 파이프라인"
    "($(get_random_emoji)) 따옴표 & 확장 규칙 완전정복"
    "($(get_random_emoji)) 변수, 환경, export"
    "($(get_random_emoji)) 조건식 & 테스트"
    "($(get_random_emoji)) 반복문 & 배열"
    "($(get_random_emoji)) 함수 & 스코프"
    "($(get_random_emoji)) 실전: 배치 리네이밍 스크립트"
    "($(get_random_emoji)) grep 입문 + 기본 정규표현식(ERE)"
    "($(get_random_emoji)) grep 고급: 그룹/대체/단어경계"
    "($(get_random_emoji)) sed 입문: 치환 & 필터"
    "($(get_random_emoji)) sed 고급: 인플레이스, 캡처/백레퍼런스"
    "($(get_random_emoji)) awk 입문: 필드 처리"
    "($(get_random_emoji)) awk 고급: 조건/형식화/딕셔너리/함수, .awk 스크립트 파일"
    "($(get_random_emoji)) 실전 파이프라인: grep | awk | sed"
    "($(get_random_emoji)) 정규표현식 집중 연습(1): 이메일/URL 패턴"
    "($(get_random_emoji)) 정규표현식 집중 연습(2): 한국 주민/전화/날짜 패턴"
    "($(get_random_emoji)) find & xargs & -exec"
    "($(get_random_emoji)) 여기문서(Heredoc) & 템플릿 생성"
    "($(get_random_emoji)) 파라미터 확장 고급"
    "($(get_random_emoji)) 에러처리 & 안전장치"
    "($(get_random_emoji)) 프로세스/잡/시그널"
    "($(get_random_emoji)) 서브셸 vs 현재 셸"
    "($(get_random_emoji)) CSV/TSV 파서 스크립트(awk 실전)"
    "($(get_random_emoji)) 로그 회전/압축/보관 스크립트"
    "($(get_random_emoji)) 설정파일 키-값 편집기(sed 중심)"
    "($(get_random_emoji)) 멀티스레드 흉내: xargs -P 병렬 처리"
    "($(get_random_emoji)) CLI 미니툴 배포 패키징"
    "($(get_random_emoji)) 통합 프로젝트: 로그 분석 및 리포트 생성기"
    "($(get_random_emoji)) 통합 프로젝트: To-Do 리스트 관리 툴"
)

# 메뉴 출력
print_menu() {
  echo "=============================="
  echo " Bash 학습 메뉴"
  echo "=============================="
  for i in $(seq 1 ${#titles[@]}); do
    printf " %2d) %s\n" "$i" "${titles[$((i-1))]}"
  done
  echo "------------------------------"
  echo " q) 종료"
  echo "------------------------------"
}

# 루프
while true; do
  print_menu
  read -rp "선택( 1 ~ 31, q to exit): " sel
  case "$sel" in
    q|Q)
      echo "학습을 종료합니다. 👋"
      exit 0
      ;;
    1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31)
      file="$(printf "%s/lesson%02d.sh" "$LESSON_DIR" "$sel")"
      if [[ -x "$file" ]]; then
        echo
        echo "--------------------------------"
        echo "🚀 실행: $(basename "$file")"
        echo "--------------------------------"
        "$file"
      else
        echo "❌ 해당 파일이 없거나 실행 권한이 없습니다."
      fi
      echo "--------------------------------"
      read -rp "💡 엔터를 누르면 메뉴로 돌아갑니다..." _
      ;;
    *)
      echo "🚩 잘못된 선택입니다."
      ;;
  esac
done
