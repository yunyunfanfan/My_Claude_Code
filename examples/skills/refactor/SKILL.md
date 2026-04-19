---
name: refactor
description: 重构指定文件或函数，提升可读性和可维护性，不改变外部行为
argument-hint: "[file-path 或 function-name]"
allowed-tools: Read Write Edit Glob Grep Bash(npm test --) Bash(npx jest --) Bash(python -m pytest --)
---

# 重构代码

## 目标

$ARGUMENTS

## 重构原则

1. **不改变外部行为** — 重构前后功能完全一致
2. **最小化变更** — 只改需要改的，不顺手重构周边代码
3. **保持测试通过** — 重构后运行测试确认无回归

## 执行步骤

1. 读取目标文件/函数，理解当前实现
2. 识别具体问题：
   - 过长的函数（超过 50 行考虑拆分）
   - 重复代码（DRY 原则）
   - 不清晰的命名
   - 过深的嵌套（超过 3 层）
   - 魔法数字/字符串
3. 制定重构方案，说明每处改动的理由
4. 执行重构
5. 运行测试验证行为不变

## 输出

- 重构后的代码
- 每处改动的简短说明
- 测试运行结果
