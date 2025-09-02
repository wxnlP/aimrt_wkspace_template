#!/bin/bash
# 参数检查
if [ $# -ne 3 ]; then
    echo "用法: $0 <项目名> <工作空间路径> <命名空间前缀>"
    exit 1
fi

PJ_NAME=${1#./}
WK_SPACE=${2#./}
NAMESPACE=${3#./}

echo "开始工作空间转移......"

if [[ "$3" != "-1" && "$3" != "-a" ]]; then
    mkdir -p ${WK_SPACE}/src/${PJ_NAME}
    echo "完成工程目录创建."
else
    echo "跳过工程目录创建!"
fi

if [[ "$3" != "-2" && "$3" != "-a" ]]; then
    mv ${PJ_NAME}/src/* ${WK_SPACE}/src/${PJ_NAME}/
    rm -rf ${PJ_NAME}
    echo "完成文件转移."
else
    echo "跳过文件转移!"
fi

cd ${WK_SPACE}/src/${PJ_NAME}/
sed -i "2s/set_root_namespace(\"${PJ_NAME}\")/set_namespace()/" CMakeLists.txt
# 文本替换处理
find "./module" -type f \( -name "*.cc" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) \
  -exec sed -i.bak "s/${PJ_NAME}/${NAMESPACE}::${PJ_NAME}/g" {} +
find "./pkg" -type f \( -name "*.cc" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) \
  -exec sed -i.bak "s/${PJ_NAME}/${NAMESPACE}::${PJ_NAME}/g" {} +

cd ../
sed -i "\$a add_subdirectory(${PJ_NAME})" CMakeLists.txt

echo "完成CMake配置修改."

echo "完成工作空间转移."
