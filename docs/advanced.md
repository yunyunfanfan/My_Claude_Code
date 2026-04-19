# 进阶用法和技巧

## 并行 Subagents

### 使用 /batch 并行处理

```bash
# 并行迁移整个代码库
/batch migrate src/ from JavaScript to TypeScript

# 并行添加测试
/batch add unit tests for all files in src/utils/

# 并行重构
/batch refactor all API handlers to use async/await
```

### 手动启动多个会话

```bash
# 使用 git worktree 并行工作
claude -w feature-auth    # 在 worktree 中处理认证功能
claude -w feature-payment # 在另一个 worktree 中处理支付功能

# 带 tmux 的并行会话
claude -w feature-auth --tmux
claude -w feature-payment --tmux
```

## Git Worktree 工作流

```bash
# 创建隔离的 worktree 会话
claude -w my-feature

# 自动生成名称
claude -w

# 带 tmux 面板
claude -w my-feature --tmux

# 带 tmux（经典模式）
claude -w my-feature --tmux=classic
```

## 计划任务

### 会话内循环

```bash
# 每 5 分钟检查部署状态
/loop 5m check if the deploy finished

# 每小时审查 PR
/loop 1h review new PRs and comment

# 持续监控
/loop 30s check for new errors in Sentry
```

### 云端计划任务

```bash
# 在会话中创建计划任务
/schedule

# 示例任务：
# - 每天早上 9 点审查 PR
# - 每周一分析依赖更新
# - 每晚分析 CI 失败
```

## 远程控制

```bash
# 启动支持远程控制的会话
claude --remote-control "My Project"
# 或
claude --rc "My Project"

# 从手机或其他设备通过 claude.ai 控制

# 在网络上创建新会话
claude --remote "Fix the login bug"

# 将网络会话拉入本地终端
claude --teleport
```

## 扩展思考模式

在 Skill 内容中包含 "ultrathink" 启用扩展思考：

```yaml
---
name: complex-analysis
description: 深度分析复杂问题
effort: max
---

ultrathink

分析以下架构决策的利弊：$ARGUMENTS

考虑：
1. 性能影响
2. 可维护性
3. 扩展性
4. 安全性
5. 团队学习曲线
```

## 结构化输出

```bash
# JSON 输出
claude -p --output-format json "列出所有 API 端点"

# 流式 JSON
claude -p --output-format stream-json "分析代码库"

# 符合 JSON Schema 的输出
claude -p --json-schema '{
  "type": "object",
  "properties": {
    "endpoints": {
      "type": "array",
      "items": {"type": "string"}
    }
  }
}' "列出所有 API 端点"
```

## 自定义 Subagents

在 `.claude/agents/` 中创建自定义 subagent：

```markdown
---
name: security-reviewer
description: 专注于安全审查的代理
model: claude-opus-4-6
effort: high
tools:
  - Read
  - Grep
  - Glob
---

你是一个专业的安全审查员，专注于：
- OWASP Top 10 漏洞
- 代码注入风险
- 认证和授权问题
- 数据泄露风险

审查代码时，提供：
1. 发现的安全问题（按严重程度排序）
2. 具体的修复建议
3. 相关的安全最佳实践
```

## 管道和脚本化使用

```bash
# 分析日志
tail -200 app.log | claude -p "如果发现异常请告诉我"

# CI 中自动化代码审查
git diff main --name-only | claude -p "审查这些变更文件的安全问题"

# 批量处理文件
find src -name "*.ts" | claude -p "找出所有使用 any 类型的地方"

# 生成发布说明
git log v1.0.0..HEAD --oneline | claude -p "生成用户友好的发布说明"

# 自动翻译
claude -p "将 locales/en.json 中的新字符串翻译成中文并更新 locales/zh.json"

# 限制预算的自动化
claude -p --max-budget-usd 2.00 --max-turns 10 "修复所有 TypeScript 错误"
```

