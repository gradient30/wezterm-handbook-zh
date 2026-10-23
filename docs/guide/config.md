# 配置文件

WezTerm 使用 **Lua 5.4** 作为配置语言。配置脚本应返回一个配置表；推荐使用 `wezterm.config_builder()` 生成带校验与较好报错信息的配置对象。

官方参考：

- [Configuration Files](https://wezterm.org/config/files.html)
- [Lua Reference](https://wezterm.org/config/lua/general.html)

## 配置文件查找顺序（概要）

WezTerm 大致按以下优先级定位配置（细节以官方流程图为准）：

1. CLI 参数 `--config-file`
2. 环境变量 `WEZTERM_CONFIG_FILE`
3. Windows「U 盘便携模式」：与 `wezterm.exe` 同目录的 `wezterm.lua`（非便携场景不推荐）
4. `$XDG_CONFIG_HOME/wezterm/wezterm.lua`（若设置了 XDG）
5. `$HOME/.config/wezterm/wezterm.lua`
6. `$HOME/.wezterm.lua`（Windows 即 `%USERPROFILE%\.wezterm.lua`）

::: tip 入门建议
Windows 用户优先使用 `%USERPROFILE%\.wezterm.lua`。需要拆分多文件时，再迁移到 `%USERPROFILE%\.config\wezterm\`。
:::

当前版本中，若候选文件存在但解析失败，会显示错误并使用内置默认配置（不会静默跳到下一个候选路径）。



::: tip 不想手写？
可用 [可视化配置](/guide/config-builder) 勾选预设生成 `.wezterm.lua`，或用外链下载起步文件：[raw](https://raw.githubusercontent.com/gradient30/wezterm-handbook-zh/gh-pages/wezterm.lua) / [jsDelivr](https://cdn.jsdelivr.net/gh/gradient30/wezterm-handbook-zh@gh-pages/wezterm.lua) / [downloads](https://gradient30.github.io/wezterm-handbook-zh/downloads/wezterm-starter.lua)（勿用站内 `/wezterm.lua` 相对链接，会被 VitePress 软 404）。
:::

## 基本结构

空配置：

```lua
return {}
```

推荐写法：

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 在此写入选项
config.font_size = 12

return config
```

文档中的片段常常只展示赋值行，合并到同一文件时保留一个 `require`、一个 `config`、一次 `return` 即可。

## 命令行覆盖

```bash
wezterm --config enable_scroll_bar=true
wezterm --config 'exit_behavior="Hold"'
```

命令行覆盖优先于配置文件，即使文件被热重载也仍然生效。

## 拆分为多个 Lua 模块

`package.path` 会包含（节选）：

- `~/.config/wezterm`
- `~/.wezterm`
- Windows 便携模式下 exe 旁的 `wezterm_modules`（一般勿用）

示例：`~/.config/wezterm/helpers.lua`

```lua
local wezterm = require 'wezterm'
local module = {}

function module.apply_to_config(config)
  config.color_scheme = 'Batman'
end

return module
```

主配置 `wezterm.lua`：

```lua
local helpers = require 'helpers'
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

helpers.apply_to_config(config)
return config
```

## 配置中避免副作用

配置文件可能在启动与重载时被多次求值。不要在顶层无条件拉起后台进程或做其它有副作用的操作；把逻辑放进事件回调或惰性函数中。

## Windows 启动程序相关选项

| 选项 | 作用 |
| --- | --- |
| `default_prog` | 新窗格/标签默认启动的程序与参数 |
| `default_cwd` | 默认工作目录 |
| `set_environment_variables` | 为子进程追加环境变量 |
| `launch_menu` | 启动器菜单自定义项 |

示例（PowerShell 7）：

```lua
config.default_prog = {
  'C:/Program Files/PowerShell/7/pwsh.exe',
  '-NoLogo',
}
```

更多见官方 [Launching Programs](https://wezterm.org/config/launch.html)。

## 下一步

- [外观与标签栏](./appearance.md)
- [快捷键与滚动](./keys-scroll.md)
