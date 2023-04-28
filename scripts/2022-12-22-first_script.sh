#!/bin/bash
echo "OS: Linux"
echo "start"
echo "hello yang"
echo "end"

while getopts ":f:n:" opt; do
  case $opt in
    f) filename="$OPTARG"
    ;;
    n) count="$OPTARG"
    ;;
    \?) echo "无效的选项 -$OPTARG" >&2
    ;;
  esac
done

echo "输入的文件名是：$filename"
echo "输入的计数值是：$count"