#!/usr/bin/env bash
set -euo pipefail

# 获取当前环境 site-packages 目录
PYTHON_SITE=$(python3 -c "import site; print(site.getsitepackages()[0])")

# 将 ONNX 符号注册注入到 sitecustomize.py 中
# 确保在不修改 /tests 目录的前提下，pytest 启动时全局自动导入
cat << 'EOF' > "${PYTHON_SITE}/sitecustomize.py"
import torch
import torch.onnx

def custom_weighted_sum_symbolic(g, x, w):
    return g.op("Mul", x, w)

try:
    torch.onnx.register_custom_op_symbolic(
        "custom_ops::custom_weighted_sum",
        custom_weighted_sum_symbolic,
        opset_version=14
    )
except Exception:
    pass
EOF

echo "Oracle patch applied cleanly without touching /tests."