## 最小模式（Bare Mode）

用于快速脚本化调用：

```bash
# 跳过 hooks、skills、MCP、CLAUDE.md
claude --bare -p "快速查询"

# 适合 CI/CD 中的简单任务
claude --bare -p "检查语法错误" < file.ts
```

## 环境变量配置

```bash
# 禁用自动记忆
CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude

# 设置 MCP 超时
MCP_TIMEOUT=10000 claude

# 增加 MCP 输出限制
MAX_MCP_OUTPUT_TOKENS=50000 claude

# 启用工具搜索
ENABLE_TOOL_SEARCH=true claude

# 调试日志目录
CLAUDE_CODE_DEBUG_LOGS_DIR=/tmp/claude-logs claude

# 最小模式
CLAUDE_CODE_SIMPLE=1 claude
```

## settings.json 高级配置

```json
{
  "model": "claude-opus-4-6",
  "defaultMode": "acceptEdits",
  "autoMemoryEnabled": true,
  "autoMemoryDirectory": "~/my-memory",
  
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm *)",
      "Read",
      "Edit",
      "Write"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)"
    ]
  },
  
  "env": {
    "NODE_ENV": "development",
    "API_BASE_URL": "http://localhost:3000"
  },
  
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write $CLAUDE_FILE_PATHS 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

## 与 CI/CD 集成

### GitHub Actions

```yaml
name: Claude Code Review
on:
  pull_request:
    types: [opened, synchronize]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Claude Code Review
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          claude -p --max-turns 5 \
            "审查这个 PR 的代码质量和安全性，提供具体改进建议"
```

### GitLab CI

```yaml
claude-review:
  image: node:20
  script:
    - npm install -g @anthropic-ai/claude-code
    - git diff origin/main --name-only | claude -p "审查变更文件"
  only:
    - merge_requests
```

## Chrome 浏览器集成

```bash
# 启用 Chrome 集成
claude --chrome

# 在会话中使用
# "打开 https://example.com 并截图"
# "测试登录表单"
# "检查控制台错误"
```

## 多模型策略

```bash
# 使用 Opus 处理复杂任务
claude --model claude-opus-4-6 --effort max "设计系统架构"

# 使用 Sonnet 处理日常任务
claude --model claude-sonnet-4-6 "修复这个 bug"

# 设置回退模型
claude -p --fallback-model claude-sonnet-4-6 "query"
```

## 调试技巧

```bash
# 启用调试模式
claude --debug

# 调试特定类别
claude --debug "api,hooks"

# 排除某些类别
claude --debug "!statsig,!file"

# 写入调试日志文件
claude --debug-file /tmp/claude-debug.log

# 在会话中启用调试
/debug 描述你遇到的问题
```

## 上下文管理

```bash
# 压缩对话历史（保留重要信息）
/compact

# 清除对话
/clear

# 查看上下文窗口使用情况
# 在 VS Code 扩展中可视化查看
```

## 最佳实践

### 1. 项目初始化

```bash
# 自动生成 CLAUDE.md
/init

# 交互式初始化（包含 skills 和 hooks）
CLAUDE_CODE_NEW_INIT=1 /init
```

### 2. 会话命名

```bash
# 给会话起有意义的名字
claude -n "auth-refactor-2024"
claude -n "payment-integration"

# 之后恢复
claude -r "auth-refactor-2024"
```

### 3. 权限最小化

```json
// .claude/settings.json
{
  "permissions": {
    "allow": [
      "Read",
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(npm test)"
    ],
    "deny": [
      "Bash(rm *)",
      "Bash(sudo *)",
      "Bash(curl *)"
    ]
  }
}
```

### 4. 团队协作

```bash
# 提交项目级配置
git add .claude/settings.json
git add .claude/skills/
git add .mcp.json
git add CLAUDE.md

# 本地配置不提交
echo ".claude/settings.local.json" >> .gitignore
```
