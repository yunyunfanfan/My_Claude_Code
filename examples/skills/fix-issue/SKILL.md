---
name: fix-issue
description: 根据 GitHub Issue 实现修复。当用户说"修复 Issue #N"或"实现 Issue N 的功能"时使用。
argument-hint: "[issue-number]"
disable-model-invocation: true
allowed-tools: Bash(gh *) Bash(git *) Read Write Edit Grep Glob
---

# 修复 GitHub Issue

## Issue 详情

!`gh issue view $ARGUMENTS`

## 相关评论

!`gh issue view $ARGUMENTS --comments`

## 执行步骤

1. **理解需求**
   - 仔细阅读 Issue 描述和评论
   - 明确验收标准
   - 识别影响范围

2. **探索代码库**
   - 找到相关文件
   - 理解现有实现
   - 识别需要修改的地方

3. **实现修复**
   - 按照项目代码规范实现
   - 保持最小化变更原则
   - 不引入不必要的重构

4. **编写测试**
   - 为修复添加测试用例
   - 确保测试覆盖边界情况
   - 运行现有测试确保没有回归

5. **创建提交**
   - 提交信息格式：`fix: <描述> (closes #$ARGUMENTS)`
   - 或功能：`feat: <描述> (closes #$ARGUMENTS)`

6. **验证**
   - 运行相关测试
   - 确认修复解决了 Issue 描述的问题
