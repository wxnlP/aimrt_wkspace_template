#!/bin/bash
if [ $# -ne 2 ]; then
    echo "用法: $0 <可执行文件> <配置文件>"
    exit 1
fi

PROJRCT_PATH="$(pwd)"
cd ${PROJRCT_PATH}/build/

./$1 ./cfg/$2