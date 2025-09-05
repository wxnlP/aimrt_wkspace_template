## 目录

```
├── cmake ---------------------- // cmake工具包				
│   ├── GetAimRT.cmake --------- // 获取AimRT源码
│   └── NamespaceTool.cmake ---- // CMake命名空间方法
├── src ------------------------ // 子项目集
│   └── protocols -------------- // 协议包
├── tools ---------------------- // 工具
│   ├── change_workspace.sh ---- // 工作空间转移脚本（子项目添加到工作空间）
│   └── config_template.yaml --- // 子项目配置文件模板（aimrt_cli生成子项目）
├── build.sh ------------------- // 编译构建脚本
├── compile.sh ----------------- // 编译脚本（仅编译不重新构建）
├── pkg_start.sh --------------- // pkg启动脚本
├── setup.sh ------------------- // 环境变量更新脚本（使用ros2后端需要执行）
└── app_start.sh --------------- // app启动脚本
```

## 使用说明

### 创建工作空间

克隆源码并重命名为`WkSpace`：

```bash
git clone https://github.com/wxnlP/aimrt_wkspace_template.git WkSpace
```

为脚本添加执行权限：

```bash
chmod +x build.sh compile.sh pkg_start.sh setup.sh app_start.sh tools/change_workspace.sh
```

编译源码：

> 默认编译打开了`protobuf`和`ros2`支持，若不需要可以在`build.sh`注释。此外，所有下载源均是使用官方支持的`gitee`仓库，所以无需担心下载速度。默认编译选择使用`ninja`提速，可以自己修改使用`make`。

```bash
./build.sh
```

工作空间配置（可选）：

仓库默认提供的父级`CMake`命名空间为`wkspace`，项目名称为`WorkSpace`。在新建子项目时需要用到，所以建议想要更改的提前修改。

父级`CMake`命名空间修改`src/CMakeLists.txt`中的`set_root_namespace("wkspace")`。

项目名称修改`./CMakeLists.txt`中的`set(PROJECT_NAME WorkSpace)`。

### 添加子项目

仓库默认只提供`protocols`子项目，这是供开发者自定义协议使用的。添加子项目到工作空间需要借助`aimrt_cli`工具和`tools/change_workspace.sh`脚本。

进入`tools`目录进行操作：

```bash
cd tools
```

借助`config_template.yaml`模板生成一个子项目（保证子项目名称与文件中的`project_name`一致），例如：

```bash
aimrt_cli gen -p config_template.yaml -o template
```

转移工作空间：

```bash
# ./change_workspace.sh <子项目名称> <工作空间路径> <命名空间>
./change_workspace.sh ./template ~/aimrt_wkspace_template wkspace
```

