# 外观与标签栏

本章涵盖配色、字体、标签栏样式，以及用 `format-tab-title` 自定义标签颜色的实用做法。

官方参考：[Colors & Appearance](https://wezterm.org/config/appearance.html)

## 配色方案

WezTerm 内置大量配色（来自 iTerm2-Color-Schemes、base16、Gogh 等）。指定名称即可：

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Batman'

return config
```

可用名称与预览见官方 [Color Schemes](https://wezterm.org/colorschemes/index.html)。

![效果预览：Tokyo Night 配色与热重载](/images/09-light-scheme-hot-reload.webp)

*效果预览：修改 `color_scheme` 后热重载（真实 WezTerm 截图）。*

也可用 `config.colors = { ... }` 精细覆盖前景、背景、光标、ANSI 色、标签栏颜色等。较新版本中：先应用 `color_scheme`，再由 `colors` 覆盖其中字段。

## 字体

主字体通过 `config.font` 设置；标签栏文字在 **关闭 fancy 标签栏** 时也会使用主字体（见下文）。

```lua
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12
```

带备选字体：

```lua
config.font = wezterm.font_with_fallback {
  'JetBrains Mono',
  'Segoe UI Emoji',
}
```

## 标签栏模式：Fancy 与 Retro

| 选项 | 含义 |
| --- | --- |
| `use_fancy_tab_bar` | `true`（默认）为系统风格标签栏；`false` 为复古（retro）标签栏 |
| `enable_tab_bar` | 是否显示标签栏 |
| `hide_tab_bar_if_only_one_tab` | 仅一个标签时隐藏标签栏 |
| `tab_bar_at_bottom` | 标签栏置于窗口底部 |
| `tab_max_width` | Retro 模式下单个标签最大宽度（单元格） |

若要自绘标签标题颜色，实践中常关闭 fancy 标签栏：

```lua
config.use_fancy_tab_bar = false
```

Fancy 模式下可用 `window_frame` 调整标题栏字体与背景；Retro 模式下通过 `colors.tab_bar` 配置活动/非活动标签颜色。详见官方 Appearance 文档。

## 自定义标签标题与颜色（format-tab-title）

使用事件 `format-tab-title` 可返回带前景/背景色的片段。下面示例在关闭 fancy 标签栏后，按标签索引着色，并让标签文字跟随 `config.font`：

```lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- 标签文字使用主字体（retro 标签栏）
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12
config.use_fancy_tab_bar = false

-- 简易调色板：按 tab 索引循环
local tab_colors = {
  { bg = '#1e3a5f', fg = '#e6edf3' },
  { bg = '#3b2f4a', fg = '#e6edf3' },
  { bg = '#1f4d3a', fg = '#e6edf3' },
  { bg = '#5c3b1e', fg = '#e6edf3' },
}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.title
  end

  local palette = tab_colors[(tab.tab_index % #tab_colors) + 1]
  local bg = tab.is_active and palette.bg or '#2a2a2a'
  local fg = tab.is_active and palette.fg or '#9da7b3'

  if hover then
    bg = '#3a3a3a'
  end

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. (tab.tab_index + 1) .. ': ' .. title .. ' ' },
  }
end)

return config
```

![效果预览：彩色标签 + 状态栏](/images/18-status-tabs.webp)

*效果预览：`use_fancy_tab_bar = false` + `format-tab-title` 着色与右侧状态（真实 WezTerm 截图）。*

::: tip 字体与标签栏的关系
- **标签标题字体**：主要取决于 `config.font`（尤其在 `use_fancy_tab_bar = false` 时）。
- **标签颜色**：通过 `format-tab-title` 返回的 `Background` / `Foreground`，或 `colors.tab_bar` 静态配置。
:::

## 窗口边距与非活动窗格

```lua
config.window_padding = {
  left = 8,
  right = 8,
  top = 6,
  bottom = 6,
}

-- 弱化非活动分屏
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}
```

透明度、背景图、渐变等见官方 Appearance 页面中的 `window_background_opacity`、`window_background_image`、`window_background_gradient`。

```lua
config.window_background_opacity = 0.92
-- Windows 专属亚克力（Linux/macOS 无效）
-- config.win32_system_backdrop = 'Acrylic'
```

![效果预览：半透明（Linux）](/images/17-opacity.webp)

*效果预览：`window_background_opacity = 0.85`（Linux X11 实拍；桌面背景较暗时对比弱）。*

::: warning Windows 专属，示意
`win32_system_backdrop = 'Acrylic'` / `Mica` 仅 Windows。本站 Linux 截图环境无法诚实展示亚克力模糊，请勿把半透明图当作 Acrylic 效果。
:::

## 下一步

- [快捷键与滚动](./keys-scroll.md)
- [分屏与标签](./panes-tabs.md)
