# CLAUDE.md 配置指南

CLAUDE.md 是 Claude Code 的核心配置文件，在每个会话开始时自动加载，为 Claude 提供持久指令。

## 文件位置和优先级

| 范围 | 位置 | 适用对象 |
|------|------|---------|
| 托管策略 | `/Library/Application Support/ClaudeCode/CLAUDE.md` (macOS) | 组织所有用户 |
| 项目 | `./CLAUDE.md` 或 `./.claude/CLAUDE.md` | 项目团队成员 |
| 用户 | `~/.claude/CLAUDE.md` | 个人所有项目 |

优先级：托管策略 > 用户 > 项目（更具体的位置优先）

## 基本结构

```markdown
# 项目名称

## 项目概述
简短描述项目的目的和技术栈。

## 构建和测试命令
- 构建：`npm run build`
- 测试：`npm test`
- 开发服务器：`npm run dev`
- Lint：`npm run lint`

## 代码规范
- 使用 2 空格缩进
- 使用 TypeScript，避免 `any` 类型
- 函数命名使用 camelCase
- 组件命名使用 PascalCase

## 项目架构
- `src/api/` - API 处理器
- `src/components/` - React 组件
- `src/utils/` - 工具函数
- `tests/` - 测试文件

## 重要约定
- 提交前必须运行 `npm test`
- API 端点必须包含输入验证
- 所有公共函数需要 JSDoc 注释
```

## 导入其他文件

使用 `@path/to/file` 语法导入其他文件：

```markdown
# 项目指南

参考 @README.md 了解项目概述
参考 @package.json 了解可用命令

## 工作流
@docs/git-workflow.md

## 个人偏好
@~/.claude/my-preferences.md
```

## .claude/rules/ 目录

将规则按主题分割到独立文件：

```
.claude/
├── CLAUDE.md           # 主指令
└── rules/
    ├── code-style.md   # 代码风格
    ├── testing.md      # 测试规范
    ├── security.md     # 安全要求
    └── api-design.md   # API 设计规范
```

### 路径特定规则

使用 frontmatter 将规则限定到特定文件：

```markdown
---
paths:
  - "src/api/**/*.ts"
  - "src/handlers/**/*.ts"
---

# API 开发规则

- 所有端点必须包含输入验证
- 使用标准错误响应格式 `{ error: string, code: number }`
- 包含 OpenAPI 文档注释
- 速率限制：每分钟最多 100 次请求
```

```markdown
---
paths:
  - "**/*.test.ts"
  - "**/*.spec.ts"
---

# 测试规范

- 每个测试文件对应一个源文件
- 使用 describe/it 结构
- Mock 外部依赖
- 测试覆盖率不低于 80%
```

## 自动记忆（Auto Memory）

Claude 会自动保存学习内容到 `~/.claude/projects/<project>/memory/`：

```
memory/
├── MEMORY.md          # 索引文件（每次会话加载前 200 行）
├── debugging.md       # 调试相关笔记
├── api-conventions.md # API 约定
└── build-commands.md  # 构建命令
```

### 管理自动记忆

```bash
# 在会话中查看记忆
/memory

# 禁用自动记忆
# 在 settings.json 中设置：
# { "autoMemoryEnabled": false }

# 或通过环境变量
CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude
```

## 编写有效指令的技巧

### 要具体，不要模糊

```markdown
# 好的写法
- 使用 2 空格缩进
- 在提交前运行 `npm test`
- API 处理器位于 `src/api/handlers/`

# 不好的写法
- 正确格式化代码
- 测试你的更改
- 保持文件有组织
```

### 控制文件大小

- 每个 CLAUDE.md 目标在 200 行以下
- 使用 `@import` 引用详细文档
- 使用 `.claude/rules/` 分割主题

### 排除不相关的 CLAUDE.md

在大型 monorepo 中，排除其他团队的配置：

```json
// .claude/settings.local.json
{
  "claudeMdExcludes": [
    "**/other-team/CLAUDE.md",
    "/home/user/monorepo/legacy/.claude/rules/**"
  ]
}
```

## 完整示例

参见 [examples/claude-md/](../examples/claude-md/) 目录中的示例。
