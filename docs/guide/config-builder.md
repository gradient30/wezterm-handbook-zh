# 可视化配置

不想手写 Lua？可以用交互式 **WezTerm 可视化配置生成器**：勾选人群预设与选项，实时预览 `.wezterm.lua`，一键复制后放到用户目录即可热重载。

## 打开生成器

- 可视化 Page：[WezTerm 可视化配置生成器](https://cursor.com/canvas/store-5a558b8d-8fd6-47e7-ba7c-ef09c785d456/f81fac06-99e6-4119-8421-c1f9b07c9eed)
- 本仓库也可直接下载起步配置（请用下方**外链**，勿点站内相对路径）：见 [下载本仓库起步配置](#下载本仓库起步配置)（Windows + 开发者 / AI 偏向精简版）

::: tip 局限说明
生成器页面状态**不会**在刷新后保留；若浏览器沙箱限制剪贴板，请手动选中预览区文本复制。
:::


## 开启后长什么样？

生成器里的开关对应手册中的真实截图。勾选前可先看：

- [效果图廊](./preview-gallery.md)（滚动条、分屏、命令面板、状态栏、Leader…）
- 命令面板语言：[FAQ · 内置命令能不能汉化](./faq.md#内置命令-命令面板能不能汉化)（**官方无 UI 汉化**；可用 `augment-command-palette` / `InputSelector` 追加中文）

::: tip Windows Acrylic
`win32_system_backdrop = 'Acrylic'` 为 **Windows 专属**。Linux 手册截图只能示意半透明（`window_background_opacity`），不能代替亚克力模糊效果。
:::

## 三步上手

1. 在生成器里选 **人群预设** 与 **操作系统**，按需微调开关与字体 / Shell 路径。
2. 点「复制配置」，或从下方 [下载本仓库起步配置](#下载本仓库起步配置) 用外链保存。
3. 保存为：
   - Windows：`%USERPROFILE%\.wezterm.lua`（例如 `C:\Users\admin\.wezterm.lua`）
   - Linux / macOS：`~/.wezterm.lua`
4. WezTerm 会自动热重载；也可按 `Ctrl+Shift+R` 强制重载。

## 人群预设一览

| 预设 | 适合谁 | 大致开启内容 |
| --- | --- | --- |
| **轻度日常** `light` | 只想换字体 / Shell / 滚动条 | Shell、字体、滚动条、回滚 10000、默认快捷键注释、社区分屏 `Ctrl+Shift+\\|`/`-`；无 Leader、无花哨状态栏、无 AI 键 |
| **开发者** `dev` | 日常编码 | light + 彩色标签、分屏键（`Ctrl+Shift+\|` / `Ctrl+Shift+-`，Lua `_`）、Alt 切窗格、搜索相关说明、`Shift` 穿透鼠标、`Ctrl+Shift+Home/End` |
| **AI 编程重度** `ai` | Claude Code / Codex / Gemini CLI 等 | dev + 回滚 50000、滚动条、AI 注释、可选工作区键 / 旁开分屏、可选响铃 Toast |
| **运维多会话** `ops` | 多工作区 / 类 tmux | ai + `update-status` 状态栏 + Leader=`Ctrl+A` 与工作区切换 |
| **自定义** `custom` | 自己勾选 | 切换预设后再改开关；选 custom 会保留当前勾选 |

操作系统选项会影响 `default_prog` 默认值与字体回退链：

| OS | 默认 Shell | 字体回退（示意） |
| --- | --- | --- |
| Windows（默认） | `C:/Program Files/PowerShell/7/pwsh.exe` + `-NoLogo` | Cascadia Code → Consolas → Microsoft YaHei UI |
| Linux | `/bin/bash` | JetBrains Mono → DejaVu Sans Mono → Noto Sans CJK SC |
| macOS | `/bin/zsh` | SF Mono → Menlo → PingFang SC |

## 选项分类（与生成器一致）

1. **启动与 Shell** — `default_prog`、可选初始行列
2. **字体与外观** — `font_with_fallback`、字号、配色、透明度、Windows Acrylic
3. **滚动与鼠标** — 滚动条、`scrollback_lines`、`bypass_mouse_reporting_modifiers`、打字隐藏指针
4. **标签栏** — `use_fancy_tab_bar`、`tab_max_width`、彩色 `format-tab-title`、标签栏背景
5. **分屏与窗格** — 社区常用 `Ctrl+Shift+\|` / `-`（叠加默认）、Alt 方向键、关闭窗格
6. **滚动快捷键** — 补充 `Ctrl+Shift+Home/End`（Page 滚动仍是默认）
7. **常用工具键** — 仅注释说明默认 `T/W/F/P/R/C/V` 等，避免重复绑定
8. **Leader 键（重度）** — `Ctrl+A` + 类 tmux 绑定（默认关，ops 开）
9. **状态栏** — `update-status`（cwd / 工作区 / 时间；默认关，ops 开）
10. **AI 编程辅助** — 备用屏幕说明、旁开分屏、工作区键、Toast

生成结果遵循：

- `local wezterm = require 'wezterm'` + `config_builder()` + `return config`
- `config.keys = config.keys or {}` 再 `table.insert`
- 关闭项以 `-- 【默认关闭】…` 整段注释保留，便于手动打开
- 启用项带 `-- 【已启用】…` 中文说明

## 下载本仓库起步配置

::: tip 为什么不用站内相对链接？
站内相对链接（如 `/wezterm.lua`）会被 **VitePress SPA 客户端路由**拦成软 404（页面显示 PAGE NOT FOUND），即使静态文件其实存在。请用下方**绝对外链**下载。
:::

推荐按顺序尝试（国内网络优先 raw / jsDelivr）：

1. **Primary（raw）**：[wezterm.lua](https://raw.githubusercontent.com/gradient30/wezterm-handbook-zh/gh-pages/wezterm.lua)
2. **Mirror（jsDelivr）**：[wezterm.lua](https://cdn.jsdelivr.net/gh/gradient30/wezterm-handbook-zh@gh-pages/wezterm.lua)
3. **备用路径（github.io/downloads）**：[wezterm-starter.lua](https://gradient30.github.io/wezterm-handbook-zh/downloads/wezterm-starter.lua)
4. **github.io 根路径（第三选项）**：[wezterm.lua](https://gradient30.github.io/wezterm-handbook-zh/wezterm.lua) — 请**新标签打开**或**右键另存为**；若看到站点「PAGE NOT FOUND」软 404，改用上面的 raw / jsDelivr。

```powershell
# PowerShell：用 raw.githubusercontent.com（下载更可靠）
Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/gradient30/wezterm-handbook-zh/gh-pages/wezterm.lua' `
  -OutFile "$env:USERPROFILE\.wezterm.lua"
```

该文件默认已启用开发者 + AI 常用项；Leader / 状态栏 / Acrylic / Toast 等重度项保持注释，可按需取消注释。

## 相关章节

- [配置文件](/guide/config) — 查找顺序与 `config_builder`
- [外观与标签栏](/guide/appearance)
- [快捷键与滚动](/guide/keys-scroll)
- [分屏与标签](/guide/panes-tabs)
- [玩法与配方](/guide/recipes)
- [AI 编程使用方案](/guide/ai-coding)
- [常见问题 FAQ](/guide/faq)

::: warning
生成器与起步配置为社区工具，行为以 [wezterm.org](https://wezterm.org) 与你本机 WezTerm 版本为准（建议 ≥ 20240203）。
:::
