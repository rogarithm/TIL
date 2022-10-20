#!/usr/bin/env bash
# $1: TIL 날짜.
# 예를 들어 2022년 9월 24일인 경우, 파일명은 20220924.md이고, 커밋 메시지는 20220924이다.
# 스크립트가 있는 위치에서 ./push.sh 20220924를 실행하면 20220924.md 파일을 커밋하고 원격 저장소에 푸시한다.
dir_name=$(date "+%Y-%m")
day=""
echo "DIRECTORY NAME: " ${dir_name} >&2
cd ~/study/TIL/${dir_name} #2022-09

char=$1
case "$char"
	in
	-y | --yesterday) day=$(date -v -1d '+%Y%m%d');;
	-t | --today) day=$(date "+%Y%m%d");;
esac

sed -i -e "s/^	/  /g" ${day}.md # 자동 줄바꿈시 들어가는 탭 문자를 빈칸 두 개로 바꾼다.

echo "ADDING TIL OF " ${day} >&2
git add ${day}.md && git cm -m "${day}"

echo "PUSH TO REMOTE REPOSITORY..." >&2
git push origin main
