#!/usr/bin/env bash
# setup TIL file for specified date.
# ex1. ./setup.sh today -> makes 2022-10/20221003.md (if today is 2022-10-03)
# ex1. ./setup.sh yesterday -> makes 2022-10/20221002.md (if yesterday is 2022-10-02)

# 디렉토리가 이미 있으면 파일만 만들고, 아니면 먼저 디렉토리를 만든다
arg=$1

case "$arg" in
	-d) shift
		arg=$1
		echo $arg
		;;
	-y | --yesterday) 
		arg='-1'
		echo $arg
		;;
	-t | --today)
		arg='-0'
		echo $arg
		;;
esac

til_dir=~/study/TIL/$(date -v ${arg}d "+%Y-%m")
til_file_prefix=$(date -v ${arg}d "+%Y%m%d")

echo "setting up til " ${arg} "day from today: " $(date -v ${arg}d "+%Y-%m-%d") >&2
echo "directory is " ${til_dir} >&2
echo "and file prefix is " ${til_file_prefix} >&2

if [ ! -d ${til_dir} ]; then
	mkdir ${til_dir} && cd ${til_dir}
else
	cd ${til_dir}
fi
# til 문서를 바로 편집하는 경우가 대부분인데 파일 이름을 확인하고 입력하는과정이 번거롭다. 바로 파일을 편집하자.
touch ${til_dir}/${til_file_prefix}.md && vim ${til_dir}/${til_file_prefix}.md
