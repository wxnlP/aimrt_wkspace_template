## 目录

- `pb/example_pb`
  - `chn_info.proto`：自定义`protobuf`消息接口类型，`channel`使用。
  - `rpc_info.proto`：自定义`protobuf`消息接口类型，`rpc`使用。
- `ros2/example_ros2`
  - `msg`
    - `ChnInfo.msg`：自定义`ros2`消息接口类型，`channel`使用。
  - `srv`
    - `RpcInfo.srv`：自定义`ros2`消息接口类型，`rpc`使用。

- 示例：
  - [chn_protocols](https://github.com/wxnlP/aimrt_template/tree/main/WorkSpaceExample/src/chn_protocols)
  - [rpc](https://github.com/wxnlP/aimrt_template/tree/main/WorkSpaceExample/src/rpc)

## 协议包

该协议包为默认生成，由[aimrt_template](https://github.com/wxnlP/aimrt_template)中的协议包修改而来，其中重点做了以下调整：

1. 统一`protobuf`和`ros2`的接口调用命名空间（`[协议包]::[srv/msg/rpc/chn]::[协议接口]`）。
2. 规范目录结构，使用`pb`、`ros2`区分协议，使用`example_pb`、`example_ros2`不同目录名称区分依赖名称（扩展时需注意，`pb`和`ros2`下不应有相同名称的文件夹）。
3. 规范接口命名。

### 使用说明

**协议包依赖链接：**

- `protobuf`

  - `chn_info.proto`：链接依赖`wkspace::protocols::example_pb_chn_gencode`。
  - `rpc_info.proto`：链接依赖`wkspace::protocols::example_pb_rpc_gencode`。

- `ros2`

  - `ChnInfo.msg`：链接依赖
    - `example_ros2::example_ros2__rosidl_generator_cpp`
    - `example_ros2::example_ros2__rosidl_typesupport_cpp`
    - `example_ros2::example_ros2__rosidl_typesupport_fastrtps_cpp`
    - `example_ros2::example_ros2__rosidl_typesupport_introspection_cpp`

  - `RpcInfo.srv`：链接依赖`wkspace::protocols::example_ros2_rpc_gencode`

> 注意这里的`wkspace`是父级命名空间，可以在`src/CMakeLists.txt`中修改。

**头文件调用**

- `protobuf`
  - `chn_info.proto`：`#include "chn_info.pb.h"`
    - 接口命名空间：`example_pb::chn::[接口]`
  - `rpc_info.proto`：`#include "rpc_info.aimrt_rpc.pb.h"`
    - 接口命名空间：`example_pb::rpc::[接口]`
- `ros2`
  - `ChnInfo.msg`：`#include "example_ros2/msg/chn_info.hpp"`
    - 接口命名空间：`example_ros2::msg::[接口]`
  - `RpcInfo.srv`：`#include "RpcInfo.aimrt_rpc.pb.h"`
    - 接口命名空间：`example_ros2::srv::[接口]`

> 统一`protobuf`的接口命名空间与`ros2`一致，使用`chn`和`rpc`区分，类似`msg`和`srv`。

### 扩展说明

- `protobuf`

  - 添加`channel`协议：添加`xxx.proto`文件，无需修改`CMakeLists.txt`。
  - 添加`rpc`协议：添加`xxx.proto`文件，在`CMakeLists.txt`中的`add_protobuf_aimrt_rpc_gencode_target_for_proto_files`方法的`PROTO_FILES`后面追加文件路径即可。

- `ros2`

  - 添加`channel`协议：添加`msg/xxx.msg`文件，在`CMakeLists.txt`中的`rosidl_generate_interfaces`方法中追加文件路径。
  - 添加`rpc`协议：添加`srv/xxx.srv`文件，在`CMakeLists.txt`中的`rosidl_generate_interfaces`方法中追加文件路径，然后添加如下内容注册`RPC`接口：

  ```cmake
  # 注册RPC接口（开发者添加）
  add_ros2_aimrt_rpc_gencode_target_for_one_file(
    TARGET_NAME ${CUR_TARGET_NAME}_xxx
    PACKAGE_NAME ${CUR_PACKAGE_NAME}
    PROTO_FILE ${CMAKE_CURRENT_SOURCE_DIR}/srv/xxx.srv
    GENCODE_PATH ${CMAKE_CURRENT_BINARY_DIR}
    DEP_PROTO_TARGETS
      ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_generator_cpp
      ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_cpp
      ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_fastrtps_cpp
      ${CUR_PACKAGE_NAME}::${CUR_PACKAGE_NAME}__rosidl_typesupport_introspection_cpp
  )
  add_library(${CUR_TARGET_ALIAS_NAME}_xxx ALIAS ${CUR_TARGET_NAME}_xxx)
  ```

> 注意`ros2`的`rpc`协议生成需要为每个`srv`文件生成一个依赖，所以要保证这些依赖名称不同。

