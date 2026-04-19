#!/bin/bash
# check-dangerous.sh
# 在 PreToolUse Bash hook 中使用，阻止危险命令
#
# 配置方式（settings.json）：
# {
#   "hooks": {
#     "PreToolUse": [{
#       "matcher": "Bash",
#       "hooks": [{
#         "type": "command",
#         "command": "bash ~/.claude/hooks/check-dangerous.sh"
#       }]
#     }]
#   }
# }

# 从 stdin 读取工具输入 JSON
INPUT=$(cat)
COMMAND=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('command',''))" 2>/dev/null || echo "")

# 危险命令模式
DANGEROUS_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \*"
  "DROP TABLE"
  "DROP DATABASE"
  "DELETE FROM .* WHERE 1=1"
  "format c:"
  "> /dev/sda"
  "dd if=/dev/zero"
  "chmod -R 777 /"
  "chown -R .* /"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    echo "{\"decision\": \"block\", \"reason\": \"检测到危险命令模式: $pattern\"}"
    exit 0
  fi
done

# 允许执行
exit 0
