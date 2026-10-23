# AI 编程使用方案

适用于 Claude Code、Codex CLI、Gemini CLI、Cline（CLI）、Aider 等在终端里运行的 AI 编程工具（TUI/CLI）。WezTerm 本身不与任何 AI 工具集成；本页介绍如何用它的分屏、工作区、事件与 CLI 打造顺手的工作台。

::: info 约定
- 标注 **“建议”** 的内容是社区经验，不是官方规范；其余配置项与行为均可在 [wezterm.org](https://wezterm.org) 查证。
- AI 工具的启动命令（如 `claude`、`codex`、`gemini`、`aider`）以各工具官方文档为准，需自行安装并在 `PATH` 中。
- 示例默认 Windows + PowerShell 7（`pwsh.exe`），路径用正斜杠。
:::

## 推荐布局：左 AI，右 shell / 测试 / 日志

![左侧长输出窗格，右上 shell，右下测试输出](/images/01-ai-layout.webp)

*图：真实截图。左侧为 AI CLI 位置示意，此处运行的是长输出命令（并非任何厂商的界面）；右上为 shell，右下为测试输出；右上角状态栏显示工作区与时间。*

**建议**：AI 窗格占 55–65% 宽度，便于阅读 diff；右侧上方执行命令、下方跑 `npm test -- --watch` 或 `Get-Content -Wait` 跟踪日志。

分屏快捷键：【默认】`Ctrl+Shift+Alt+%` / `"`；【社区常用自定义】`Ctrl+Shift+|`（左右）与 `Ctrl+Shift+-`（上下，Lua `key = '_'`）。见 [分屏与标签](./panes-tabs.md)。

## gui-startup：启动即自动布局

[`gui-startup`](https://wezterm.org/config/lua/gui-events/gui-startup.html) 事件在 GUI 启动时触发，可用 `wezterm.mux` 创建窗口和分屏：

```lua
local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = wezterm.config_builder()
config.default_prog = { 'pwsh.exe', '-NoLogo' }

wezterm.on('gui-startup', function(cmd)
  local cwd = 'D:/code/my-app'
  local tab, ai, window = mux.spawn_window { workspace = 'my-app', cwd = cwd }
  local shell = ai:split { direction = 'Right', size = 0.4, cwd = cwd }
  local logs = shell:split { direction = 'Bottom', size = 0.4, cwd = cwd }
  ai:send_text 'claude\r\n'        -- 换成 codex / gemini / aider
  logs:send_text 'npm test -- --watch\r\n'
  ai:activate()
  mux.set_active_workspace 'my-app'
end)

return config
```

## 用工作区按项目隔离

每个项目一个 [workspace](https://wezterm.org/recipes/workspaces.html)：AI 会话、终端历史和标签互不干扰。配合 [玩法与配方](/guide/recipes#inputselector-项目切换器-每个项目一个工作区) 中的项目切换器，或绑定工作区列表（`Alt+W` 为**自定义**键）：

```lua
config.keys = {
  { key = 'w', mods = 'ALT', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
}
```

![工作区切换器](/images/10-workspaces.webp)

*图：`Alt+W` 列出所有工作区（真实截图）。*

## launch_menu 与快捷键一键启动 AI CLI

```lua
config.launch_menu = {
  { label = 'Claude Code', args = { 'pwsh.exe', '-NoLogo', '-NoExit', '-Command', 'claude' } },
  { label = 'Codex CLI',   args = { 'pwsh.exe', '-NoLogo', '-NoExit', '-Command', 'codex' } },
  { label = 'Gemini CLI',  args = { 'pwsh.exe', '-NoLogo', '-NoExit', '-Command', 'gemini' } },
  { label = 'Aider',       args = { 'pwsh.exe', '-NoLogo', '-NoExit', '-Command', 'aider' } },
}
local act = wezterm.action
config.keys = config.keys or {}
-- 【自定义】Alt+L 打开启动器
table.insert(config.keys, { key = 'l', mods = 'ALT', action = act.ShowLauncher })
-- 【自定义】Ctrl+Shift+Alt+A：在当前窗格左侧分出占 60% 的 AI 窗格
table.insert(config.keys, { key = 'A', mods = 'CTRL|SHIFT|ALT', action = act.SplitPane {
  direction = 'Left', size = { Percent = 60 },
  command = { args = { 'pwsh.exe', '-NoLogo', '-NoExit', '-Command', 'claude' } },
} })
```

`-NoExit` 让 AI 工具退出后窗格留在 pwsh，不会直接关闭（**建议**）。

![启动器中的 launch_menu 项](/images/06-launcher.webp)

*图：启动器（真实截图，菜单项为演示用命令）。*

## 滚动与鼠标捕获

AI TUI 通常开启鼠标上报或备用屏幕，导致滚轮/选择被程序“吃掉”：

- 按住 **Shift** 再拖动/点击即可绕过程序的鼠标捕获，由 WezTerm 处理选择——由 [`bypass_mouse_reporting_modifiers`](https://wezterm.org/config/lua/config/bypass_mouse_reporting_modifiers.html) 控制，默认即 `SHIFT`。
- 默认 `Shift+PageUp` / `Shift+PageDown` 按页滚动 WezTerm 的回滚区。
- `Ctrl+Shift+Home/End` **不是默认键**，需自行绑定：

```lua
table.insert(config.keys, { key = 'Home', mods = 'CTRL|SHIFT', action = act.ScrollToTop })
table.insert(config.keys, { key = 'End',  mods = 'CTRL|SHIFT', action = act.ScrollToBottom })
config.enable_scroll_bar = true
config.scrollback_lines = 20000   -- 默认 3500；AI 长输出建议调大
```

注意：程序处于备用屏幕（全屏 TUI）时，其内部内容不进入 WezTerm 回滚区，应使用该工具自身的滚动方式。

## 在长输出中搜索、复制 AI 的回答

- `Ctrl+Shift+F` 搜索回滚区（匹配高亮，`Enter` / `Ctrl+P` 跳到上一个更早的匹配，`Ctrl+N` 下一个）。
- `Ctrl+Shift+X` 进入 Copy Mode，键盘选择后 `y` 复制。
- `Ctrl+Shift+Space` QuickSelect 一键复制文件路径、哈希、URL。
- `Ctrl+Shift+Z` 放大当前窗格专心阅读。

![Copy Mode 选中多行](/images/04-copy-mode.webp)

*图：Copy Mode 选中输出（真实截图）。*

![QuickSelect 标注可复制项](/images/03-quickselect.webp)

*图：QuickSelect 标出的哈希与 URL（真实截图）。*

## 中文输入法

Windows 下 WezTerm 默认启用 IME（`use_ime = true`），可直接用中文输入法给 AI 写提示词。若候选框位置异常或需要关闭，调整 [`use_ime`](https://wezterm.org/config/lua/config/use_ime.html)。中文字体回退示例：

```lua
config.font = wezterm.font_with_fallback { 'JetBrains Mono', 'Microsoft YaHei' }
```

## AI 完成时提醒：bell 事件

多数 CLI 在需要确认或完成时可输出 BEL（是否输出取决于具体工具及其设置）。WezTerm 侧：

- [`audible_bell`](https://wezterm.org/config/lua/config/audible_bell.html)：`'SystemBeep'`（默认）或 `'Disabled'`。
- [`visual_bell`](https://wezterm.org/config/lua/config/visual_bell.html)：闪烁窗格背景。
- [`bell`](https://wezterm.org/config/lua/window-events/bell.html) 事件：在任意窗格（包括非活动标签）响铃时触发，可配合 [`window:toast_notification`](https://wezterm.org/config/lua/window/toast_notification.html) 弹出系统通知。

```lua
config.visual_bell = {
  fade_in_function = 'EaseIn', fade_in_duration_ms = 100,
  fade_out_function = 'EaseOut', fade_out_duration_ms = 200,
}
config.colors = { visual_bell = '#3b4261' }

wezterm.on('bell', function(window, pane)
  window:toast_notification('WezTerm', '窗格 ' .. pane:pane_id() .. ' 有新动静（AI 可能已完成）', nil, 4000)
end)
```

**建议**：在 `format-tab-title` 中用 `tab.active_pane.has_unseen_output` 给有新输出的后台标签加标记，作为“AI 已输出”的轻量提示。

## 用 `wezterm cli` 脚本化启动 AI 会话

在 WezTerm 窗格内运行时，`wezterm cli` 会自动连接当前实例（详见 [CLI](https://wezterm.org/cli/cli/index.html)）。PowerShell 示例 `ai-session.ps1`：

```powershell
$cwd = 'D:/code/my-app'
$ai    = wezterm cli spawn --cwd $cwd
$shell = wezterm cli split-pane --pane-id $ai --right --percent 40 --cwd $cwd
$logs  = wezterm cli split-pane --pane-id $shell --bottom --percent 40 --cwd $cwd
wezterm cli set-tab-title --pane-id $ai 'AI'
wezterm cli send-text --no-paste --pane-id $ai "claude`r"
wezterm cli send-text --no-paste --pane-id $logs "npm test -- --watch`r"
wezterm cli activate-pane --pane-id $ai
```

本页第一张截图即用同样的 `spawn` / `split-pane` / `send-text` 流程在 Linux 上生成。
