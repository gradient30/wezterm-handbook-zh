# 快捷键与滚动

官方参考：

- [Key Binding](https://wezterm.org/config/keys.html)
- [Scrollback](https://wezterm.org/scrollback.html)

## 常用默认快捷键（Windows / Linux）

具体绑定随版本变化，可用 `wezterm show-keys` 查看本机实际映射。下表为常见默认项，便于入门记忆：

| 功能 | 常见默认快捷键 |
| --- | --- |
| 新建标签 | `Ctrl+Shift+T` |
| 关闭当前窗格/标签 | `Ctrl+Shift+W` |
| 下一个 / 上一个标签 | `Ctrl+Tab` / `Ctrl+Shift+Tab`（或 `Ctrl+Shift+]` / `[`） |
| 水平分屏 | `Ctrl+Shift+D`（以本机 `show-keys` 为准） |
| 垂直分屏 | 见本机键表或下方自定义示例 |
| 复制 / 粘贴 | `Ctrl+Shift+C` / `Ctrl+Shift+V` |
| 搜索回滚 | `Ctrl+Shift+F` |
| 清空回滚 | `Ctrl+Shift+K` |
| 重载配置 | `Ctrl+Shift+R` |
| 按页上/下滚动视口 | `Shift+PageUp` / `Shift+PageDown` |

macOS 上许多操作使用 `Cmd` 而非 `Ctrl+Shift`。请以官方默认键表与 `wezterm show-keys` 为准。

## 自定义快捷键

```lua
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.keys = {
  -- 禁用某项默认绑定
  {
    key = 'm',
    mods = 'CMD',
    action = act.DisableDefaultAssignment,
  },
  -- 垂直 / 水平分屏示例
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
}

return config
```

修饰键可用：`CTRL`、`SHIFT`、`ALT`（或 `OPT` / `META`）、`SUPER`（或 `CMD` / `WIN`），以及可选的 `LEADER`。可用 `|` 组合，例如 `CTRL|SHIFT`。

### Leader 键（可选）

```lua
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'a',
    mods = 'LEADER|CTRL',
    action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  },
}
```

## 回滚缓冲区与滚动条

```lua
-- 每个标签保留的回滚行数上限（越大越占内存）
config.scrollback_lines = 10000

-- 显示滚动条（占用右侧 padding；若右侧为 0 会自动扩到约 1 个单元格）
config.enable_scroll_bar = true
```

无滚动条时，默认仍可用 `Shift+PageUp` / `Shift+PageDown` 按页滚动视口。

搜索回滚：`Ctrl+Shift+F`。在搜索叠加层中可用方向键 / `Enter` 跳转匹配，`Esc` 退出。

## TUI / Claude Code：鼠标上报与终端滚动

许多全屏 TUI（含部分 AI CLI）会启用 **备用屏幕（alternate screen）** 并打开 **鼠标上报**。此时：

- 滚轮事件往往交给应用，而不是滚动 WezTerm 的回滚缓冲区；
- 用户会感觉「在 TUI 里没法用滚轮翻终端历史」。

实用配置：

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 按住该修饰键时，绕过应用的鼠标上报，让 WezTerm 处理滚轮等
config.bypass_mouse_reporting_modifiers = 'SHIFT'

config.enable_scroll_bar = true
config.scrollback_lines = 10000

return config
```

操作建议：

| 需求 | 做法 |
| --- | --- |
| 在开启鼠标上报的 TUI 中滚动终端视口 | **按住 Shift + 滚轮** |
| 按页滚动 | `Shift+PageUp` / `Shift+PageDown` |
| 跳到回滚顶部 / 底部附近 | `Ctrl+Shift+Home` / `Ctrl+Shift+End`（若本机键表已绑定；否则自行绑定 `ScrollToTop` / `ScrollToBottom`） |

::: tip 与「应用内滚动」的区别
Shift+滚轮绕过的是 **终端模拟器对鼠标事件的处理**；TUI 应用自身的列表滚动仍取决于该应用。若应用完全占用备用屏幕且不把内容写入主屏幕回滚，视口内能看的历史仍可能有限——这是终端模型限制，不是单独某一快捷键能「退出」的。
:::

更多排查见 [FAQ：TUI 无法滚动](./faq.md#tui-claude-code-等场景无法用滚轮滚动终端)。

## 查看本机全部快捷键

```bash
wezterm show-keys
wezterm show-keys --lua
wezterm show-keys --lua --key-table search_mode
```

## 下一步

- [分屏与标签](./panes-tabs.md)
- [常见问题 FAQ](./faq.md)
