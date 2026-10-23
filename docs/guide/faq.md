# 常见问题 FAQ

## 配置改了却没生效？

1. 确认文件路径正确：Windows 推荐 `%USERPROFILE%\.wezterm.lua`。
2. 确认扩展名不是 `.lua.txt`。
3. 保存后按 `Ctrl+Shift+R`（macOS `Cmd+R`）强制重载，或新开一个 WezTerm 窗口。
4. 若配置有语法错误，WezTerm 会提示并回退默认配置——先修正 Lua 语法。
5. 检查是否被命令行 `--config` / `--config-file` 覆盖。

## 把 Lua 粘贴到 PowerShell 里报错？

这是预期行为。Lua 配置只能写在 `.wezterm.lua`（或 `wezterm.lua`）里，由 **WezTerm 进程**加载。  
PowerShell 不会执行 `require 'wezterm'`。请用编辑器打开配置文件粘贴。

## 如何默认打开 pwsh 而不是 cmd？

```lua
config.default_prog = {
  'C:/Program Files/PowerShell/7/pwsh.exe',
  '-NoLogo',
}
```

路径按本机安装位置修改。参见 [安装与入门](./install.md)。

## 标签颜色 / 标签字体怎么改？

- 颜色：使用 `format-tab-title` 事件返回带 `Background` / `Foreground` 的片段；或配置 `colors.tab_bar`。
- 字体：设置 `config.font`；自定义上色时建议 `use_fancy_tab_bar = false`。

完整示例见 [外观与标签栏](./appearance.md)。

## 如何显示滚动条、加长历史？

```lua
config.enable_scroll_bar = true
config.scrollback_lines = 10000
```

参见 [快捷键与滚动](./keys-scroll.md)。

## TUI / Claude Code 等场景无法用滚轮滚动终端 {#tui-claude-code-等场景无法用滚轮滚动终端}

**原因概要**：应用进入备用屏幕并开启鼠标上报后，滚轮事件优先交给应用。

**建议**：

```lua
config.bypass_mouse_reporting_modifiers = 'SHIFT' -- 默认值
```

然后使用：

- 按住 `Shift` + 滚轮 滚动终端视口；
- `Shift+PageUp` / `Shift+PageDown` 按页滚动；
- `Ctrl+Shift+Home` / `Ctrl+Shift+End` 跳到回滚两端（**自定义**键，绑定方法见 [快捷键与滚动](./keys-scroll.md#自定义快捷键)）。

这不能把 TUI 内部的虚拟列表「变成」终端回滚；只能在终端层面绕过鼠标上报。

## 默认分屏键按了没反应？想改成 `Ctrl+Shift+|` / `-`？

默认分屏是 **`Ctrl+Shift+Alt+"`**（上下）与 **`Ctrl+Shift+Alt+%`**（左右），三个修饰键缺一不可（[Discussion #5248](https://github.com/wezterm/wezterm/discussions/5248)）。美式键盘上 `"` / `%` 本身还要 `Shift`。

社区常用自定义（与默认**并存**）：

```lua
{ key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
{ key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
-- key='_' 对应手势 Ctrl+Shift+-（Mapped 下 Shift+- → _）
```

完整说明见 [分屏与标签](./panes-tabs.md) / [快捷键与滚动](./keys-scroll.md)。

## `exit` 能不能退出分屏模式？


不能把它理解成「退出分屏模式」的专用指令。`exit` 结束的是 **当前窗格中的 shell 会话**；进程结束后窗格通常关闭。分屏只是多个窗格的布局，没有单独的 exit-split-mode 命令。详见 [分屏与标签](./panes-tabs.md)。

## Windows 桌面快捷方式弹出黑色控制台？

快捷方式请指向 `wezterm-gui.exe`，而不是仅用于控制台交互的 `wezterm.exe`。见 [CLI 与进阶](./cli.md)。

## 如何确认本机快捷键？

```bash
wezterm show-keys
wezterm show-keys --lua
```

## 本手册与官方文档冲突时听谁的？

**以 [https://wezterm.org](https://wezterm.org) 为准。**  
本站是社区中文手册，不是官方翻译。

## 下一步

- [参考链接](./references.md)
