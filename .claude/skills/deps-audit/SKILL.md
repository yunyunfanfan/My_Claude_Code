---
name: deps-audit
description: 审查项目依赖，检查过时版本、安全漏洞和不必要的依赖
disable-model-invocation: true
allowed-tools: Bash(npm *) Bash(pip *) Bash(poetry *) Read Glob
---

# 依赖审查

## 项目类型检测

!`ls package.json requirements.txt pyproject.toml go.mod Cargo.toml 2>/dev/null`

## 依赖信息

### Node.js（如适用）
过时依赖：!`npm outdated 2>/dev/null || echo "非 Node.js 项目"`
安全漏洞：!`npm audit --json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(f'漏洞总数: {d[\"metadata\"][\"vulnerabilities\"][\"total\"]}') if 'metadata' in d else print('无法解析')" 2>/dev/null || echo "跳过"`

### Python（如适用）
!`pip list --outdated 2>/dev/null || echo "非 Python 项目或未配置"`

## 分析报告

根据以上信息，提供：

1. **安全漏洞**（按严重程度排序）
   - 漏洞名称、影响版本、修复版本
   - 升级命令

2. **严重过时的依赖**（主版本落后 2+ 个版本）
   - 当前版本 → 最新版本
   - 升级注意事项

3. **可移除的依赖**（根据 package.json 和代码使用情况）

4. **升级建议**
   - 优先级排序
   - 具体升级命令

$ARGUMENTS
