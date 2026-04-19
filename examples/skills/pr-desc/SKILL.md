---
name: pr-desc
description: 为当前分支生成 PR 描述。当用户说"写 PR 描述"、"生成 PR"时使用。
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# 生成 PR 描述

## 分支信息

当前分支：!`git branch --show-current`
基础分支：!`git merge-base HEAD main 2>/dev/null && echo "main" || git merge-base HEAD master 2>/dev/null && echo "master"`

## 变更内容

提交记录：!`git log main..HEAD --oneline 2>/dev/null || git log master..HEAD --oneline 2>/dev/null || git log HEAD~5..HEAD --oneline`
变更文件：!`git diff main --name-only 2>/dev/null || git diff master --name-only 2>/dev/null || git diff HEAD~5 --name-only`
代码差异：!`git diff main --stat 2>/dev/null || git diff HEAD~5 --stat`

## 生成 PR 描述

根据以上信息，生成一份完整的 PR 描述，格式如下：

```markdown
## 变更概述
[1-3 句话说明这个 PR 做了什么]

## 变更类型
- [ ] 新功能
- [ ] Bug 修复
- [ ] 重构
- [ ] 文档
- [ ] 其他

## 变更详情
[按文件或模块分组说明具体变更]

## 测试
- [ ] 已添加/更新单元测试
- [ ] 已手动测试主要流程
- [ ] 无需测试（文档/配置变更）

## 注意事项
[Reviewer 需要特别关注的地方，或已知的限制]
```

$ARGUMENTS
