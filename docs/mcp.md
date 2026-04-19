# MCP 服务器集成指南

MCP（Model Context Protocol）是连接 Claude Code 与外部工具和数据源的开放标准。

## 安装 MCP 服务器

### HTTP 服务器（推荐）

```bash
# 基本语法
claude mcp add --transport http <name> <url>

# 示例
claude mcp add --transport http notion https://mcp.notion.com/mcp
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# 带认证头
claude mcp add --transport http secure-api https://api.example.com/mcp \
  --header "Authorization: Bearer your-token"
```

### 本地 stdio 服务器

```bash
# 基本语法
claude mcp add --transport stdio <name> -- <command> [args...]

# 示例：PostgreSQL
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://user:pass@localhost:5432/mydb"

# 示例：文件系统
claude mcp add --transport stdio filesystem -- npx -y @modelcontextprotocol/server-filesystem /path/to/dir

# 带环境变量
claude mcp add --transport stdio --env AIRTABLE_API_KEY=YOUR_KEY airtable \
  -- npx -y airtable-mcp-server
```

### 从 JSON 配置添加

```bash
# HTTP 服务器
claude mcp add-json weather-api '{"type":"http","url":"https://api.weather.com/mcp","headers":{"Authorization":"Bearer token"}}'

# stdio 服务器
claude mcp add-json local-db '{"type":"stdio","command":"npx","args":["-y","@bytebase/dbhub","--dsn","postgresql://..."]}'
```

## 管理 MCP 服务器

```bash
claude mcp list                    # 列出所有服务器
claude mcp get <name>              # 查看服务器详情
claude mcp remove <name>           # 删除服务器
claude mcp add-from-claude-desktop # 从 Claude Desktop 导入

# 在会话中
/mcp                               # 查看状态和认证
```

## 作用域

```bash
# 本地（默认）- 仅当前项目
claude mcp add --scope local ...

# 项目 - 通过 .mcp.json 团队共享
claude mcp add --scope project ...

# 用户 - 所有项目可用
claude mcp add --scope user ...
```

## 常用 MCP 服务器

### 开发工具

```bash
# GitHub
claude mcp add --transport http github https://api.githubcopilot.com/mcp/

# Sentry 错误监控
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# Linear 项目管理
claude mcp add --transport http linear https://mcp.linear.app/sse

# Jira
claude mcp add --transport http jira https://mcp.atlassian.com/mcp
```

### 数据库

```bash
# PostgreSQL
claude mcp add --transport stdio postgres -- npx -y @bytebase/dbhub \
  --dsn "postgresql://user:pass@host:5432/db"

# MySQL
claude mcp add --transport stdio mysql -- npx -y @bytebase/dbhub \
  --dsn "mysql://user:pass@host:3306/db"

# SQLite
claude mcp add --transport stdio sqlite -- npx -y @modelcontextprotocol/server-sqlite \
  --db-path ./database.db
```

### 生产力工具

```bash
# Notion
claude mcp add --transport http notion https://mcp.notion.com/mcp

# Slack
claude mcp add --transport http slack https://mcp.slack.com/mcp

# Google Drive
claude mcp add --transport http gdrive https://mcp.google.com/drive

# HubSpot
claude mcp add --transport http hubspot --scope user https://mcp.hubspot.com/anthropic
```

### 浏览器自动化

```bash
# Playwright
claude mcp add --transport stdio playwright -- npx -y @playwright/mcp@latest

# Puppeteer
claude mcp add --transport stdio puppeteer -- npx -y @modelcontextprotocol/server-puppeteer
```

## .mcp.json 项目配置

在项目根目录创建 `.mcp.json` 与团队共享：

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@bytebase/dbhub", "--dsn", "${DATABASE_URL}"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    },
    "internal-api": {
      "type": "http",
      "url": "${API_BASE_URL:-https://api.example.com}/mcp",
      "headers": {
        "Authorization": "Bearer ${API_KEY}"
      }
    }
  }
}
```

## OAuth 认证

```bash
# 添加需要 OAuth 的服务器
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp

# 在会话中认证
/mcp
# 选择服务器 -> 认证 -> 在浏览器中完成

# 固定回调端口（某些服务器需要）
claude mcp add --transport http \
  --callback-port 8080 \
  my-server https://mcp.example.com/mcp
```

## 将 Claude Code 作为 MCP 服务器

```bash
# 启动 Claude Code 作为 MCP 服务器
claude mcp serve
```

在 Claude Desktop 中使用：

```json
{
  "mcpServers": {
    "claude-code": {
      "type": "stdio",
      "command": "/path/to/claude",
      "args": ["mcp", "serve"]
    }
  }
}
```

## 实用示例

### 分析 Sentry 错误

```bash
claude mcp add --transport http sentry https://mcp.sentry.dev/mcp
```

```
过去 24 小时内最常见的错误是什么？
显示错误 ID abc123 的堆栈跟踪
哪个部署引入了这些新错误？
```

### GitHub 代码审查

```bash
claude mcp add --transport http github https://api.githubcopilot.com/mcp/
```

```
审查 PR #456 并建议改进
为刚发现的 bug 创建 Issue
显示分配给我的所有开放 PR
```

### 查询数据库

```bash
claude mcp add --transport stdio db -- npx -y @bytebase/dbhub \
  --dsn "postgresql://readonly:pass@prod.db.com:5432/analytics"
```

```
本月总收入是多少？
显示 orders 表的结构
查找 90 天内未购买的用户
```

### 浏览器测试

```bash
claude mcp add --transport stdio playwright -- npx -y @playwright/mcp@latest
```

```
测试登录流程是否正常工作
截取移动端结账页面的截图
验证搜索功能返回正确结果
```

## 工具搜索优化

Claude Code 默认启用工具搜索，延迟加载 MCP 工具以节省上下文：

```bash
# 禁用工具搜索（预先加载所有工具）
ENABLE_TOOL_SEARCH=false claude

# 阈值模式（工具超过 10% 上下文时才延迟）
ENABLE_TOOL_SEARCH=auto claude

# 自定义阈值
ENABLE_TOOL_SEARCH=auto:5 claude
```

## 输出限制配置

```bash
# 增加 MCP 输出令牌限制（默认 25000）
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

## 完整示例

参见 [examples/mcp/](../examples/mcp/) 目录。
