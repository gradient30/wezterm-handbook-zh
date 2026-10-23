# 效果图廊

本页汇总手册中的**真实 WezTerm 截图**（Linux X11 / AppImage `20240203-110809-5046fc22`，配色多为 Tokyo Night，CJK 字体 Noto Sans CJK SC）。Windows 界面一致，边框与系统字体可能不同。

::: tip 怎么用
对照 [可视化配置生成器](./config-builder.md) 的开关：先看图再决定是否启用。每张图旁注明对应配置项与原文链接。
:::

## 外观与标签

| 效果 | 截图 | 相关配置 / 页面 |
| --- | --- | --- |
| 配色热重载 | ![配色](/images/09-light-scheme-hot-reload.webp) | `color_scheme` · [外观](./appearance.md) |
| 彩色标签 + 状态栏 | ![标签](/images/18-status-tabs.webp) | `format-tab-title` · `update-status` · [外观](./appearance.md) / [配方](./recipes.md) |
| 半透明 | ![半透明](/images/17-opacity.webp) | `window_background_opacity` · [外观](./appearance.md) |
| Windows Acrylic | （无实拍） | `win32_system_backdrop` · **Windows 专属，示意**，勿用 Linux 半透明图代替 |

## 滚动与历史

| 效果 | 截图 | 相关配置 / 页面 |
| --- | --- | --- |
| 滚动条开 | ![开](/images/11-scrollbar-on.webp) | `enable_scroll_bar = true` · [快捷键与滚动](./keys-scroll.md) |
| 滚动条关 | ![关](/images/12-scrollbar-off.webp) | `enable_scroll_bar = false` |
| 搜索回滚 | ![搜索](/images/05-search.webp) | `Ctrl+Shift+F` · [独家功能](./features.md) |

## 分屏 · 标签 · Leader

| 效果 | 截图 | 相关配置 / 页面 |
| --- | --- | --- |
| 社区分屏 `\|` / `-` | ![分屏](/images/13-splits.webp) | `SplitHorizontal` / `SplitVertical` · [分屏](./panes-tabs.md) |
| 窗格缩放 | ![缩放](/images/07-pane-zoom.webp) | `TogglePaneZoomState` · [分屏](./panes-tabs.md) |
| AI 三分屏布局 | ![AI](/images/01-ai-layout.webp) | `gui-startup` · [AI 编程](./ai-coding.md) |
| Leader 激活提示 | ![Leader](/images/20-leader-active.webp) | `config.leader` + `leader_is_active()` · [快捷键](./keys-scroll.md) |

## 命令面板 · 启动器 · 选择器（与汉化）

| 效果 | 截图 | 说明 |
| --- | --- | --- |
| 命令面板（内置英文） | ![面板英](/images/19-palette-default-en.webp) | **官方无 UI 汉化** · [FAQ](./faq.md#内置命令-命令面板能不能汉化) |
| 中文追加项 | ![面板中](/images/14-palette-zh.webp) | `augment-command-palette` / `launch_menu.label` |
| InputSelector 中文 | ![选择器](/images/15-input-selector-zh.webp) | `InputSelector` · [配方](./recipes.md) |
| 启动器中文 label | ![启动器](/images/16-launcher-zh.webp) | `ShowLauncher` + `launch_menu` |
| 工作区切换 | ![工作区](/images/10-workspaces.webp) | `ShowLauncherArgs { flags = 'FUZZY\|WORKSPACES' }` |
| 启动器（英文菜单项） | ![启动器2](/images/06-launcher.webp) | 内置域条目仍为英文 |

## 编辑与选择

| 效果 | 截图 | 快捷键 |
| --- | --- | --- |
| QuickSelect | ![QS](/images/03-quickselect.webp) | `Ctrl+Shift+Space` |
| Copy Mode | ![CM](/images/04-copy-mode.webp) | `Ctrl+Shift+X` |
| 命令面板（概览） | ![P](/images/02-command-palette.webp) | `Ctrl+Shift+P` |

## 截图说明

- 抓取方式：`ffmpeg -f x11grab` 对准 WezTerm 窗口；与 [独家功能](./features.md) 页一致。
- Acrylic / 部分 Windows 专属效果：**无法在本站 Linux 环境诚实截取**，正文用 Callout「Windows 专属，示意」说明。
