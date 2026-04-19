# 全栈 Web 应用 CLAUDE.md 示例

## 项目概述
这是一个使用 Next.js + TypeScript + PostgreSQL 构建的全栈 Web 应用。

## 技术栈
- 前端：Next.js 14, React, TypeScript, Tailwind CSS
- 后端：Next.js API Routes, Prisma ORM
- 数据库：PostgreSQL
- 测试：Jest, React Testing Library, Playwright

## 构建和测试命令
- 开发服务器：`npm run dev`（请勿运行，让用户手动执行）
- 构建：`npm run build`
- 测试：`npm test -- --run`
- E2E 测试：`npx playwright test`
- Lint：`npm run lint`
- 类型检查：`npm run type-check`
- 数据库迁移：`npx prisma migrate dev`
- 数据库查看：`npx prisma studio`（请勿运行）

## 项目架构
```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # 认证相关页面
│   ├── (dashboard)/       # 仪表盘页面
│   └── api/               # API 路由
├── components/
│   ├── ui/                # 基础 UI 组件
│   └── features/          # 功能组件
├── lib/
│   ├── db.ts              # Prisma 客户端
│   ├── auth.ts            # 认证工具
│   └── utils.ts           # 通用工具
├── types/                 # TypeScript 类型定义
└── tests/                 # 测试文件
```

## 代码规范
- 使用 2 空格缩进
- 使用 TypeScript，禁止使用 `any` 类型
- 组件使用 PascalCase，函数使用 camelCase
- 文件名使用 kebab-case
- 导入顺序：外部库 → 内部模块 → 类型
- 使用 `const` 优先于 `let`

## API 设计规范
- RESTful 命名：`GET /api/users`, `POST /api/users`, `PUT /api/users/:id`
- 统一错误格式：`{ error: string, code: string, details?: object }`
- 所有端点必须验证输入（使用 Zod）
- 认证端点使用 JWT Bearer Token

## 数据库规范
- 所有数据库操作通过 Prisma ORM
- 禁止直接 SQL 查询（除非性能必要）
- 事务操作使用 `prisma.$transaction()`
- 敏感字段（密码等）不返回给客户端

## 测试规范
- 每个 API 路由必须有集成测试
- 组件测试覆盖主要交互
- 使用真实数据库（测试数据库），不 Mock
- 测试文件命名：`*.test.ts` 或 `*.spec.ts`

## 重要约定
- 提交前必须通过 `npm test -- --run` 和 `npm run type-check`
- 数据库 schema 变更必须创建迁移文件
- 环境变量在 `.env.example` 中记录
- 不提交 `.env` 文件
