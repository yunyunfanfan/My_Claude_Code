---
name: review-pr
description: 审查 GitHub PR 的代码质量、安全性和最佳实践。当用户要求审查 PR 或代码变更时使用。
argument-hint: "[pr-number]"
disable-model-invocation: true
allowed-tools: Bash(gh *) Read Grep
---

# PR 代码审查

审查 PR #$ARGUMENTS

## 获取 PR 信息

PR 详情：!`gh pr view $ARGUMENTS 2>/dev/null || echo "请提供 PR 号码"`
变更文件：!`gh pr diff $ARGUMENTS --name-only 2>/dev/null`
代码差异：!`gh pr diff $ARGUMENTS 2>/dev/null`

## 审查维度

请从以下维度进行审查：

### 1. 代码质量
- 代码可读性和清晰度
- 命名规范是否一致
- 是否有重复代码（DRY 原则）
- 函数/方法是否职责单一

### 2. 安全性
- SQL 注入风险
- XSS 漏洞
- 命令注入
- 敏感数据暴露
- 认证/授权问题

### 3. 性能
- 不必要的数据库查询（N+1 问题）
- 内存泄漏风险
- 同步阻塞操作
- 缓存机会

### 4. 测试覆盖
- 是否有对应的测试
- 测试是否覆盖边界情况
- 测试是否有意义

### 5. 文档
- 复杂逻辑是否有注释
- API 变更是否更新文档
- CHANGELOG 是否更新

## 输出格式

请提供：
1. **总体评价**（通过/需要修改/阻止合并）
2. **必须修复的问题**（按严重程度排序）
3. **建议改进的地方**
4. **值得称赞的地方**
