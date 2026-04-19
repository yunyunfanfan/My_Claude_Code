---
name: gen-tests
description: 为指定文件或模块生成测试用例。当用户要求"写测试"、"添加测试"或"生成测试"时使用。
argument-hint: "[file-path]"
allowed-tools: Read Write Glob Grep Bash(npm test --) Bash(npx jest --) Bash(python -m pytest --)
---

# 生成测试用例

## 目标文件

$ARGUMENTS

## 执行步骤

1. **分析源代码**
   - 读取目标文件
   - 识别所有公共函数/方法/类
   - 理解每个函数的输入、输出和副作用

2. **检查现有测试**
   - 查找对应的测试文件
   - 了解项目的测试风格和约定

3. **生成测试用例**

   对每个函数/方法，生成：
   - **正常路径测试**：典型输入的预期输出
   - **边界条件测试**：空值、零值、最大值、最小值
   - **错误处理测试**：无效输入、异常情况
   - **集成测试**（如适用）：与其他模块的交互

4. **测试质量要求**
   - 测试名称清晰描述测试场景
   - 每个测试只测试一件事
   - 使用 AAA 模式（Arrange, Act, Assert）
   - Mock 外部依赖（数据库、API、文件系统）

5. **运行测试**
   - 运行生成的测试确保通过
   - 修复任何失败的测试

## 测试框架约定

根据项目使用的框架自动适配：
- TypeScript/JavaScript：Jest, Vitest, Mocha
- Python：pytest, unittest
- Go：testing 包
- Java：JUnit, TestNG
