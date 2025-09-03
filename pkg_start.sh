#!/bin/bash
if [ $# -ne 1 ]; then
    echo "用法: $0 <配置文件>"
    exit 1
fi

PROJRCT_PATH="$(pwd)"
cd ${PROJRCT_PATH}/build/


./aimrt_main --cfg_file_path="./cfg/$1"