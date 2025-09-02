cmake_minimum_required(VERSION 3.8)

# Get the current folder name
string(REGEX REPLACE ".*/\(.*\)" "\\1" CUR_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# Get namespace
get_namespace(CUR_SUPERIOR_NAMESPACE)
string(REPLACE "::" "_" CUR_SUPERIOR_NAMESPACE_UNDERLINE ${CUR_SUPERIOR_NAMESPACE})

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)

set(CUR_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
set(CUR_PACKAGE_NAME ${CUR_DIR})
set(CUR_TARGET_NAME ${CUR_SUPERIOR_NAMESPACE_UNDERLINE}_${CUR_DIR})
set(CUR_TARGET_ALIAS_NAME ${CUR_SUPERIOR_NAMESPACE}::${CUR_DIR})

project(${CUR_PACKAGE_NAME})

set(BUILD_SHARED_LIBS ON)

# 注册消息接口（开发者添加）
rosidl_generate_interfaces(
  ${CUR_PACKAGE_NAME}
  "msg/ChnInfo.msg"
  "srv/RpcInfo.srv"
)

set(BUILD_SHARED_LIBS ${CUR_BUILD_SHARED_LIBS})


if(NOT TARGET ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp)
  add_library(${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp ALIAS ${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp)
endif()

if(NOT TARGET ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp)
  add_library(${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp ALIAS ${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp)
endif()

# 注册RPC接口（开发者添加）
add_ros2_aimrt_rpc_gencode_target_for_one_file(
  TARGET_NAME ${CUR_TARGET_NAME}_rpc_gencode
  PACKAGE_NAME ${CUR_PACKAGE_NAME}
  PROTO_FILE ${CMAKE_CURRENT_SOURCE_DIR}/srv/RpcInfo.srv
  GENCODE_PATH ${CMAKE_CURRENT_BINARY_DIR}
  DEP_PROTO_TARGETS
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_generator_cpp
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_introspection_cpp
)
add_library(${CUR_TARGET_ALIAS_NAME}_rpc_gencode ALIAS ${CUR_TARGET_NAME}_rpc_gencode)

ament_export_dependencies(rosidl_default_runtime)
ament_package()
