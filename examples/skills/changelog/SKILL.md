---
name: changelog
description: 根据 git 提交记录生成 CHANGELOG。当用户说"生成更新日志"、"写 changelog"时使用。
argument-hint: "[v1.0.0..v2.0.0 或留空用最近记录]"
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# 生成 CHANGELOG

## 提交记录

!`git log ${ARGUMENTS:-$(git describe --tags --abbrev=0 2>/dev/null || echo "HEAD~20")..HEAD} --oneline --no-merges 2>/dev/null`

## 标签信息

!`git tag --sort=-version:refname | head -5`

## 生成规则

将提交记录按以下分类整理，生成标准 CHANGELOG 格式：

- **新功能 (Features)**：feat 类型的提交
- **Bug 修复 (Bug Fixes)**：fix 类型的提交
- **性能优化 (Performance)**：perf 类型的提交
- **破坏性变更 (Breaking Changes)**：含 BREAKING CHANGE 的提交
- **其他变更**：docs、chore、refactor 等

输出格式：

```markdown
## [版本号] - 日期

### 新功能
- 描述 (commit hash)

### Bug 修复
- 描述 (commit hash)
```

忽略 merge commit 和无意义的 chore 提交。
