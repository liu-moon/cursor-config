# Cursor Config

多台电脑间同步 Cursor 配置。

## 同步内容

| 文件 | 说明 | 同步方式 |
|---|---|---|
| `settings.json` | 编辑器设置 | 符号链接（修改即生效） |
| `keybindings.json` | 快捷键 | 符号链接（修改即生效） |
| `extensions.txt` | 扩展列表 | `sync.sh` 时自动更新 |
| `skills-cursor/` | Agent Skills | 符号链接（修改即生效） |

## 使用

### 新电脑首次配置

```bash
git clone https://github.com/liu-moon/cursor-config.git ~/cursor-config
cd ~/cursor-config
./install.sh
```

会自动创建符号链接并安装所有扩展。已有配置文件会备份为 `.bak`。

### 同步改动到远端

改完设置、快捷键、安装/卸载扩展后：

```bash
cd ~/cursor-config
./sync.sh
```

### 从远端拉取最新配置

```bash
cd ~/cursor-config
git pull
./install.sh
```

## 支持平台

- macOS
- Linux
