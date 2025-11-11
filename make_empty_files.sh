#!/usr/bin/env bash
set -euo pipefail

# lessons 폴더 생성 및 이동
mkdir -p lessons && cd lessons

# 내용에 사용할 변수들을 정의
LINE1='#!/usr/bin/env bash'
LINE2='set -euo pipefail'
LINE3='echo'
LINE4='echo "========================"'
LINE5='echo "$(basename "$0") Start"'
LINE6='echo "========================"'
LINE7='echo'
LINE8='echo "========================"'
LINE9='echo "$(basename "$0") End"'
LINE10='echo "========================"'

# lesson01.sh부터 lesson30.sh까지 파일 생성 및 내용 채우기
for i in $(seq 1 30)
do
    # 숫자를 두 자리로 포맷팅
    filename="lesson$(printf "%02d" $i).sh"

    # 파일이 존재하지 않는 경우에만 생성
    if [ ! -f "$filename" ]; then
        echo "💡 $filename 파일이 존재하지 않으므로 생성합니다."
        echo "$LINE1" > "$filename"
        echo "$LINE2" >> "$filename"
        echo "$LINE3" >> "$filename"
        echo "$LINE4" >> "$filename"
        echo "$LINE5" >> "$filename"
        echo "$LINE6" >> "$filename"
        echo "$LINE7" >> "$filename"
        echo "$LINE8" >> "$filename"
        echo "$LINE9" >> "$filename"
        echo "$LINE10" >> "$filename"
    else
        echo "$filename 파일이 이미 존재합니다. 생성을 건너뜁니다."
    fi
done

echo "lessons 폴더와 lesson01.sh ~ lesson30.sh 파일 생성이 완료되었습니다."