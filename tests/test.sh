#!/usr/bin/env bash
set -u

# 1. 创建 reward 输出目录（如果 Harbor 需要）
mkdir -p /logs/verifier

# 2. 运行 pytest 测试，并捕获退出状态码
pytest /tests/test_behavior.py
EXIT_CODE=$?

# 3. 根据 pytest 的结果判定得分并写入 reward.txt
if [ $EXIT_CODE -eq 0 ]; then
    echo "1.0" > /logs/verifier/reward.txt
    echo "Tests passed successfully!"
    exit 0
else
    echo "0.0" > /logs/verifier/reward.txt
    echo "Tests failed with exit code $EXIT_CODE"
    exit $EXIT_CODE
fi
