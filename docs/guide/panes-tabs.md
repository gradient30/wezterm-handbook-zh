# 分屏与标签

WezTerm 用 **标签（Tab）** 管理多个终端会话，用 **窗格（Pane）** 在同一标签内分屏。

## 标签

常见操作（Windows / Linux 默认，请以 `wezterm show-keys` 为准）：

| 操作 | 快捷键（常见） |
| --- | --- |
| 新建标签 | `Ctrl+Shift+T` |
| 关闭当前标签（关闭其中窗格） | `Ctrl+Shift+W` |
| 切换标签 | `Ctrl+Tab` / `Ctrl+Shift+Tab` |
| 按序号跳转 | `Ctrl+Shift+1` … 等（视版本与键表） |

启动器菜单：点击标签栏 `+` 右侧区域时，**右键**可打开启动器；也可绑定 `ShowLauncher` / `ShowLauncherArgs`。通过 `launch_menu` 可添加自定义启动项，见 [Launching Programs](https://wezterm.org/config/launch.html)。

## 分屏（窗格）

在配置中绑定分屏动作：

```lua
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.keys = {
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = act.ActivatePaneDirection 'Down',
  },
}

return config
```

非活动窗格可通过 `inactive_pane_hsb` 降低饱和度与亮度，便于识别当前焦点。

## 「exit」是什么？

在 shell 中输入：

```bash
exit
```

表示 **结束当前 shell 会话**。该窗格中的进程退出后，窗格通常会关闭（具体还受 `exit_behavior` 等选项影响）。

::: warning 不是「退出分屏模式」的专用命令
WezTerm **没有**名为「exit split mode」的独立模式命令。`exit` 结束的是当前窗格里的 shell，而不是某种分屏编辑模式。  
若只想关掉某个分屏，应关闭该窗格（例如 `Ctrl+Shift+W` 或对应 Close 动作），或让该窗格内进程退出。
:::

相关配置示例：

```lua
-- 进程退出后是否保持窗格（Hold）或关闭等，详见官方文档
-- config.exit_behavior = 'Close' -- 或 'Hold' 等，以当前版本文档为准
```

## 标签标题

除 [外观与标签栏](./appearance.md) 中的 `format-tab-title` 外，程序还可通过 OSC 序列设置图标名 / 窗口标题（见 [转义序列](./escape-sequences.md)）。

## 下一步

- [CLI 与进阶](./cli.md)
- [FAQ](./faq.md)
