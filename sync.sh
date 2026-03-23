#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# 更新扩展列表
if command -v cursor &> /dev/null; then
    cursor --list-extensions 2>/dev/null | sort -u > extensions.txt
    echo "[更新] extensions.txt ✓"
else
    echo "[跳过] 未找到 cursor 命令，无法更新扩展列表"
fi

# 检查是否有变更
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "没有变更需要同步。"
    exit 0
fi

echo ""
echo "=== 检测到以下变更 ==="
git status --short
echo ""

if [[ "$1" == "-y" ]]; then
    confirm="y"
else
    read -p "是否提交并推送？[y/N] " confirm
fi

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git add -A
    git commit -m "sync: $(date '+%Y-%m-%d %H:%M')"
    if git remote | grep -q origin; then
        git push
        echo "已推送到远端。"
    else
        echo "已提交。（未配置远端仓库，跳过 push）"
    fi
else
    echo "已取消。"
fi
