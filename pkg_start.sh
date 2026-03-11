#!/bin/bash

PROJECT_PATH="$(pwd)"
CFG_DIR="${PROJECT_PATH}/build/cfg"

# 如果没有提供参数，提供交互式菜单供用户选择
if [ $# -ne 1 ]; then
    
    # 检查 cfg 目录是否存在
    if [ ! -d "$CFG_DIR" ]; then
        echo "错误: 找不到目录 ${CFG_DIR}"
        exit 1
    fi

    # 1. 过滤逻辑：只获取 .yaml 结尾的文件，并排除目录
    shopt -s nullglob # 开启 nullglob，如果没有匹配的文件，变量为空而不是原样输出星号
    files=()
    for f in "${CFG_DIR}"/*.yaml; do
        # 判断是否为常规文件（过滤掉凑巧以 .yaml 结尾的目录）
        if [ -f "$f" ]; then
            files+=("$(basename "$f")") # 截取纯文件名，去掉前缀路径
        fi
    done
    shopt -u nullglob # 关闭 nullglob，恢复默认设置
    
    # 检查是否找到了有效的 yaml 文件
    if [ ${#files[@]} -eq 0 ]; then
         echo "错误: ${CFG_DIR} 目录下没有找到任何 .yaml 配置文件！"
         exit 1
    fi

    echo "未提供配置文件。请在以下列表中选择一个："
    
    # 修改 select 的默认提示符（原本是 #?）
    PS3="请输入对应数字 (或输入 q 退出): "
    
    # 2. 交互逻辑：使用 select 生成菜单，并处理 'q' 退出
    select cfg_file in "${files[@]}"; do
        # 检查用户的原始输入 (存储在内置变量 REPLY 中)
        if [[ "$REPLY" == "q" || "$REPLY" == "Q" ]]; then
            echo "已取消执行。"
            exit 0
        elif [ -n "$cfg_file" ]; then
            # 输入的是合法的数字，跳出循环
            break
        else
            # 输入了无效的字符或数字
            echo "无效的选择，请重新输入对应数字，或输入 q 退出。"
        fi
    done
else
    # 如果用户直接提供了参数，则直接使用
    cfg_file="$1"
fi

echo "----------------------------------------"
echo "正在使用的配置文件: ${cfg_file}"
echo "----------------------------------------"

cd "${PROJECT_PATH}/build/"
./aimrt_main --cfg_file_path="./cfg/${cfg_file}"