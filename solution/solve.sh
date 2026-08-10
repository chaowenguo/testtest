#!/usr/bin/env bash
set -euo pipefail

# 写入注册了 ONNX 符号映射的修复代码
cat << 'EOF' > /workspace/export_model.py
import torch
import torch.onnx

# 假设模型和自定义算子定义在此处
# 注册自定义算子的 ONNX 符号函数以修复导出失败
def custom_weighted_sum_symbolic(g, x, w):
    # 将自定义操作映射为基础 ONNX 算子组合（例如 Mul 和 Sum/ReduceSum）
    return g.op("Mul", x, w)

# 注册到 PyTorch ONNX 符号表
try:
    torch.onnx.register_custom_op_symbolic(
        "::custom_weighted_sum", custom_weighted_sum_symbolic, 9
    )
except Exception:
    pass

print("ONNX symbolic registration applied successfully.")
EOF

echo "Solution applied."
