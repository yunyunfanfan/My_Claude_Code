# 官方 Skills 集合

> 来源：[anthropics/skills](https://github.com/anthropics/skills)，更新时间：2026-04-20

## 使用方法

在 Claude Code 中通过 `/skill` 命令调用，或在 `CLAUDE.md` 中引用。

```bash
# 安装到本地 Claude Code
cp -r skills/frontend-design ~/.claude/skills/
```

## Skills 列表

| Skill | 功能描述 | 适用场景 |
|-------|---------|---------|
| [frontend-design](./frontend-design/) | 生成高质量、有个性的前端界面，避免 AI 通用审美 | 需要独特 UI 设计时 |
| [canvas-design](./canvas-design/) | Canvas 画布设计，支持自定义字体和视觉资产 | 图形/海报/Banner 设计 |
| [theme-factory](./theme-factory/) | 从品牌描述生成完整配色主题 | 建立设计系统 |
| [web-artifacts-builder](./web-artifacts-builder/) | 构建可交互的 Web 制品（HTML/CSS/JS） | 快速原型和演示 |
| [webapp-testing](./webapp-testing/) | 自动化 Web 应用测试，生成测试用例 | QA 和回归测试 |
| [skill-creator](./skill-creator/) | 创建、测试、迭代新 Skills 的元 Skill | 构建自定义工作流 |

## 与文章对应关系

文章（[paicoding.com](https://paicoding.com/article/detail/2607600014942213)）推荐的 6 个 Skills 中，部分为社区创作且链接不可验证。本目录收录了官方仓库中功能最接近的 6 个真实 Skills：

- **frontend-design** → 对应文章的 Frontend-design
- **canvas-design** → 对应文章的 Interaction-design（视觉交互）
- **theme-factory** → 对应文章的 UI-UX-PRO-MAX（设计系统）
- **web-artifacts-builder** → 对应文章的 Web 制品构建
- **webapp-testing** → 对应文章的测试/评估场景
- **skill-creator** → 对应文章的 Skill-creator
