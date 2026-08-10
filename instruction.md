# Overview
An existing PyTorch model containing a custom C++ operation (`custom_ops::custom_weighted_sum`) runs successfully in eager mode, but fails during ONNX export. The ONNX exporter cannot translate the custom node into the static graph IR because it lacks proper symbolic-trace registration.

## Involved Files and Functions
* **File:** `export_model.py` and the custom op registration file.
* **Function:** Model export logic utilizing `torch.onnx.export`.

## Expected vs. Actual Behavior
* **Expected Behavior:** The model exports cleanly to an ONNX file without raising schema or symbolic tracing errors, and the exported graph correctly represents the custom weighted sum operation.
* **Actual Behavior:** `torch.onnx.export` throws a runtime or exporter error indicating that the custom operator does not have a registered ONNX symbolic function.

## Constraints
* The solution must not alter the core functionality of the custom C++ operator's eager-mode execution.
* The registration must hook into PyTorch's ONNX symbolic registry correctly so that static graph translation succeeds.
