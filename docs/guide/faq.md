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


## 内置命令 / 命令面板能不能汉化？ {#内置命令-命令面板能不能汉化}

**结论：官方没有 UI 汉化（无 gettext / locale 切换）。** 命令面板、菜单栏、启动器里的**内置**动作名称写死为英文；自定义项可用中文标签。

### 依据

| 点 | 说明 |
| --- | --- |
| 源码 | [`wezterm-gui/src/commands.rs`](https://github.com/wezterm/wezterm/blob/main/wezterm-gui/src/commands.rs) 中 `CommandDef.brief` / `doc` 为英文硬编码字符串（如 `"Activate Command Palette"`、`"Split Horizontally (Left/Right)"`） |
| AppImage | 发行包无 `share/locale` 一类 gettext 目录；`wezterm show-keys` 输出亦为英文 |
| 文档翻译 | [Issue #1705 Document Translation](https://github.com/wezterm/wezterm/issues/1705) 讨论的是**文档**多语言，不是 GUI i18n |
| 自定义键 | `config.keys` **没有** `description` / `brief` 字段；自定义键进入面板时，标题由 `derive_command_from_key_assignment` 按动作类型生成**英文** brief |

### 可行变通（均可写中文）

1. **`augment-command-palette`**：向命令面板**追加**中文条目（不替换内置英文项）。API：[`augment-command-palette`](https://wezterm.org/config/lua/window-events/augment-command-palette.html)（`brief` / `doc` / `action` / `icon`）。
2. **`InputSelector`**：自建中文选择菜单（`title` / `description` / `choices[].label`）。API：[`InputSelector`](https://wezterm.org/config/lua/keyassignment/InputSelector.html)。
3. **`launch_menu` 的 `label`**：启动器顶部可显示中文标签。见 [Launch Menu](https://wezterm.org/config/launch.html)。
4. **`ShowLauncherArgs`**：可自定义 `title` / `help_text` 等（较新版本）；内置域条目如 `New Tab (...)` 仍为英文模板。
5. **状态栏 / Toast**：`update-status`、`toast_notification` 文本可自写中文。
6. **手册中文别名表**：在本站用中文说明对应英文面板项（见 [效果图廊](./preview-gallery.md)）。

最小示例（追加中文面板项 + InputSelector）：

```lua
local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

wezterm.on('augment-command-palette', function(window, pane)
  return {
    {
      brief = '【中文】左右分屏',
      doc = '等价于 SplitHorizontal',
      action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
  }
end)

config.keys = {
  {
    key = 'm',
    mods = 'ALT',
    action = act.InputSelector {
      title = '中文菜单',
      description = '选择后回车，Esc 取消',
      choices = {
        { id = 'split', label = '左右分屏' },
        { id = 'cancel', label = '取消' },
      },
      action = wezterm.action_callback(function(window, pane, id, label)
        if id == 'split' then
          window:perform_action(act.SplitHorizontal { domain = 'CurrentPaneDomain' }, pane)
        end
      end),
    },
  },
}

config.launch_menu = {
  { label = '中文·Bash', args = { 'bash', '-l' } },
}

return config
```

效果预览（真实 WezTerm 截图）：

![命令面板默认仍为英文](/images/19-palette-default-en.webp)

*效果预览：命令面板内置项为英文（真实 WezTerm 截图）。*

![用中文过滤后的自定义面板项](/images/14-palette-zh.webp)

*效果预览：`augment-command-palette` / `launch_menu` 的中文 brief·label（真实 WezTerm 截图）。*

![InputSelector 中文菜单](/images/15-input-selector-zh.webp)

*效果预览：`InputSelector` 中文 title / label（真实 WezTerm 截图）。*


## 下一步

- [参考链接](./references.md)
