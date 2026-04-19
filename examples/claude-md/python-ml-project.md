# Python 数据科学项目 CLAUDE.md 示例

## 项目概述
机器学习模型训练和推理服务，使用 Python + FastAPI + PyTorch。

## 技术栈
- Python 3.11+
- FastAPI（API 服务）
- PyTorch（模型训练）
- pandas, numpy, scikit-learn（数据处理）
- pytest（测试）
- Poetry（依赖管理）

## 常用命令
- 安装依赖：`poetry install`
- 运行测试：`poetry run pytest`
- 启动 API：`poetry run uvicorn app.main:app --reload`（请勿运行）
- 训练模型：`poetry run python scripts/train.py`
- 代码格式化：`poetry run black . && poetry run isort .`
- 类型检查：`poetry run mypy .`
- Lint：`poetry run ruff check .`

## 项目结构
```
src/
├── app/
│   ├── main.py           # FastAPI 应用入口
│   ├── routers/          # API 路由
│   ├── models/           # Pydantic 模型
│   └── services/         # 业务逻辑
├── ml/
│   ├── models/           # PyTorch 模型定义
│   ├── training/         # 训练脚本
│   └── inference/        # 推理逻辑
├── data/
│   ├── raw/              # 原始数据（不提交）
│   └── processed/        # 处理后数据（不提交）
├── notebooks/            # Jupyter notebooks（探索用）
├── scripts/              # 工具脚本
└── tests/                # 测试文件
```

## 代码规范
- 使用 Black 格式化，行长度 88
- 使用 isort 排序导入
- 所有函数必须有类型注解
- 使用 Pydantic 进行数据验证
- 异步函数使用 `async/await`

## 数据处理规范
- 原始数据不修改，处理后保存到 `data/processed/`
- 使用 pandas 处理表格数据
- 大数据集使用分块处理
- 记录数据处理步骤到 notebook

## 模型规范
- 模型保存到 `models/` 目录
- 记录模型版本和性能指标
- 使用 MLflow 跟踪实验（如果配置了）

## 测试规范
- API 端点必须有集成测试
- 模型推理必须有单元测试
- 使用 pytest fixtures 管理测试数据
