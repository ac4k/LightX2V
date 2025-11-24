# LightX2V W4 量化编译安装说明

本文档说明如何编译和安装 LightX2V 的 W4 量化内核。

## 步骤 1: 克隆 CUTLASS

首先需要克隆 NVIDIA CUTLASS 仓库：

```bash
git clone https://github.com/NVIDIA/cutlass.git
```

建议将 CUTLASS 克隆到一个便于访问的位置，并记录其绝对路径，后续步骤需要使用。

## 步骤 2: 修改并执行构建脚本

进入 `lightx2v_kernel` 目录：

```bash
cd lightx2v_kernel
```

编辑 `build.sh` 文件，修改其中关于 CUTLASS 路径的参数。找到以下行：

```bash
-Ccmake.define.CUTLASS_PATH=/home/qiuyao/cutlass
```

将其中的 `/home/qiuyao/cutlass` 替换为你实际克隆的 CUTLASS 目录的绝对路径。

或者使用绝对路径：

```bash
-Ccmake.define.CUTLASS_PATH=/path/to/your/cutlass
```

修改完成后，执行构建脚本：

```bash
./build.sh
```

## 步骤 3: 安装编译好的 wheel 包

构建完成后，wheel 文件会生成在 `lightx2v_kernel/dist` 目录下。

进入该目录并安装：

```bash
cd dist
pip3 install lightx2v_kernel*.whl --force-reinstall --no-deps
```

## 步骤 4: 量化模型权重

在 `LightX2V` 目录下，执行量化脚本：

```bash
./quantize_weight_nvfp4.sh /path/to/source_model /path/to/dest_model
```

**重要提示：**

- `source_model` 和 `dest_model` 路径必须具体地指定到 `high noise` 或者 `low noise` 路径
- 也就是说，如果要完整地量化高噪声和低噪声的 DiT 模型，此脚本需要使用不同噪声路径执行两次

**示例：**

假设源模型路径结构如下：
```
/path/to/source_model/
├── high_noise/
│   └── ...
└── low_noise/
    └── ...
```

那么需要执行两次：

1. 量化高噪声模型：
```bash
./quantize_weight_nvfp4.sh /path/to/source_model/high_noise /path/to/dest_model/high_noise
```

2. 量化低噪声模型：
```bash
./quantize_weight_nvfp4.sh /path/to/source_model/low_noise /path/to/dest_model/low_noise
```

## 注意事项

- 确保已安装必要的依赖，如 `torch`，`scikit_build_core` 和 `uv`
- 确保系统已安装 CUDA 工具包
- 量化脚本会进行权重量化（weight-only quantization），激活值不会被量化
