import os
import pytest
import torch
import torch.library

# 1. 在测试脚本中直接定义并注册 PyTorch 基础算子
@torch.library.custom_op("custom_ops::custom_weighted_sum", mutates_args=())
def custom_weighted_sum(x: torch.Tensor, w: torch.Tensor) -> torch.Tensor:
    return x * w.unsqueeze(-1) if x.ndim > w.ndim else x * w

@custom_weighted_sum.register_fake
def _(x: torch.Tensor, w: torch.Tensor) -> torch.Tensor:
    return x * w.unsqueeze(-1) if x.ndim > w.ndim else x * w


class CustomOpModel(torch.nn.Module):
    def forward(self, x, w):
        return torch.ops.custom_ops.custom_weighted_sum(x, w)


def test_onnx_export_success():
    """验证模型能够成功进行 ONNX 导出，不会因为缺少符号注册而崩溃（Fail-to-Pass）"""
    model = CustomOpModel()
    dummy_x = torch.randn(4, 4, dtype=torch.float32)
    dummy_w = torch.randn(4, dtype=torch.float32)

    onnx_path = "/workspace/model.onnx"

    # 当缺少自定义算子的 ONNX 符号注册时，torch.onnx.export 会抛出异常崩溃
    try:
        torch.onnx.export(
            model,
            (dummy_x, dummy_w),
            onnx_path,
            export_params=True,
            opset_version=14,
            do_constant_folding=True,
            input_names=['input_x', 'input_w'],
            output_names=['output']
        )
        assert os.path.exists(onnx_path), "ONNX model file was not successfully generated."
    except Exception as e:
        pytest.fail(f"ONNX export failed due to unregistered custom operator or graph translation error: {e}")
