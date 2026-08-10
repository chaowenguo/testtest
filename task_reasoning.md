This task tests the gap between dynamic Python execution and production static-graph intermediate representations (IRs). It targets a common production failure mode where custom extensions work fine in eager mode but break during deployment model packaging due to missing symbolic mappings. It evaluates an agent's understanding of PyTorch's ONNX export metadata and meta-programming hooks.

* **Category:** Compiler/graph work
