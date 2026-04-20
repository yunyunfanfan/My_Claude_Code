# Claude Code 完整用法指南

> 基于官方文档整理的 Claude Code 核心用法、进阶技巧和最佳实践

## 目录

- [快速开始](#快速开始)
- [CLI 命令参考](./docs/cli-reference.md)
- [CLAUDE.md 配置](./docs/claude-md.md)
- [Skills 自定义命令](./docs/skills.md)
- [官方 Skills 集合](./skills/README.md)
- [Hooks 自动化](./docs/hooks.md)
- [MCP 服务器集成](./docs/mcp.md)
- [进阶用法](./docs/advanced.md)
- [实用示例](./examples/)

## 快速开始

### 安装

```bash
# macOS / Linux / WSL
curl -fsSL https://claude.ai/install.sh | bash

# Windows PowerShell
irm https://claude.ai/install.ps1 | iex

# Homebrew
brew install --cask claude-code
```

### 基本使用

```bash
# 进入项目目录，启动交互式会话
cd your-project
claude

# 带初始提示启动
claude "解释这个项目的架构"

# 非交互模式（打印后退出）
claude -p "这个函数做什么？"

# 管道输入
cat error.log | claude -p "分析这些错误"

# 继续上次对话
claude -c

# 恢复指定会话
claude -r "session-name"
```

## 仓库结构

```
claude-code-guide/
├── README.md                    # 本文件
├── docs/
│   ├── cli-reference.md         # CLI 命令和标志完整参考
│   ├── claude-md.md             # CLAUDE.md 配置指南
│   ├── skills.md                # Skills 创建和使用
│   ├── hooks.md                 # Hooks 自动化工作流
│   ├── mcp.md                   # MCP 服务器集成
│   └── advanced.md              # 进阶用法和技巧
├── skills/                      # 官方 Skills 集合（来自 anthropics/skills）
│   ├── frontend-design/         # 生成高质量前端界面
│   ├── canvas-design/           # Canvas 画布设计
│   ├── theme-factory/           # 主题生成工厂
│   ├── web-artifacts-builder/   # Web 制品构建
│   ├── webapp-testing/          # Web 应用测试
│   └── skill-creator/           # 创建新 Skills 的 Skill
├── examples/
│   ├── claude-md/               # CLAUDE.md 示例
│   ├── skills/                  # Skills 示例
│   ├── hooks/                   # Hooks 脚本示例
│   └── mcp/                     # MCP 配置示例
└── templates/
    ├── CLAUDE.md.template        # 项目 CLAUDE.md 模板
    └── settings.json.template    # settings.json 模板
```

## Contributors

| | 名称 | 角色 | 贡献 |
|---|---|---|---|
| <img src="https://github.com/yunyunfanfan.png" width="40" height="40" style="border-radius:50%"> | [yunyunfanfan](https://github.com/yunyunfanfan) | 项目发起人 | 需求规划、内容审核、仓库维护 |
| <img src="https://anthropic.com/favicon.ico" width="40" height="40" style="border-radius:50%"> | [Claude](https://claude.ai) | AI 编程助手 | 文档编写、示例代码、结构设计 |
