#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [[ "$OSTYPE" == "darwin"* ]]; then
    CURSOR_USER_DIR="$HOME/Library/Application Support/Cursor/User"
elif [[ "$OSTYPE" == "linux"* ]]; then
    CURSOR_USER_DIR="$HOME/.config/Cursor/User"
else
    echo "不支持的操作系统: $OSTYPE"
    exit 1
fi

CURSOR_DOT_DIR="$HOME/.cursor"

echo "=== Cursor 配置同步工具 ==="
echo "仓库目录: $SCRIPT_DIR"
echo "Cursor 配置目录: $CURSOR_USER_DIR"
echo ""

mkdir -p "$CURSOR_USER_DIR"
mkdir -p "$CURSOR_DOT_DIR"

# --- settings.json ---
if [ -f "$CURSOR_USER_DIR/settings.json" ] && [ ! -L "$CURSOR_USER_DIR/settings.json" ]; then
    echo "[备份] settings.json → settings.json.bak"
    mv "$CURSOR_USER_DIR/settings.json" "$CURSOR_USER_DIR/settings.json.bak"
fi
ln -sf "$SCRIPT_DIR/settings.json" "$CURSOR_USER_DIR/settings.json"
echo "[链接] settings.json ✓"

# --- keybindings.json ---
if [ -f "$CURSOR_USER_DIR/keybindings.json" ] && [ ! -L "$CURSOR_USER_DIR/keybindings.json" ]; then
    echo "[备份] keybindings.json → keybindings.json.bak"
    mv "$CURSOR_USER_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json.bak"
fi
ln -sf "$SCRIPT_DIR/keybindings.json" "$CURSOR_USER_DIR/keybindings.json"
echo "[链接] keybindings.json ✓"

# --- skills-cursor ---
if [ -d "$CURSOR_DOT_DIR/skills-cursor" ] && [ ! -L "$CURSOR_DOT_DIR/skills-cursor" ]; then
    echo "[备份] skills-cursor → skills-cursor.bak"
    mv "$CURSOR_DOT_DIR/skills-cursor" "$CURSOR_DOT_DIR/skills-cursor.bak"
fi
ln -sf "$SCRIPT_DIR/skills-cursor" "$CURSOR_DOT_DIR/skills-cursor"
echo "[链接] skills-cursor ✓"

# --- 安装扩展 ---
if [ -f "$SCRIPT_DIR/extensions.txt" ]; then
    echo ""
    echo "=== 安装扩展 ==="
    while IFS= read -r ext; do
        [ -z "$ext" ] && continue
        echo -n "  安装 $ext ... "
        if cursor --install-extension "$ext" > /dev/null 2>&1; then
            echo "✓"
        else
            echo "跳过"
        fi
    done < "$SCRIPT_DIR/extensions.txt"
fi

echo ""
echo "=== 完成！==="
echo "配置已通过符号链接同步。"
echo "之后修改配置会自动反映到仓库，只需 git commit & push 即可同步到其他电脑。"
