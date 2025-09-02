## 目录

- `pb/test/`
  - `info.proto`：自定义`protobuf`消息接口类型，`channel`使用。
  - `info_rpc.proto`：自定义`protobuf`消息接口类型，`rpc`使用。
- `ros2/test_msgs`
  - `msg`
    - `Info.msg`：自定义`ros2`消息接口类型，`channel`使用。
  - `srv`
    - `RpcInfo.srv`：自定义`ros2`消息接口类型，`rpc`使用。

- 示例：
  - [chn_protocols](https://github.com/wxnlP/aimrt_template/tree/main/WorkSpaceExample/src/chn_protocols)
  - [rpc](https://github.com/wxnlP/aimrt_template/tree/main/WorkSpaceExample/src/rpc)

## Channel

### Potobuf

新建子项目同级目录`protocols/pb/test`，新建文件`info.proto`存放消息接口，内容如下：

```protobuf
syntax = "proto3";


// 命名空间
package example.protocols.test;

message Info {
    uint64 time_stamp = 1;
    string info = 2;
}
```

`test`目录下新建`CMakeLists.txt`文件：

- 前三段是标准的获取父级命名空间和设置目标的配置。
- 第四段使用`AimRT`封装的`CMake`语法生成目标，并起一个别名。
- 最后是安装文件。（可选）

```cmake
# Get the current folder name
string(REGEX REPLACE ".*/\(.*\)" "\\1" CUR_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# Get namespace
get_namespace(CUR_SUPERIOR_NAMESPACE)
string(REPLACE "::" "_" CUR_SUPERIOR_NAMESPACE_UNDERLINE ${CUR_SUPERIOR_NAMESPACE})

# Set target name
set(CUR_TARGET_NAME ${CUR_SUPERIOR_NAMESPACE_UNDERLINE}_${CUR_DIR})
set(CUR_TARGET_ALIAS_NAME ${CUR_SUPERIOR_NAMESPACE}::${CUR_DIR})

# Generate 
add_protobuf_gencode_target_for_proto_path(
    TARGET_NAME     ${CUR_TARGET_NAME}_pb_gencode
    PROTO_PATH      ${CMAKE_CURRENT_SOURCE_DIR}
    GENCODE_PATH    ${CMAKE_CURRENT_BINARY_DIR}
)
add_library(${CUR_TARGET_ALIAS_NAME}_pb_gencode ALIAS ${CUR_TARGET_NAME}_pb_gencode)

# Set installation
install(
  DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  DESTINATION "share"
  FILES_MATCHING
  PATTERN "*.proto")

set_property(TARGET ${CUR_TARGET_NAME}_pb_gencode PROPERTY EXPORT_NAME ${CUR_TARGET_ALIAS_NAME}_pb_gencode)
install(
  TARGETS ${CUR_TARGET_NAME}_pb_gencode
  EXPORT ${INSTALL_CONFIG_NAME}
  ARCHIVE DESTINATION lib
          FILE_SET HEADERS
          DESTINATION include/${CUR_TARGET_NAME}_pb_gencode)
```

`protocols`目录下新建`CMakeLists.txt`文件：

```cmake
# Set namespace
set_namespace()

add_subdirectory(pb/test)
```

最后将`protocols`目录包含进编译文件就好了，使用接口时包含`example::protocols::test_pb_gencode`依赖。

### Ros2

新建子项目同级目录`protocols/ros2`，在该目录下新建`ros2`功能包：

```bash
ros2 pkg create test_msgs --build-type ament_cmake --dependencies rosidl_default_generators --license Apache-2.0
```

> 更多`ros2`内容推荐：[ROS2 - 小李的知识库](https://tonmoon.top/study/ROS2/4-工作空间与功能包/)

`test_msgs`下新建`msg/Info.msg`添加如下内容：

```
uint64 time_stamp
string info
```

修改`CMakeLists.txt`：

```cmake
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

# 注册消息接口
rosidl_generate_interfaces(
  ${CUR_PACKAGE_NAME}
  "msg/Info.msg"
)

set(BUILD_SHARED_LIBS ${CUR_BUILD_SHARED_LIBS})


if(NOT TARGET ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp)
  add_library(${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp ALIAS ${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp)
endif()

if(NOT TARGET ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp)
  add_library(${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp ALIAS ${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp)
endif()

ament_export_dependencies(rosidl_default_runtime)
ament_package()
```

`protocols`目录下`CMakeLists.txt`文件添加依赖：

```cmake
# Set namespace
set_namespace()

add_subdirectory(pb/test)
add_subdirectory(ros2/test_msgs)
```

使用接口时包含如下依赖：

```cmake
test_msgs::test_msgs__rosidl_generator_cpp
test_msgs::test_msgs__rosidl_typesupport_cpp
test_msgs::test_msgs__rosidl_typesupport_fastrtps_cpp
test_msgs::test_msgs__rosidl_typesupport_introspection_cpp
```

**特别注意**

使用自定义`ros2`包时要把其添加到环境变量：

```bash
source ./build/install/share/test_msgs/local_setup.zsh
```

## Rpc

### Protobuf

新建子项目同级目录`protocols/pb/test`，新建文件`info_rpc.proto`存放消息接口，内容如下：

```protobuf
syntax = "proto3";

// 命名空间
package example.protocols.test;

message RpcInfoReq {
    uint64 time_stamp = 1;
    string info = 2;
}

message RpcInfoRes {
    uint64 req_stamp = 1;
    uint64 res_stamp = 2;
    string info = 3;
}

service InfoRpc {
    rpc GetRpcInfo (RpcInfoReq) returns (RpcInfoRes);
}
```

需要注意几个参数：

- `InfoRpc`：服务名称，作为一些生成的类的前缀。
- `GetRpcInfo`：核心`rpc`调用函数，客户端使用。
- `RpcInfoReq`和`RpcInfoRes`：`rpc`的请求和响应的数据结构名称。

在`chn_protocols`基础上，需要将`info_rpc.proto`加入编译，同样使用`AimRT`官方提供的`CMake`方法：

```cmake
add_protobuf_aimrt_rpc_gencode_target_for_proto_files(
  TARGET_NAME       ${CUR_TARGET_NAME}_aimrt_rpc_gencode
  PROTO_FILES       ${CMAKE_CURRENT_SOURCE_DIR}/info_rpc.proto
  GENCODE_PATH      ${CMAKE_CURRENT_BINARY_DIR}
  DEP_PROTO_TARGETS ${CUR_TARGET_NAME}_pb_gencode
)
add_library(${CUR_TARGET_ALIAS_NAME}_aimrt_rpc_gencode ALIAS ${CUR_TARGET_NAME}_aimrt_rpc_gencode)

set_property(TARGET ${CUR_TARGET_NAME}_aimrt_rpc_gencode PROPERTY EXPORT_NAME ${CUR_TARGET_ALIAS_NAME}_aimrt_rpc_gencode)
install(
  TARGETS ${CUR_TARGET_NAME}_aimrt_rpc_gencode
  EXPORT ${INSTALL_CONFIG_NAME}
  ARCHIVE DESTINATION lib
          FILE_SET HEADERS
          DESTINATION include/${CUR_TARGET_NAME}_aimrt_rpc_gencode)
```

需要注意，`add_protobuf_aimrt_rpc_gencode_target_for_proto_files`依赖于`add_protobuf_gencode_target_for_proto_path`，后者是对当前目录所有`.proto`文件作用，而后者进对单个指定`rpc`文件作用。

在模块中使用时，只需要添加如下依赖：

```cmake
example::protocols::test_aimrt_rpc_gencode
```

### Ros2

> 更多`ros2`内容推荐：[ROS2 - 小李的知识库](https://tonmoon.top/study/ROS2/4-工作空间与功能包/)

`test_msgs`下新建`msg/RpcInfo.srv`添加如下内容：

```
uint64 time_stamp
string info
---
uint64 req_stamp
uint64 res_stamp
string info
```

加入编译：

```cmake
# 注册消息接口
rosidl_generate_interfaces(
  ${CUR_PACKAGE_NAME}
  "msg/Info.msg"
  "srv/RpcInfo.srv"
)

add_ros2_aimrt_rpc_gencode_target_for_one_file(
  TARGET_NAME ${CUR_PACKAGE_NAME}_aimrt_rpc_gencode
  PACKAGE_NAME ${CUR_PACKAGE_NAME}
  PROTO_FILE ${CMAKE_CURRENT_SOURCE_DIR}/srv/RpcInfo.srv
  GENCODE_PATH ${CMAKE_CURRENT_BINARY_DIR}
  DEP_PROTO_TARGETS
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_generator_cpp
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp
    ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_introspection_cpp
)

add_library(${CUR_TARGET_ALIAS_NAME}_aimrt_rpc_gencode ALIAS ${CUR_TARGET_NAME}_aimrt_rpc_gencode)
```

在模块中使用时，只需要添加如下依赖：

```cmake
example::protocols::test_msgs_aimrt_rpc_gencode
```

**特别注意**

使用自定义`ros2`包时要把其添加到环境变量：

```bash
source ./build/install/share/test_msgs/local_setup.zsh
```
