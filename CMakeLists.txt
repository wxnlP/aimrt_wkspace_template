cmake_minimum_required(VERSION 3.24)

set(PROJECT_NAME WorkSpace)

# 修改默认的库文件、存档文件的存放位置
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

# 指定项目名称和语言支持
project(${PROJECT_NAME} LANGUAGES C CXX)

# 指定项目的C++版本
set(CMAKE_CXX_STANDARD 20)
# 强制编译器必须支持
set(CMAKE_CXX_STANDARD_REQUIRED ON)
# 禁用编译器扩展，确保代码兼容性
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
endif()

# 包含并执行 xx.cmake 文件
include(cmake/GetAimRT.cmake)
include(cmake/NamespaceTool.cmake)

# 添加子构建目录
add_subdirectory(src)