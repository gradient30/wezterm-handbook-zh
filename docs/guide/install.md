# 安装与入门

WezTerm 是跨平台、GPU 加速的终端模拟器，配置语言为 Lua。本章帮助你完成安装、确认配置文件位置，并完成一次最小可用配置。

## 获取安装包

请到官方仓库的 Releases 页面下载适合你系统的安装包：

- 官网与文档：<https://wezterm.org>
- 项目仓库：<https://github.com/wezterm/wezterm>

Windows 用户通常选择安装程序（`.exe` / `.msi`）或便携包。安装完成后，可从开始菜单启动 **WezTerm**；若需从桌面快捷方式启动 GUI，官方建议指向 `wezterm-gui.exe`，避免额外弹出控制台窗口。

## Windows：配置文件路径

推荐从以下路径起步（官方推荐）：

```text
%USERPROFILE%\.wezterm.lua
```

展开后通常类似：

```text
C:\Users\<你的用户名>\.wezterm.lua
```

也可用目录形式（适合多文件配置）：

```text
%USERPROFILE%\.config\wezterm\wezterm.lua
```

::: tip 用记事本创建文件时注意扩展名
确保文件名是 `.wezterm.lua`，而不是 `.wezterm.lua.txt`。在资源管理器中可开启「文件扩展名」显示后再确认。
:::

## 最小配置示例

将下面内容写入 `%USERPROFILE%\.wezterm.lua`，保存后重新打开 WezTerm（或按 `Ctrl+Shift+R` 强制重载）：

```lua
-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- 初始窗口大小（列 × 行）
config.initial_cols = 120
config.initial_rows = 28

-- 字体大小与配色方案（名称可在官方 Color Schemes 中查阅）
config.font_size = 12
config.color_scheme = 'AdventureTime'

return config
```

## Windows：默认启动 PowerShell 7

若希望新标签 / 新窗口默认进入 PowerShell 7（`pwsh`），而不是 `cmd` 或 Windows PowerShell 5：

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.default_prog = {
  'C:/Program Files/PowerShell/7/pwsh.exe',
  '-NoLogo',
}

return config
```

路径请按本机实际安装位置调整。使用正斜杠 `/` 在 Lua 字符串中更省事。

::: danger 切勿把 Lua 粘贴进 PowerShell
`.wezterm.lua` 是 **WezTerm 读取的配置文件**，不是在 PowerShell 里执行的脚本。  
在 `pwsh` 提示符下粘贴 `local wezterm = require 'wezterm'` 一类代码会报错。请用编辑器打开上述路径的文件进行修改。
:::

## 配置热重载

WezTerm 会监视已加载的配置文件；保存后多数选项会立即生效。也可使用默认快捷键：

| 操作 | Windows / Linux | macOS |
| --- | --- | --- |
| 强制重载配置 | `Ctrl+Shift+R` | 见官方默认键表 |

命令行临时覆盖示例（不改文件）：

```bash
wezterm --config enable_scroll_bar=true
wezterm --config 'exit_behavior="Hold"'
```

## 验证是否生效

1. 确认窗口标题或标签行为符合预期（例如默认进入 `pwsh`）。
2. 故意写一行语法错误再保存：应出现配置错误提示，并回退到默认配置——说明文件路径已被读取。
3. 运行 `wezterm --version` 确认 CLI 可用。

## 下一步

- [配置文件](./config.md)：查找顺序、模块拆分与 `config_builder`
- [外观与标签栏](./appearance.md)：配色、标签颜色与字体
