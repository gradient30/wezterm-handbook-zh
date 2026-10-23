# 快捷键与滚动

官方参考：

- [Key Binding](https://wezterm.org/config/keys.html)
- [Scrollback](https://wezterm.org/scrollback.html)

## 常用默认快捷键

下表摘自官方 [Default Key Assignments](https://wezterm.org/config/default-keys.html)（与 WezTerm 20240203 版 `wezterm show-keys` 输出核对一致）。Windows / Linux 列使用 `CTRL+SHIFT` 组合；macOS 列使用 `SUPER`（即 `Cmd`），macOS 上 `Ctrl+Shift` 组合同样有效。

| 功能 | Windows / Linux | macOS | 动作（Action） |
| --- | --- | --- | --- |
| 复制 / 粘贴 | `Ctrl+Shift+C` / `Ctrl+Shift+V` | `Cmd+C` / `Cmd+V` | `CopyTo` / `PasteFrom 'Clipboard'` |
| 新建窗口 | `Ctrl+Shift+N` | `Cmd+N` | `SpawnWindow` |
| 新建标签 | `Ctrl+Shift+T` | `Cmd+T` | `SpawnTab 'CurrentPaneDomain'` |
| 关闭当前**标签**（需确认） | `Ctrl+Shift+W` | `Cmd+W` | `CloseCurrentTab { confirm = true }` |
| 跳到第 1–8 个 / 最后一个标签 | `Ctrl+Shift+1`…`8` / `Ctrl+Shift+9` | `Cmd+1`…`8` / `Cmd+9` | `ActivateTab` |
| 上一个 / 下一个标签 | `Ctrl+Shift+Tab` / `Ctrl+Tab`，或 `Ctrl+PageUp` / `Ctrl+PageDown` | `Cmd+Shift+[` / `Cmd+Shift+]` | `ActivateTabRelative` |
| 左移 / 右移当前标签 | `Ctrl+Shift+PageUp` / `Ctrl+Shift+PageDown` | 同左 | `MoveTabRelative` |
| 上下分屏（新窗格在下） | `Ctrl+Shift+Alt+"` | 同左 | `SplitVertical` |
| 左右分屏（新窗格在右） | `Ctrl+Shift+Alt+%` | 同左 | `SplitHorizontal` |
| 切换到相邻窗格 | `Ctrl+Shift+←/→/↑/↓` | 同左 | `ActivatePaneDirection` |
| 调整窗格大小 | `Ctrl+Shift+Alt+←/→/↑/↓` | 同左 | `AdjustPaneSize` |
| 窗格缩放（最大化/还原） | `Ctrl+Shift+Z` | 同左 | `TogglePaneZoomState` |
| 字体放大 / 缩小 / 重置 | `Ctrl+=` / `Ctrl+-` / `Ctrl+0` | `Cmd+=` / `Cmd+-` / `Cmd+0` | `IncreaseFontSize` 等 |
| 全屏 | `Alt+Enter` | 同左 | `ToggleFullScreen` |
| 搜索回滚区 | `Ctrl+Shift+F` | `Cmd+F` | `Search` |
| 清空回滚区 | `Ctrl+Shift+K` | `Cmd+K` | `ClearScrollback 'ScrollbackOnly'` |
| 重载配置 | `Ctrl+Shift+R` | `Cmd+R` | `ReloadConfiguration` |
| 按页上/下滚动视口 | `Shift+PageUp` / `Shift+PageDown` | 同左 | `ScrollByPage(-1)` / `ScrollByPage(1)` |
| Copy Mode | `Ctrl+Shift+X` | 同左 | `ActivateCopyMode` |
| QuickSelect | `Ctrl+Shift+Space` | 同左 | `QuickSelect` |
| 命令面板 | `Ctrl+Shift+P` | 同左 | `ActivateCommandPalette` |
| 字符选择（Emoji 等） | `Ctrl+Shift+U` | 同左 | `CharSelect` |
| 调试浮层 / Lua REPL | `Ctrl+Shift+L` | 同左 | `ShowDebugOverlay` |

::: warning 注意
- 默认**没有**「关闭当前窗格」快捷键：`Ctrl+Shift+W` 关闭的是整个标签。需要时自行绑定 `act.CloseCurrentPane { confirm = true }`。
- `"` 与 `%` 本身需要 `Shift` 才能输入，所以默认分屏键写作 `Ctrl+Shift+Alt+"` / `Ctrl+Shift+Alt+%`（美式键盘即 `Ctrl+Shift+Alt+'` / `Ctrl+Shift+Alt+5`）。
- `Ctrl+Shift+Home` / `Ctrl+Shift+End` **不是**默认键，见下文自定义示例。
:::

## 自定义快捷键

以下均为**自定义**绑定（非官方默认），写入 `config.keys` 后生效；它们与默认键并存。默认分屏仍是 `Ctrl+Shift+Alt+"` / `%`，下面推荐的 `|` / `-` **不会**覆盖默认键。

### 【社区常用自定义】更顺手的分屏键

许多用户觉得默认分屏要多按一个 `Alt` 太别扭（见 [Discussion #5248](https://github.com/wezterm/wezterm/discussions/5248)、[Issue #6245](https://github.com/wezterm/wezterm/issues/6245)）。社区常见写法是：

| 操作 | 按键（用户手势） | Lua `key`（美式键盘） | 动作 |
| --- | --- | --- | --- |
| 左右分屏 | `Ctrl+Shift+\|` | `'\|'` | `SplitHorizontal` |
| 上下分屏 | `Ctrl+Shift+-` | `'_'` | `SplitVertical` |

::: tip 为什么上下分屏写 `key = '_'` 而不是 `'-'`？
默认 `key_map_preference = "Mapped"`：按住 `Shift` 时匹配的是**产生的字符**。美式 / 多数 Windows 键盘上 `Shift+-` 产生 `_`，与官方默认键写 `'"'` / `'%'`（同样带 `SHIFT`）同理。社区示例（如 [AlexAllocated keymaps](https://github.com/AlexAllocated/.dotfiles/blob/e93b84c2a3913bd48a10f82cbe32de28cb4ab5b5/wezterm/keymaps.lua)）也普遍用 `\|` + `_`。若你改成 `Physical` 或绑定无效，可再试 `key = 'phys:-'`。
:::

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
  -- 【社区常用自定义】Ctrl+Shift+| 左右 · Ctrl+Shift+- 上下
  -- （Lua 用 '_'：Mapped 下 Shift+- → _；默认 Ctrl+Shift+Alt+" / % 仍可用）
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
  -- 【自定义】Ctrl+Shift+Home / End 跳到回滚区顶部 / 底部
  { key = 'Home', mods = 'CTRL|SHIFT', action = act.ScrollToTop },
  { key = 'End', mods = 'CTRL|SHIFT', action = act.ScrollToBottom },
  -- 【自定义】Alt+方向键 切换窗格（默认是 Ctrl+Shift+方向键）
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  -- Shift+PageUp/PageDown 按页滚动、Ctrl+= / Ctrl+- / Ctrl+0 字号 已是默认键，
  -- 若用 disable_default_key_bindings 关闭了默认键，需显式写回：
  -- { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
  -- { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
  -- { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
  -- { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  -- { key = '0', mods = 'CTRL', action = act.ResetFontSize },
}

return config
```

修饰键可用：`CTRL`、`SHIFT`、`ALT`（或 `OPT` / `META`）、`SUPER`（或 `CMD` / `WIN`），以及可选的 `LEADER`。可用 `|` 组合，例如 `CTRL|SHIFT`。

### Leader 键（可选，自定义）

![效果预览：Leader 激活提示](/images/20-leader-active.webp)

*效果预览：按下 Leader（示例 `Ctrl+A`）后状态栏显示 `LEADER`（真实 WezTerm 截图；需自行用 `update-status` + `window:leader_is_active()` 实现提示）。*

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

![效果预览：滚动条开启](/images/11-scrollbar-on.webp)

*效果预览：`enable_scroll_bar = true`，右侧可见滑块（真实 WezTerm 截图；可用 `colors.scrollbar_thumb` 着色）。*

![效果预览：滚动条关闭](/images/12-scrollbar-off.webp)

*效果预览：关闭滚动条后右侧无滑块（真实 WezTerm 截图）。*

```lua
-- 每个标签保留的回滚行数上限（越大越占内存）
config.scrollback_lines = 10000

-- 显示滚动条（占用右侧 padding；若右侧为 0 会自动扩到约 1 个单元格）
config.enable_scroll_bar = true
```

无滚动条时，默认仍可用 `Shift+PageUp` / `Shift+PageDown` 按页滚动视口。

搜索回滚：`Ctrl+Shift+F`（macOS `Cmd+F`）。在搜索模式中 `Enter` / `↑` / `Ctrl+P` 跳到上一个（更早的）匹配，`↓` / `Ctrl+N` 跳到下一个匹配，`Ctrl+R` 切换匹配类型（区分大小写 / 不区分 / 正则），`Esc` 退出。见官方 [Scrollback](https://wezterm.org/scrollback.html)。

## TUI / Claude Code：鼠标上报与终端滚动

许多全屏 TUI（含部分 AI CLI）会启用 **备用屏幕（alternate screen）** 并打开 **鼠标上报**。此时：

- 滚轮事件往往交给应用，而不是滚动 WezTerm 的回滚缓冲区；
- 用户会感觉「在 TUI 里没法用滚轮翻终端历史」。

实用配置：

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 按住该修饰键时，绕过应用的鼠标上报，让 WezTerm 处理滚轮等
config.bypass_mouse_reporting_modifiers = 'SHIFT' -- 默认值即 SHIFT，写出来便于修改

config.enable_scroll_bar = true
config.scrollback_lines = 10000

return config
```

操作建议：

| 需求 | 做法 |
| --- | --- |
| 在开启鼠标上报的 TUI 中滚动终端视口 | 按住 `Shift` + 滚轮 |
| 按页滚动 | `Shift+PageUp` / `Shift+PageDown` |
| 跳到回滚顶部 / 底部 | `Ctrl+Shift+Home` / `Ctrl+Shift+End`（**自定义**，需按上文绑定 `ScrollToTop` / `ScrollToBottom`） |

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
