# 特有便捷性与独家功能

本页梳理 WezTerm 区别于多数终端的能力，并给出最小可用配置。所有默认快捷键均以 [官方默认按键表](https://wezterm.org/config/default-keys.html) 为准（Windows / Linux 用 `Ctrl+Shift`；macOS 部分动作另有 `Cmd` 键位，如 `Cmd+F` 搜索、`Cmd+R` 重载，`Ctrl+Shift` 组合在 macOS 上同样有效）。

::: tip 截图说明
本页截图均为 **真实截图**：在 Linux（X11）上运行 WezTerm 20240203-110809-5046fc22，配色 `Tokyo Night`，用 `ffmpeg -f x11grab` 抓取窗口。Windows 上界面一致，仅字体与窗口边框不同。
:::

## 速查表

| 功能 | 默认操作 | 官方文档 |
| --- | --- | --- |
| Lua 配置 + 热重载 | 保存即生效；`Ctrl+Shift+R` 手动重载 | [Configuration](https://wezterm.org/config/files.html) |
| 命令面板 | `Ctrl+Shift+P` | [ActivateCommandPalette](https://wezterm.org/config/lua/keyassignment/ActivateCommandPalette.html) |
| QuickSelect | `Ctrl+Shift+Space` | [quickselect](https://wezterm.org/quickselect.html) |
| Copy Mode | `Ctrl+Shift+X` | [copymode](https://wezterm.org/copymode.html) |
| 搜索回滚区 | `Ctrl+Shift+F` | [Search](https://wezterm.org/config/lua/keyassignment/Search.html) |
| 分屏（【默认】） | `Ctrl+Shift+Alt+"`（上下）/ `Ctrl+Shift+Alt+%`（左右） | [default-keys](https://wezterm.org/config/default-keys.html) |
| 分屏（【社区常用自定义】） | `Ctrl+Shift+\\|`（左右）/ `Ctrl+Shift+-`（上下，Lua `key='_'`） | 见 [分屏与标签](./panes-tabs.md) |
| 窗格缩放 | `Ctrl+Shift+Z` | [TogglePaneZoomState](https://wezterm.org/config/lua/keyassignment/TogglePaneZoomState.html) |
| 调试浮层 / Lua REPL | `Ctrl+Shift+L` | [ShowDebugOverlay](https://wezterm.org/config/lua/keyassignment/ShowDebugOverlay.html) |

## 1. Lua 可编程配置与热重载

配置文件 `.wezterm.lua` 本身就是 Lua 程序：可以 `require` 子模块、写条件判断、注册事件回调。WezTerm 会监视配置文件，**保存后自动重载**（可用 `automatically_reload_config = false` 关闭）。

![热重载：仅修改 color_scheme 并保存，窗口立即切换为浅色方案](/images/09-light-scheme-hot-reload.webp)

*图：将 `color_scheme` 改为 `Tokyo Night Day` 并保存，无需重启即生效（真实截图）。*

## 2. 内置多路复用（无需 tmux）

WezTerm 自带标签、分屏、窗口与 **multiplexer domain**：本地 `unix` 域可让会话在 GUI 关闭后保留，`ssh` 域在远端运行 `wezterm-mux-server` 实现类似 tmux 的“断开重连”。详见 [Multiplexing](https://wezterm.org/multiplexing.html)。

```lua
config.unix_domains = { { name = 'unix' } }
-- 启动时自动连接（GUI 关闭后会话仍在）
config.default_gui_startup_args = { 'connect', 'unix' }
```

## 3. 命令面板 `Ctrl+Shift+P`


::: tip 命令面板语言
内置动作名称**固定英文**，官方无 gettext/locale。可用 `augment-command-palette` **追加**中文条目，或用 `InputSelector` / `launch_menu.label` 做中文菜单。详见 [FAQ：内置命令能不能汉化](./faq.md#内置命令-命令面板能不能汉化)。
:::

模糊搜索所有可用动作及其快捷键，忘记按键时最实用。

![命令面板列出所有动作及其默认快捷键](/images/02-command-palette.webp)

*图：命令面板（真实截图）。*

## 4. QuickSelect `Ctrl+Shift+Space`

自动识别屏幕上的 URL、路径、哈希、IP 等，并给每处标上字母前缀；键入前缀即复制，**大写前缀**则复制并粘贴。可通过 `quick_select_patterns` 增加自定义正则。

![QuickSelect：哈希与 URL 被标注了字母前缀](/images/03-quickselect.webp)

*图：每个 `sha=` 值与 URL 前出现了高亮的字母前缀（真实截图）。*

## 5. Copy Mode `Ctrl+Shift+X`

类似 vim 的键盘选择模式：`h/j/k/l` 移动、`v` 选择字符、`Shift+V` 选择行、`Ctrl+V` 块选、`y` 复制并退出，`Esc` / `q` / `Ctrl+C` 退出。

![Copy Mode：用 v 与 k 选中多行输出](/images/04-copy-mode.webp)

*图：Copy Mode 下的键盘选区（真实截图）。*

`Ctrl+Shift+F` 搜索回滚区，匹配项高亮，`Enter` / `Ctrl+P` 跳到上一个匹配、`Ctrl+N` 跳到下一个匹配：

![搜索回滚区并高亮匹配](/images/05-search.webp)

*图：搜索 `step 19` 的高亮结果（真实截图）。*

## 6. 超链接识别

`hyperlink_rules` 用正则把文本变为可点击链接（默认左键单击即可打开；程序开启鼠标上报时可用 `Shift+单击` 绕过），也支持程序输出的 OSC 8 显式超链接。可在默认规则基础上追加，例如把 `#123` 映射为 issue 链接。参见 [hyperlinks](https://wezterm.org/hyperlinks.html)。

```lua
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
  regex = [[\b[tT](\d+)\b]],
  format = 'https://example.com/tasks/?t=$1',
})
```

## 7. 终端内图片

支持 iTerm2 图片协议、Kitty 图形协议与 Sixel。`wezterm imgcat 图片.png` 可直接在终端显示图片。参见 [imgcat](https://wezterm.org/imgcat.html)。

## 8. 工作区 Workspaces

工作区是一组窗口的命名集合，适合“一个项目一个工作区”。`wezterm start --workspace 名称` 启动到指定工作区，`ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' }` 模糊切换。参见 [workspaces 配方](https://wezterm.org/recipes/workspaces.html)。

![工作区切换器列出 api-server、blog-site](/images/10-workspaces.webp)

*图：绑定 `Alt+W` 打开工作区切换器；右上角状态栏显示当前工作区 `ai-project`（真实截图）。*

## 9. SSH 域与 WSL 域

- `ssh_domains`：`wezterm connect 域名` 连接远端，远端窗格成为本地标签/分屏。
- Windows 上 WezTerm 会自动为已安装的 WSL 发行版生成 `WSL:发行版名` 域（见 [wsl_domains](https://wezterm.org/config/lua/config/wsl_domains.html)）。

```lua
config.ssh_domains = { { name = 'dev', remote_address = 'dev.example.com', username = 'me' } }
-- 新标签默认进入 WSL（按实际发行版名修改）
-- config.default_domain = 'WSL:Ubuntu'
```

## 10. 启动菜单 launch_menu

`launch_menu` 定义常用程序，在标签栏 `+` 上右键或绑定 `ShowLauncher` 打开。

![启动器：自定义的 launch_menu 项位于列表顶部](/images/06-launcher.webp)

*图：启动器（`ShowLauncher`），前 3 项来自 `launch_menu`（真实截图）。*

## 11. 状态栏 `update-status`

窗口事件 [`update-status`](https://wezterm.org/config/lua/window-events/update-status.html)（旧名 `update-right-status` 已不推荐）周期触发（间隔由 `status_update_interval` 控制，默认 1000 ms），可调用 `window:set_left_status()` / `window:set_right_status()` 显示时间、工作区、电量等。完整代码见 [玩法与配方](/guide/recipes#状态栏-时间-工作区)。

## 12. 背景图、透明与跟随系统深浅色

- `window_background_opacity`（0–1）设置透明；Windows 11 可配合 `win32_system_backdrop = 'Acrylic'`。
- `window_background_image` 或更灵活的 `background` 图层。
- `wezterm.gui.get_appearance()` 返回 `Dark`/`Light`，配合配置重载即可跟随系统（见 [get_appearance](https://wezterm.org/config/lua/wezterm.gui/get_appearance.html)）。


## 命令面板 / 启动器中文变通 {#命令面板--启动器中文变通}

官方无 UI 汉化。推荐组合：

| 手段 | 能否中文 | 说明 |
| --- | --- | --- |
| 内置 Command Palette 项 | 否 | `commands.rs` 英文 brief |
| `augment-command-palette` | 是（追加） | [`brief`/`doc`](https://wezterm.org/config/lua/window-events/augment-command-palette.html) 任意 UTF-8 |
| `config.keys` 自定义键 | 面板标题仍英文 | 无 description 字段；面板用动作派生英文名 |
| `InputSelector` | 是 | `title`/`choices.label` |
| `launch_menu.label` | 是 | 出现在 Launcher / 也可进面板 |

![默认英文命令面板](/images/19-palette-default-en.webp)

*效果预览：内置项英文（真实 WezTerm 截图）。*

![中文追加项](/images/14-palette-zh.webp)

*效果预览：搜索「中文」命中自定义 brief / launch_menu（真实 WezTerm 截图）。*

## 13. 串口 serial

`wezterm serial COM3`（Windows）或 `wezterm serial /dev/ttyUSB0 --baud 115200` 直接连接串口设备，也可配置 `serial_ports` 作为域使用。参见 [serial](https://wezterm.org/cli/serial.html)。

## 14. Shell 集成

通过 OSC 7/133 上报当前目录与提示符区域，WezTerm 可在相同目录打开新分屏、用 `ScrollToPrompt` 在命令之间跳转。参见 [shell-integration](https://wezterm.org/shell-integration.html)。
