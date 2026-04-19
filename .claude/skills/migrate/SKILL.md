---
name: migrate
description: 将代码从一个框架/版本/模式迁移到另一个。当用户说"迁移"、"升级"、"从 X 改成 Y"时使用。
argument-hint: "[from] [to] 例如: React16 React18 / JavaScript TypeScript"
allowed-tools: Read Write Edit Glob Grep Bash(npm *) Bash(npx *)
---

# 代码迁移

## 迁移目标

从 $0 迁移到 $1

$ARGUMENTS

## 迁移步骤

### 1. 评估范围
- 扫描需要迁移的文件数量
- 识别迁移复杂度（简单替换 / 需要重写）
- 列出可能的破坏性变更

### 2. 制定计划
- 优先迁移基础模块，再迁移上层
- 每次迁移一个文件，保持可回滚
- 迁移后立即运行测试

### 3. 执行迁移
- 按计划逐文件迁移
- 保留原有逻辑，只改语法/API
- 标记需要人工确认的地方

### 4. 验证
- 运行完整测试套件
- 检查类型错误
- 确认功能行为不变

## 注意事项
- 不要在迁移中顺手重构业务逻辑
- 遇到不确定的地方先标注 `// TODO: verify after migration`
- 大文件考虑分批迁移
