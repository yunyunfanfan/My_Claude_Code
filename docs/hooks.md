# Hooks 自动化工作流

Hooks 是在 Claude Code 生命周期特定点自动执行的 shell 命令、HTTP 端点或 LLM 提示。

## Hook 事件类型

| 事件 | 触发时机 |
|------|---------|
| `SessionStart` | 会话开始时 |
| `SessionEnd` | 会话结束时 |
| `PreToolUse` | 工具调用前 |
| `PostToolUse` | 工具调用后 |
| `PermissionRequest` | 权限请求时 |
| `PermissionDenied` | 权限被拒绝时 |
| `SubagentStart` | Subagent 启动时 |
| `SubagentStop` | Subagent 停止时 |
| `TaskCreated` | 任务创建时 |
| `TaskCompleted` | 任务完成时 |
| `PreCompact` | 压缩前 |
| `PostCompact` | 压缩后 |
| `WorktreeCreate` | Worktree 创建时 |
| `WorktreeRemove` | Worktree 删除时 |
| `Notification` | 通知时 |
| `ConfigChange` | 配置变更时 |
| `InstructionsLoaded` | 指令加载时 |
| `CwdChanged` | 工作目录变更时 |
| `FileChanged` | 文件变更时 |
| `Elicitation` | MCP 工具请求输入时 |
| `Stop` | 代理停止时 |
| `StopFailure` | 代理失败停止时 |

## 配置位置

Hooks 在 `settings.json` 中配置：

```
~/.claude/settings.json          # 用户级（所有项目）
.claude/settings.json            # 项目级（团队共享）
.claude/settings.local.json      # 本地级（不提交）
```

## 基本配置格式

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write $CLAUDE_FILE_PATHS"
          }
        ]
      }
    ]
  }
}
```

## Hook 类型

### 1. 命令 Hook（最常用）

```json
{
  "type": "command",
  "command": "your-shell-command",
  "timeout": 30000
}
```

### 2. HTTP Hook

```json
{
  "type": "http",
  "url": "https://your-webhook.com/endpoint",
  "method": "POST",
  "headers": {
    "Authorization": "Bearer token"
  }
}
```

### 3. LLM 提示 Hook

```json
{
  "type": "prompt",
  "prompt": "检查这个操作是否安全：$CLAUDE_TOOL_INPUT"
}
```

## 环境变量

Hooks 可以访问以下环境变量：

| 变量 | 描述 |
|------|------|
| `$CLAUDE_FILE_PATHS` | 受影响的文件路径 |
| `$CLAUDE_TOOL_NAME` | 当前工具名称 |
| `$CLAUDE_TOOL_INPUT` | 工具输入（JSON） |
| `$CLAUDE_TOOL_OUTPUT` | 工具输出（JSON） |
| `$CLAUDE_SESSION_ID` | 当前会话 ID |
| `$CLAUDE_CWD` | 当前工作目录 |

## 实用 Hook 示例

### 自动格式化代码

```json
{
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

### 自动运行 Lint

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "eslint --fix $CLAUDE_FILE_PATHS 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### 提交前运行测试

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash(git commit *)",
        "hooks": [
          {
            "type": "command",
            "command": "npm test"
          }
        ]
      }
    ]
  }
}
```

### 会话结束时发送通知

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e 'display notification \"Claude Code 任务完成\" with title \"Claude Code\"'"
          }
        ]
      }
    ]
  }
}
```

### 记录所有工具调用

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date): $CLAUDE_TOOL_NAME\" >> ~/.claude/tool-log.txt"
          }
        ]
      }
    ]
  }
}
```

### 阻止危险操作

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/check-dangerous.sh"
          }
        ]
      }
    ]
  }
}
```

`check-dangerous.sh`:
```bash
#!/bin/bash
# 从 stdin 读取工具输入
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.command // ""')

# 检查危险命令
if echo "$COMMAND" | grep -qE "rm -rf|DROP TABLE|format c:"; then
  echo '{"decision": "block", "reason": "检测到危险命令"}' 
  exit 0
fi

# 允许执行
exit 0
```

### 自动备份被编辑的文件

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash -c 'for f in $CLAUDE_FILE_PATHS; do [ -f \"$f\" ] && cp \"$f\" \"$f.bak\"; done'"
          }
        ]
      }
    ]
  }
}
```

### 调试：记录指令加载

```json
{
  "hooks": {
    "InstructionsLoaded": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"加载指令: $CLAUDE_INSTRUCTIONS_FILE\" >> ~/.claude/instructions-log.txt"
          }
        ]
      }
    ]
  }
}
```

## Hook 返回值控制

命令 Hook 可以通过 stdout 返回 JSON 来控制行为：

```bash
# 阻止操作
echo '{"decision": "block", "reason": "原因说明"}'

# 允许操作（默认）
exit 0

# 修改工具输入（PreToolUse）
echo '{"modified_input": {"command": "safe-command"}}'
```

## 异步 Hooks

对于不需要等待结果的操作，使用异步 hook：

```json
{
  "type": "command",
  "command": "your-command &",
  "async": true
}
```

## 在 Skills 中使用 Hooks

```yaml
---
name: deploy
description: 部署应用
hooks:
  PreToolUse:
    - matcher: "Bash(kubectl *)"
      hooks:
        - type: command
          command: "echo '正在执行 kubectl 命令...' | tee -a deploy.log"
---

部署应用到生产环境...
```

## 完整示例

参见 [examples/hooks/](../examples/hooks/) 目录。
