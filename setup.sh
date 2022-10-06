#!/usr/bin/env bash
# setup TIL file for specified date.
# ex1. ./setup.sh today -> makes 2022-10/20221003.md (if today is 2022-10-03)
# ex1. ./setup.sh yesterday -> makes 2022-10/20221002.md (if yesterday is 2022-10-02)

# 디렉토리가 이미 있으면 파일만 만들고, 아니면 먼저 디렉토리를 만든다

dir_today=~/study/TIL/$(date "+%Y-%m")
dir_yesterday=~/study/TIL/$(date -v -1d "+%Y-%m")
today=$(date "+%Y%m%d")
yesterday=$(date -v -1d '+%Y%m%d')
if [[ $1 == 'today' ]]; then # 파일이 이미 있을 경우?
	touch ${dir_today}/${today}.md &&
		vim ${dir_today}/${today}.md # til 문서를 바로 편집하는 경우가 대부분인데 파일 이름을 확인하고 입력하는과정이 번거롭다. 바로 파일을 편집하자.
elif [[ $1 == 'yesterday' ]]; then
	touch ${dir_yesterday}/${yesterday}.md &&
		vim ${dir_yesterday}/${yesterday}.md
fi
