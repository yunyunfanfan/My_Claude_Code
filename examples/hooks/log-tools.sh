#!/bin/bash
# log-tools.sh
# 记录所有工具调用到日志文件
#
# 配置方式（settings.json）：
# {
#   "hooks": {
#     "PostToolUse": [{
#       "hooks": [{
#         "type": "command",
#         "command": "bash ~/.claude/hooks/log-tools.sh"
#       }]
#     }]
#   }
# }

LOG_FILE="${HOME}/.claude/tool-usage.log"
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name','unknown'))" 2>/dev/null || echo "unknown")
SESSION_ID="${CLAUDE_SESSION_ID:-unknown}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$TIMESTAMP] Session: $SESSION_ID | Tool: $TOOL_NAME" >> "$LOG_FILE"
