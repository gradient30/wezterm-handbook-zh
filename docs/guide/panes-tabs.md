# 分屏与标签

WezTerm 用 **标签（Tab）** 管理多个终端会话，用 **窗格（Pane）** 在同一标签内分屏。

## 标签

默认快捷键（摘自 [官方默认键表](https://wezterm.org/config/default-keys.html)；macOS 把 `Ctrl+Shift` 换成 `Cmd` 亦可）：

| 操作 | Windows / Linux | macOS |
| --- | --- | --- |
| 新建标签 | `Ctrl+Shift+T` | `Cmd+T` |
| 关闭当前标签（含其中所有窗格，需确认） | `Ctrl+Shift+W` | `Cmd+W` |
| 下一个 / 上一个标签 | `Ctrl+Tab` / `Ctrl+Shift+Tab`，或 `Ctrl+PageDown` / `Ctrl+PageUp` | `Cmd+Shift+]` / `Cmd+Shift+[` |
| 跳到第 1–8 个标签 / 最后一个标签 | `Ctrl+Shift+1`…`8` / `Ctrl+Shift+9` | `Cmd+1`…`8` / `Cmd+9` |
| 移动当前标签 | `Ctrl+Shift+PageUp` / `Ctrl+Shift+PageDown` | 同左 |

启动器菜单：在标签栏的 `+` 按钮上**右键**即可打开启动器；也可绑定 `ShowLauncher` / `ShowLauncherArgs`。通过 `launch_menu` 可添加自定义启动项，见 [Launching Programs](https://wezterm.org/config/launch.html)。

## 分屏（窗格）

### 默认分屏键

| 操作 | 快捷键（全平台） | 动作 |
| --- | --- | --- |
| 上下分屏（新窗格在下方） | `Ctrl+Shift+Alt+"` | `SplitVertical { domain = 'CurrentPaneDomain' }` |
| 左右分屏（新窗格在右侧） | `Ctrl+Shift+Alt+%` | `SplitHorizontal { domain = 'CurrentPaneDomain' }` |
| 切换到相邻窗格 | `Ctrl+Shift+←/→/↑/↓` | `ActivatePaneDirection` |
| 调整窗格大小 | `Ctrl+Shift+Alt+←/→/↑/↓` | `AdjustPaneSize` |
| 窗格缩放 | `Ctrl+Shift+Z` | `TogglePaneZoomState` |

::: tip
WezTerm 的命名与 Vim 相反：`SplitHorizontal` = 左右排列，`SplitVertical` = 上下排列。默认**没有**关闭单个窗格的快捷键，可自定义绑定 `CloseCurrentPane`。
:::

### 【默认】vs 【社区常用自定义】

| 来源 | 左右分屏 | 上下分屏 |
| --- | --- | --- |
| 【默认】 | `Ctrl+Shift+Alt+%` | `Ctrl+Shift+Alt+"` |
| 【社区常用自定义】 | `Ctrl+Shift+\|` | `Ctrl+Shift+-`（Lua：`key = '_'`） |

默认三键组合仍有效；自定义是**叠加**，不是替换。美式键盘上 `Shift+-` → `_`，故 Mapped 偏好下写 `key = '_'`（详见 [快捷键与滚动](./keys-scroll.md#社区常用自定义更顺手的分屏键)）。

```lua
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.keys = {
  -- 【社区常用自定义】Ctrl+Shift+| 左右 · Ctrl+Shift+- 上下
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '_', -- 对应用户手势 Ctrl+Shift+-
    mods = 'CTRL|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  -- Alt+方向键 切换窗格（默认的 Ctrl+Shift+方向键 仍然可用）
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  -- 关闭当前窗格（默认无此键；勿用 Ctrl+Shift+X，会盖掉 Copy Mode）
  { key = 'w', mods = 'CTRL|SHIFT|ALT', action = act.CloseCurrentPane { confirm = true } },
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
若只想关掉某个分屏，应关闭该窗格（绑定 `CloseCurrentPane` 动作；注意默认的 `Ctrl+Shift+W` 关闭的是**整个标签**），或让该窗格内进程退出。
:::

相关配置示例：

```lua
-- 'Close'（默认）：进程退出即关闭窗格
-- 'CloseOnCleanExit'：仅退出码为 0 时关闭
-- 'Hold'：始终保留窗格，需手动关闭
config.exit_behavior = 'Close'
```

参见 [exit_behavior](https://wezterm.org/config/lua/config/exit_behavior.html)。

## 标签标题

除 [外观与标签栏](./appearance.md) 中的 `format-tab-title` 外，程序还可通过 OSC 序列设置图标名 / 窗口标题（见 [转义序列](./escape-sequences.md)）。

## 下一步

- [CLI 与进阶](./cli.md)
- [FAQ](./faq.md)
