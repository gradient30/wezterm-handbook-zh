# 玩法与配方

以下片段可直接合并进 `.wezterm.lua`（假设文件开头已有 `local wezterm = require 'wezterm'`、`local act = wezterm.action`、`local config = wezterm.config_builder()`，结尾 `return config`）。多个片段都写 `config.keys` 时请合并为一个表；使用 `table.insert(config.keys, ...)` 的片段要求先有 `config.keys = {}`（或 `config.keys = config.keys or {}`）。下列快捷键均为**自定义**绑定，非默认。

## 社区实践 / 常见优化（Top 3）

以下主题来自官方文档、GitHub Discussions/Issues 与高星配置的**反复出现**写法，不是发明的排行榜。每条附来源与可粘贴 Lua。

### 1. 默认分屏三键太别扭 → `Ctrl+Shift+|` / `Ctrl+Shift+-`

**痛点**：默认 `Ctrl+Shift+Alt+"` / `%` 要同时按三个修饰键；新手常漏 `Alt`（[Discussion #5248](https://github.com/wezterm/wezterm/discussions/5248)；希望类似 Windows Terminal 的 `Alt+Shift+/-`：[Issue #6245](https://github.com/wezterm/wezterm/issues/6245)）。

**做法**：叠加社区常用键；默认键保留。美式键盘 Mapped 下 `Shift+-` → `_`。

```lua
-- 【社区常用自定义】左右 | · 上下 -（Lua key='_'）
table.insert(config.keys, {
  key = '|', mods = 'CTRL|SHIFT',
  action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
})
table.insert(config.keys, {
  key = '_', mods = 'CTRL|SHIFT',
  action = act.SplitVertical { domain = 'CurrentPaneDomain' },
})
```

### 2. 从 tmux 迁过来 → Leader 键 + 内置 mux

**痛点**：再学一套 tmux 快捷键，或与 WezTerm 内置分屏冲突。社区常设 `leader = Ctrl+A`（或 `Ctrl+B`），用 `LEADER` 绑定分屏 / 切窗格 / 新标签；不少人直接弃用 tmux、改用 WezTerm mux（[r/wezterm 示例](https://www.reddit.com/r/wezterm/comments/1fy21ft/trouble_with_catppuccin_and_tmux/)、官方 [Leader Key](https://wezterm.org/config/keys.html#leader-key)、[johnlindquist 配置 gist](https://gist.github.com/johnlindquist/346e18fd6875ae4207a9b69c62071e9a)）。

完整片段见下文「类 tmux 的 Leader 键」。

### 3. 全屏 TUI（nvim / AI CLI）滚不动回滚 → Shift 穿透 + 大 scrollback

**痛点**：应用开启鼠标上报 / 备用屏幕后，滚轮进了应用而不是终端历史。

**做法**：按住 `Shift` 再滚（[`bypass_mouse_reporting_modifiers`](https://wezterm.org/config/mouse.html) 默认即 `SHIFT`）；加大 `scrollback_lines`；需要时开滚动条。详见 [快捷键与滚动](./keys-scroll.md#tui--claude-code鼠标上报与终端滚动)。

```lua
config.bypass_mouse_reporting_modifiers = 'SHIFT'
config.enable_scroll_bar = true
config.scrollback_lines = 50000  -- AI / 长构建日志常见取值
```

其它高频话题（配色与状态栏、Windows `default_prog` / WSL 域、`font_with_fallback` 中文、命令面板 / QuickSelect / Copy Mode）见 [特有便捷性](./features.md) 与 [AI 编程](./ai-coding.md)。高星参考配置：[KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)（1k+ ★）。

## 状态栏：时间 + 工作区

```lua
wezterm.on('update-status', function(window, pane)
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#7aa2f7' } },
    { Text = '  ' .. window:active_workspace() .. '  ' },
    { Foreground = { Color = '#9ece6a' } },
    { Text = wezterm.strftime '%Y-%m-%d %H:%M  ' },
  })
end)
```

![右上角显示工作区与时间，标签按序号着色](/images/01-ai-layout.webp)

*图：本页状态栏与彩色标签配方的实际效果（真实截图）。*

## 彩色标签标题

```lua
wezterm.on('format-tab-title', function(tab)
  local colors = { '#7aa2f7', '#9ece6a', '#e0af68', '#f7768e' }
  local c = colors[(tab.tab_index % #colors) + 1]
  local title = tab.tab_title ~= '' and tab.tab_title or tab.active_pane.title
  return {
    { Background = { Color = tab.is_active and c or '#1a1b26' } },
    { Foreground = { Color = tab.is_active and '#1a1b26' or c } },
    { Text = ' ' .. (tab.tab_index + 1) .. ': ' .. title .. ' ' },
  }
end)
```

## 类 tmux 的 Leader 键

```lua
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  -- 连按两次 Ctrl+A 时把 Ctrl+A 发给程序
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },
}
```

## 跟随系统深浅色 / 随机配色

```lua
local function scheme_for(appearance)
  return appearance:find 'Dark' and 'Tokyo Night' or 'Tokyo Night Day'
end
config.color_scheme = scheme_for(wezterm.gui and wezterm.gui.get_appearance() or 'Dark')

-- 随机配色：每次按 Ctrl+Shift+Alt+T 换一个内置方案（仅当前窗口）
local names = {}
for name, _ in pairs(wezterm.color.get_builtin_schemes()) do table.insert(names, name) end
table.insert(config.keys, { key = 'T', mods = 'CTRL|SHIFT|ALT', action = wezterm.action_callback(function(window)
  local o = window:get_config_overrides() or {}
  o.color_scheme = names[math.random(#names)]
  window:set_config_overrides(o)
end) })
```

## 背景图与透明

```lua
config.window_background_opacity = 0.92
config.background = {
  { source = { File = 'C:/Users/你的用户名/Pictures/bg.jpg' }, hsb = { brightness = 0.08 } },
}
```

`hsb.brightness` 调低可保证文字可读。Windows 路径建议使用正斜杠。

## 智能分屏（按窗格宽高自动选择方向）

```lua
table.insert(config.keys, { key = 'Enter', mods = 'ALT|SHIFT', action = wezterm.action_callback(function(window, pane)
  local d = pane:get_dimensions()
  if d.pixel_width > d.pixel_height then
    pane:split { direction = 'Right' }
  else
    pane:split { direction = 'Bottom' }
  end
end) })
```

## 窗格缩放

默认 `Ctrl+Shift+Z` 执行 `TogglePaneZoomState`，把当前窗格临时放大到整个标签，再按一次恢复——适合阅读 AI 的长输出。

![窗格缩放：左侧窗格临时占满整个标签](/images/07-pane-zoom.webp)

*图：对三分屏中的左侧窗格按 `Ctrl+Shift+Z`（真实截图）。*

## 重命名标签

```lua
table.insert(config.keys, { key = 'E', mods = 'CTRL|SHIFT', action = act.PromptInputLine {
  description = '新标签名',
  action = wezterm.action_callback(function(window, pane, line)
    if line then window:active_tab():set_title(line) end
  end),
} })
```

也可在命令行执行 `wezterm cli set-tab-title "名称"`。

## InputSelector 项目切换器（每个项目一个工作区）

```lua
local projects = {
  { id = 'D:/code/blog', label = 'blog' },
  { id = 'D:/code/api', label = 'api' },
}
table.insert(config.keys, { key = 'O', mods = 'CTRL|SHIFT', action = act.InputSelector {
  title = '切换项目',
  fuzzy = true,
  choices = projects,
  action = wezterm.action_callback(function(window, pane, id, label)
    if id then
      window:perform_action(act.SwitchToWorkspace { name = label, spawn = { cwd = id } }, pane)
    end
  end),
} })
```

参考：[InputSelector](https://wezterm.org/config/lua/keyassignment/InputSelector.html)、[SwitchToWorkspace](https://wezterm.org/config/lua/keyassignment/SwitchToWorkspace.html)。
