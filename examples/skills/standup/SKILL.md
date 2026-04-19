---
name: standup
description: 生成今日站会报告，总结昨天的工作、今天的计划和阻碍项
disable-model-invocation: true
allowed-tools: Bash(git *)
---

# 生成站会报告

## 昨天的提交记录

!`git log --since="yesterday 00:00" --until="today 00:00" --oneline --author="$(git config user.name)" 2>/dev/null || echo "无提交记录"`

## 今天的提交记录（到目前为止）

!`git log --since="today 00:00" --oneline --author="$(git config user.name)" 2>/dev/null || echo "无提交记录"`

## 当前未提交的变更

!`git status --short 2>/dev/null || echo "无变更"`

## 生成报告

根据以上 git 记录，生成一份简洁的站会报告，格式如下：

**昨天完成：**
- [根据提交记录总结]

**今天计划：**
- [根据未提交变更和上下文推断]

**阻碍项：**
- 无（如有请补充）

$ARGUMENTS
