#!/usr/bin/env bash
# $1: TIL 날짜.
# 예를 들어 2022년 9월 24일인 경우, 파일명은 20220924.md이고, 커밋 메시지는 20220924이다.
# 스크립트가 있는 위치에서 ./push.sh 20220924를 실행하면 20220924.md 파일을 커밋하고 원격 저장소에 푸시한다.
cd ~/study/TIL/$(date "+%Y-%m") #2022-09

if [[ $1 == 'today' ]]; then
	git add $(date "+%Y%m%d").md &&
		git cm -m "$(date "+%Y%m%d")"
elif [[ $1 == 'yesterday' ]]; then
	git add $(date -v -1d '+%Y%m%d').md &&
		git cm -m "$(date -v -1d '+%Y%m%d')"
fi

git push origin main
