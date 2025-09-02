#!/bin/bash
PROJRCT_PATH="$(pwd)"
cd ${PROJRCT_PATH}/build/


./aimrt_main --cfg_file_path="./cfg/$1"