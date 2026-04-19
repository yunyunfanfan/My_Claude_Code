---
name: security-audit
description: 对代码进行安全审计，检查 OWASP Top 10 漏洞和常见安全问题
context: fork
agent: Explore
---

# 安全审计

## 审计范围

变更文件：!`git diff --name-only HEAD~1 2>/dev/null || git ls-files --modified`

$ARGUMENTS

## 检查清单

### OWASP Top 10

1. **注入攻击**
   - SQL 注入：检查字符串拼接的 SQL 查询
   - 命令注入：检查 `exec`, `eval`, `subprocess` 等
   - LDAP/XPath 注入

2. **失效的身份认证**
   - 弱密码策略
   - 不安全的会话管理
   - 硬编码凭据

3. **敏感数据暴露**
   - 明文存储密码
   - 日志中的敏感信息
   - 不安全的传输（HTTP vs HTTPS）

4. **XML 外部实体（XXE）**
   - 不安全的 XML 解析器配置

5. **失效的访问控制**
   - 缺少授权检查
   - 不安全的直接对象引用
   - 目录遍历

6. **安全配置错误**
   - 默认凭据
   - 不必要的功能启用
   - 错误信息泄露

7. **跨站脚本（XSS）**
   - 反射型 XSS
   - 存储型 XSS
   - DOM 型 XSS

8. **不安全的反序列化**
   - 不受信任数据的反序列化

9. **使用含已知漏洞的组件**
   - 过时的依赖
   - 已知 CVE

10. **日志记录和监控不足**
    - 缺少安全事件日志
    - 日志中的敏感信息

## 输出格式

对每个发现的问题：
- **严重程度**：Critical / High / Medium / Low / Info
- **位置**：文件名和行号
- **描述**：问题说明
- **修复建议**：具体的修复方案
- **参考**：相关 CWE 或 OWASP 链接
