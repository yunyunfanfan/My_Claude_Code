# Claude Code 完整用法指南

> 基于官方文档整理的 Claude Code 核心用法、进阶技巧和最佳实践
>
> 最后更新：2026年4月21日

## 更新日志

### 2026-04-21

**新增 6 个学术写作 Skills（来源：[awesome-ai-research-writing](https://github.com/Leey21/awesome-ai-research-writing) → [zechenzhangAGI/AI-research-SKILLs](https://github.com/zechenzhangAGI/AI-research-SKILLs)）**

| Skill | 功能 |
|-------|------|
| `ml-paper-writing` | 面向 NeurIPS/ICML/ICLR/ACL/AAAI 的完整论文写作工作流，含模板、引用核查、格式迁移 |
| `systems-paper-writing` | 面向 OSDI/SOSP/ASPLOS/NSDI 的系统论文写作，含段落蓝图、审稿人视角检查表 |
| `academic-plotting` | 从论文描述生成架构图（调用 Gemini）或从数据生成 matplotlib 图表 |
| `presenting-conference-talks` | 从论文生成会议 Beamer LaTeX 幻灯片 + PPTX + 演讲稿 |
| `brainstorming-research-ideas` | 结构化研究方向头脑风暴，探索高影响力研究问题 |
| `creative-thinking-for-research` | 基于认知科学框架（类比推理、约束操控等）激发创新研究思路 |

**使用示例**

```
# 写 ML 论文
"帮我把这个 GitHub repo 写成一篇 NeurIPS 论文"

# 准备会议报告
"基于这篇论文生成 20 分钟的 oral 幻灯片"

# 研究头脑风暴
"我在做图神经网络遗忘，帮我头脑风暴下一步研究方向"
```

### 2026-04-20

**新增 Skills（共 9 个，均已安装至 `~/.claude/skills/`）**

| Skill | 来源 | 功能 |
|-------|------|------|
| `frontend-design` | [anthropics/skills](https://github.com/anthropics/skills) | 生成高质量、有个性的前端界面，避免 AI 通用审美 |
| `canvas-design` | [anthropics/skills](https://github.com/anthropics/skills) | 基于设计哲学生成 `.png` / `.pdf` 视觉艺术作品 |
| `theme-factory` | [anthropics/skills](https://github.com/anthropics/skills) | 从品牌描述生成完整配色主题，支持 10 种预设 |
| `web-artifacts-builder` | [anthropics/skills](https://github.com/anthropics/skills) | 构建多组件 React + Tailwind + shadcn/ui 制品 |
| `webapp-testing` | [anthropics/skills](https://github.com/anthropics/skills) | 用 Playwright 测试本地 Web 应用，截图 + 日志 |
| `skill-creator` | [anthropics/skills](https://github.com/anthropics/skills) | 创建、测试、迭代新 Skills 的元 Skill |
| `paper-diagram-prompt` | 自建 | 读取论文或方法描述，生成 Gemini 顶会流程图绘图指令 |
| `plot-from-data` | [Trae1ounG/paper-plot-skills](https://github.com/Trae1ounG/paper-plot-skills) | 8 种预设学术图表风格（柱状/折线/散点/雷达），输入数据直接生成 300dpi 图 |
| `plot-from-image` | [Trae1ounG/paper-plot-skills](https://github.com/Trae1ounG/paper-plot-skills) | 上传论文截图，分析字体/配色/比例，输出可复现的 matplotlib 代码 |

**Skills 使用示例**

```
# 前端设计
"帮我设计一个现代化的登录页面"

# 论文架构图（支持直接给论文 PDF）
"基于这篇论文帮我生成流程图 prompt"

# 数据绘图
"把这组数据画成 bar chart，用 bar_paired_delta 风格"

# 复现论文图
上传论文截图 + "复现这个图"
```

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
├── skills/                      # Skills 集合（15 个）
│   ├── frontend-design/         # 生成高质量前端界面
│   ├── canvas-design/           # Canvas 画布设计
│   ├── theme-factory/           # 主题生成工厂
│   ├── web-artifacts-builder/   # Web 制品构建
│   ├── webapp-testing/          # Web 应用测试
│   ├── skill-creator/           # 创建新 Skills 的 Skill
│   ├── paper-diagram-prompt/    # 生成顶会论文流程图的 Gemini 指令
│   ├── plot-from-data/          # 8 种预设风格学术数据图表
│   ├── plot-from-image/         # 从论文截图复现 matplotlib 图
│   ├── ml-paper-writing/        # ML 论文写作（NeurIPS/ICML/ICLR/ACL）
│   ├── systems-paper-writing/   # 系统论文写作（OSDI/SOSP/ASPLOS）
│   ├── academic-plotting/       # 论文图表生成（架构图 + 数据图）
│   ├── presenting-conference-talks/ # 会议幻灯片生成（Beamer + PPTX）
│   ├── brainstorming-research-ideas/ # 结构化研究方向头脑风暴
│   └── creative-thinking-for-research/ # 认知科学框架激发创新思路
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
