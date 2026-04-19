# Skills 自定义命令指南

Skills 是 Claude Code 的可扩展命令系统，通过 `SKILL.md` 文件定义，可以用 `/skill-name` 调用。

## 基本概念

- Skills 存储在 `SKILL.md` 文件中
- 通过 `/skill-name` 直接调用，或由 Claude 自动触发
- 支持参数传递、动态上下文注入、subagent 执行

## 文件位置

| 位置 | 路径 | 适用范围 |
|------|------|---------|
| 个人 | `~/.claude/skills/<name>/SKILL.md` | 所有项目 |
| 项目 | `.claude/skills/<name>/SKILL.md` | 当前项目 |
| 旧格式 | `.claude/commands/<name>.md` | 当前项目（兼容） |

## Frontmatter 字段参考

```yaml
---
name: skill-name              # Skill 名称（变成 /skill-name）
description: "描述和触发条件"  # Claude 用来决定何时使用
argument-hint: "[参数提示]"   # 自动补全时显示的提示
disable-model-invocation: true # 防止 Claude 自动触发（默认 false）
user-invocable: false         # 从 / 菜单隐藏（默认 true）
allowed-tools: "Read Grep"    # 允许使用的工具（空格分隔）
model: claude-opus-4-6        # 指定模型
effort: high                  # 工作量级别：low/medium/high/max
context: fork                 # 在 subagent 中运行
agent: Explore                # subagent 类型
paths:                        # 路径限制（glob 模式）
  - "src/**/*.ts"
hooks:                        # Skill 生命周期 hooks
  PostToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "echo done"
---
```

## 字符串替换变量

| 变量 | 描述 |
|------|------|
| `$ARGUMENTS` | 所有传入参数 |
| `$ARGUMENTS[N]` | 第 N 个参数（0 基索引） |
| `$N` | `$ARGUMENTS[N]` 的简写 |
| `${CLAUDE_SESSION_ID}` | 当前会话 ID |
| `${CLAUDE_SKILL_DIR}` | Skill 文件所在目录 |

## 动态上下文注入

使用 `` !`command` `` 在发送给 Claude 前执行 shell 命令：

```yaml
---
name: pr-review
description: 审查当前 PR
---

## PR 信息
- 差异：!`gh pr diff`
- 评论：!`gh pr view --comments`
- 变更文件：!`gh pr diff --name-only`

请审查这个 PR 并提供改进建议。
```

## 内置 Skills

| Skill | 描述 |
|-------|------|
| `/batch <instruction>` | 并行编排大规模代码库变更 |
| `/claude-api` | 加载 Claude API 参考文档 |
| `/debug [description]` | 启用调试日志并排查问题 |
| `/loop [interval] <prompt>` | 按间隔重复运行提示 |
| `/simplify [focus]` | 审查并优化最近变更 |

## 示例 Skills

### 1. 代码审查

```yaml
---
name: review-pr
description: 审查 PR 代码质量、安全性和最佳实践
disable-model-invocation: true
allowed-tools: Bash(gh *) Read
---

审查 PR #$ARGUMENTS：

1. 获取 PR 信息：!`gh pr view $ARGUMENTS`
2. 获取代码差异：!`gh pr diff $ARGUMENTS`

请检查：
- 代码质量和可读性
- 潜在的安全问题
- 性能影响
- 测试覆盖率
- 是否符合项目规范

提供具体的改进建议。
```

### 2. 提交代码

```yaml
---
name: commit
description: 创建规范的 git 提交
disable-model-invocation: true
allowed-tools: Bash(git *)
---

为当前变更创建提交：

1. 运行 `git status` 查看变更
2. 运行 `git diff` 查看具体变更
3. 根据变更内容生成符合 Conventional Commits 规范的提交信息
4. 暂存所有变更并提交

提交信息格式：
- feat: 新功能
- fix: 修复 bug
- docs: 文档变更
- style: 代码格式
- refactor: 重构
- test: 测试
- chore: 构建/工具变更
```

### 3. 修复 GitHub Issue

```yaml
---
name: fix-issue
description: 修复 GitHub Issue
argument-hint: "[issue-number]"
disable-model-invocation: true
---

修复 GitHub Issue $ARGUMENTS：

1. 读取 Issue 详情：!`gh issue view $ARGUMENTS`
2. 理解需求和验收标准
3. 实现修复
4. 编写测试
5. 创建提交，提交信息引用 Issue #$ARGUMENTS
```

### 4. 生成文档

```yaml
---
name: gen-docs
description: 为指定文件或模块生成文档
argument-hint: "[file-path]"
allowed-tools: Read Write Glob
---

为 $ARGUMENTS 生成文档：

1. 读取源文件理解代码结构
2. 生成 JSDoc/TSDoc 注释
3. 更新或创建对应的 .md 文档文件
4. 确保文档准确反映代码功能
```

### 5. 安全审查

```yaml
---
name: security-review
description: 对变更进行安全审查，检查 OWASP Top 10 漏洞
context: fork
agent: Explore
---

对以下变更进行安全审查：

变更文件：!`git diff --name-only HEAD~1`
变更内容：!`git diff HEAD~1`

检查以下安全问题：
1. SQL 注入
2. XSS 跨站脚本
3. 命令注入
4. 不安全的直接对象引用
5. 敏感数据暴露
6. 身份验证和授权问题
7. 不安全的依赖

提供具体的修复建议。
```

### 6. 代码库可视化

```yaml
---
name: visualize
description: 生成代码库的交互式可视化树形图
allowed-tools: Bash(python *)
---

生成代码库可视化：

运行以下命令：
```bash
python ${CLAUDE_SKILL_DIR}/scripts/visualize.py .
```

这将在当前目录生成 `codebase-map.html` 并在浏览器中打开。
```

### 7. 性能分析

```yaml
---
name: perf-analyze
description: 分析代码性能瓶颈并提供优化建议
argument-hint: "[file-or-function]"
effort: high
---

分析 $ARGUMENTS 的性能：

1. 读取相关代码
2. 识别潜在的性能瓶颈：
   - 不必要的循环或递归
   - 重复的数据库查询（N+1 问题）
   - 内存泄漏风险
   - 同步阻塞操作
3. 提供具体的优化方案和代码示例
```

## 在 Subagent 中运行

使用 `context: fork` 在隔离环境中运行：

```yaml
---
name: deep-research
description: 深度研究代码库中的某个主题
context: fork
agent: Explore
---

深度研究：$ARGUMENTS

1. 使用 Glob 和 Grep 找到相关文件
2. 读取并分析代码
3. 总结发现，包含具体文件引用
```

## 共享 Skills

```bash
# 提交到版本控制（项目级共享）
git add .claude/skills/
git commit -m "add team skills"

# 个人 skills 在所有项目中可用
~/.claude/skills/
```

## 完整示例

参见 [examples/skills/](../examples/skills/) 目录。
