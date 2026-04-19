---
name: commit
description: 创建符合 Conventional Commits 规范的 git 提交
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# 创建规范提交

## 当前状态

变更文件：!`git status --short`
具体变更：!`git diff HEAD`

## 提交规范

使用 Conventional Commits 格式：

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### 类型（type）
- `feat`: 新功能
- `fix`: 修复 bug
- `docs`: 文档变更
- `style`: 代码格式（不影响功能）
- `refactor`: 重构（不是新功能也不是修复）
- `perf`: 性能优化
- `test`: 添加或修改测试
- `chore`: 构建过程或辅助工具变更
- `ci`: CI 配置变更
- `revert`: 回滚提交

### 范围（scope）
可选，表示影响的模块，如：`auth`, `api`, `ui`, `db`

### 示例
```
feat(auth): add OAuth2 login with GitHub
fix(api): handle null response from payment service
docs: update API documentation for v2 endpoints
```

## 执行步骤

1. 分析变更内容，确定提交类型和范围
2. 生成简洁、描述性的提交信息（英文，不超过 72 字符）
3. 如果变更复杂，添加详细的 body 说明
4. 如果关联 Issue，在 footer 添加 `Closes #123`
5. 暂存所有变更：`git add -A`
6. 创建提交

$ARGUMENTS
