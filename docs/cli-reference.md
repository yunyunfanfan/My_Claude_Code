# CLI 命令和标志完整参考

## 基础命令

| 命令 | 描述 | 示例 |
|------|------|------|
| `claude` | 启动交互式会话 | `claude` |
| `claude "query"` | 带初始提示启动 | `claude "解释这个项目"` |
| `claude -p "query"` | 非交互模式，打印后退出 | `claude -p "这个函数做什么"` |
| `cat file \| claude -p "query"` | 处理管道内容 | `cat logs.txt \| claude -p "分析错误"` |
| `claude -c` | 继续当前目录最近的对话 | `claude -c` |
| `claude -r "session"` | 按 ID 或名称恢复会话 | `claude -r "auth-refactor"` |
| `claude update` | 更新到最新版本 | `claude update` |

## 认证命令

```bash
claude auth login              # 登录 Anthropic 账户
claude auth login --console    # 使用 API 密钥登录
claude auth logout             # 登出
claude auth status             # 查看认证状态（JSON 格式）
claude auth status --text      # 查看认证状态（可读格式）
```

## MCP 管理命令

```bash
claude mcp add --transport http <name> <url>    # 添加 HTTP MCP 服务器
claude mcp add --transport sse <name> <url>     # 添加 SSE MCP 服务器
claude mcp add --transport stdio <name> -- <cmd> # 添加本地 stdio 服务器
claude mcp list                                  # 列出所有 MCP 服务器
claude mcp get <name>                            # 查看服务器详情
claude mcp remove <name>                         # 删除服务器
claude mcp serve                                 # 将 Claude Code 作为 MCP 服务器运行
```

## 其他管理命令

```bash
claude agents                  # 列出所有配置的 subagents
claude auto-mode defaults      # 查看 auto mode 分类器规则
claude plugin install <name>   # 安装插件
claude plugin list             # 列出插件
claude remote-control          # 启动远程控制服务器
```

## 常用 CLI 标志

### 会话控制

| 标志 | 描述 | 示例 |
|------|------|------|
| `--continue, -c` | 继续最近的对话 | `claude -c` |
| `--resume, -r` | 按 ID 或名称恢复会话 | `claude -r "my-session"` |
| `--name, -n` | 为会话设置名称 | `claude -n "feature-work"` |
| `--fork-session` | 恢复时创建新会话 ID | `claude -r abc123 --fork-session` |
| `--session-id` | 使用特定会话 ID | `claude --session-id "uuid"` |

### 模型和性能

| 标志 | 描述 | 示例 |
|------|------|------|
| `--model` | 指定模型 | `claude --model claude-opus-4-6` |
| `--effort` | 设置工作量级别 | `claude --effort high` |
| `--max-turns` | 限制代理轮数 | `claude -p --max-turns 3 "query"` |
| `--max-budget-usd` | 设置最大预算 | `claude -p --max-budget-usd 5.00 "query"` |

### 权限控制

| 标志 | 描述 | 示例 |
|------|------|------|
| `--permission-mode` | 设置权限模式 | `claude --permission-mode plan` |
| `--allowedTools` | 允许特定工具 | `--allowedTools "Bash(git *)" "Read"` |
| `--disallowedTools` | 禁用特定工具 | `--disallowedTools "Edit"` |
| `--tools` | 限制可用工具 | `--tools "Bash,Edit,Read"` |
| `--dangerously-skip-permissions` | 跳过权限提示 | `claude --dangerously-skip-permissions` |

### 系统提示

| 标志 | 描述 | 示例 |
|------|------|------|
| `--system-prompt` | 替换整个系统提示 | `claude --system-prompt "你是 Python 专家"` |
| `--system-prompt-file` | 从文件加载系统提示 | `claude --system-prompt-file ./prompt.txt` |
| `--append-system-prompt` | 追加到默认提示 | `claude --append-system-prompt "始终用 TypeScript"` |
| `--append-system-prompt-file` | 从文件追加 | `claude --append-system-prompt-file ./rules.txt` |

### 输出格式

| 标志 | 描述 | 示例 |
|------|------|------|
| `--output-format` | 指定输出格式 | `claude -p "query" --output-format json` |
| `--verbose` | 详细日志 | `claude --verbose` |
| `--debug` | 调试模式 | `claude --debug "api,hooks"` |
| `--debug-file` | 调试日志写入文件 | `claude --debug-file /tmp/debug.log` |

### 工作区

| 标志 | 描述 | 示例 |
|------|------|------|
| `--add-dir` | 添加额外工作目录 | `claude --add-dir ../apps ../lib` |
| `--worktree, -w` | 在隔离 git worktree 中启动 | `claude -w feature-auth` |
| `--tmux` | 为 worktree 创建 tmux 会话 | `claude -w feature-auth --tmux` |

### 远程和集成

| 标志 | 描述 | 示例 |
|------|------|------|
| `--remote` | 创建新的网络会话 | `claude --remote "修复登录 bug"` |
| `--remote-control, --rc` | 启动支持远程控制的会话 | `claude --rc "My Project"` |
| `--teleport` | 在本地恢复网络会话 | `claude --teleport` |
| `--chrome` | 启用 Chrome 浏览器集成 | `claude --chrome` |
| `--ide` | 自动连接到 IDE | `claude --ide` |

### 高级选项

| 标志 | 描述 | 示例 |
|------|------|------|
| `--bare` | 最小模式，跳过 hooks/skills/MCP | `claude --bare -p "query"` |
| `--mcp-config` | 从文件加载 MCP 配置 | `claude --mcp-config ./mcp.json` |
| `--agent` | 指定代理 | `claude --agent my-custom-agent` |
| `--json-schema` | 结构化 JSON 输出 | `claude -p --json-schema '{}' "query"` |
| `--no-session-persistence` | 禁用会话持久化 | `claude -p --no-session-persistence "query"` |

## 权限模式

```bash
# 默认模式 - 需要确认危险操作
claude --permission-mode default

# 自动接受文件编辑
claude --permission-mode acceptEdits

# 计划模式 - 只规划不执行
claude --permission-mode plan

# 自动模式 - 自动分类操作
claude --permission-mode auto

# 跳过所有权限检查（危险！）
claude --permission-mode bypassPermissions
```

## 实用管道示例

```bash
# 分析日志
tail -200 app.log | claude -p "如果发现异常请告诉我"

# 代码审查
git diff main --name-only | claude -p "审查这些变更文件的安全问题"

# 批量翻译
claude -p "将新字符串翻译成中文并创建 PR"

# CI 中自动化
claude -p --max-turns 5 "运行测试并修复失败的用例"

# 结构化输出
claude -p --output-format json "列出所有 API 端点"

# 流式 JSON 输出
claude -p --output-format stream-json "分析代码库"
```

## 内置斜杠命令（交互模式）

| 命令 | 描述 |
|------|------|
| `/help` | 显示帮助 |
| `/compact` | 压缩对话历史 |
| `/clear` | 清除对话 |
| `/memory` | 查看和编辑记忆文件 |
| `/mcp` | 管理 MCP 服务器 |
| `/init` | 初始化 CLAUDE.md |
| `/resume` | 恢复会话 |
| `/rename` | 重命名当前会话 |
| `/schedule` | 创建计划任务 |
| `/loop [interval] <prompt>` | 按间隔重复运行提示 |
| `/batch <instruction>` | 并行编排大规模变更 |
| `/debug [description]` | 启用调试日志 |
| `/simplify [focus]` | 审查并优化最近变更 |
| `/desktop` | 将会话交给桌面应用 |
| `/teleport` | 将网络会话拉入终端 |
