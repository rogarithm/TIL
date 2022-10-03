#!/usr/bin/env bash
# $1: TIL 날짜.
# 예를 들어 2022년 9월 24일인 경우, 파일명은 20220924.md이고, 커밋 메시지는 20220924이다.
# 스크립트가 있는 위치에서 ./push.sh 20220924를 실행하면 20220924.md 파일을 커밋하고 원격 저장소에 푸시한다.
dir_name=$(date "+%Y-%m")
day=""
echo ${dir_name}
#cd ~/study/TIL/${dir_name} #2022-09

if [[ $1 == 'today' ]]; then
	day=$(date "+%Y%m%d")
	echo ${day}
	#git add ${day}.md && git cm -m "${day}"
elif [[ $1 == 'yesterday' ]]; then
	day=$(date -v -1d '+%Y%m%d')
	echo ${day}
	#git add ${day}.md && git cm -m "${day}"
fi

#git push origin main
