---
layout: home
hero:
  name: WezTerm 中文手册
  text: 跨平台 GPU 加速终端
  tagline: 社区编写的简体中文使用手册（非官方）。面向 Windows 入门与日常配置，含可复制粘贴的 Lua 示例。
  actions:
    - theme: brand
      text: 开始阅读
      link: /guide/install
    - theme: alt
      text: 可视化配置生成器
      link: /guide/config-builder
    - theme: alt
      text: 官方文档 wezterm.org
      link: https://wezterm.org
features:
  - title: 配置即 Lua
    details: 使用 .wezterm.lua 声明外观、启动程序、快捷键与标签栏，修改后自动热重载。
  - title: 可视化配置
    details: 交互式勾选人群预设与选项，实时生成可复制的 .wezterm.lua；也可下载仓库起步配置。
    link: /guide/config-builder
  - title: Windows 友好
    details: 覆盖配置路径、PowerShell 7（pwsh）、标签颜色、滚动条与 TUI 鼠标穿透等实用主题。
  - title: 独家功能一览
    details: 内置多路复用、命令面板、QuickSelect、Copy Mode、工作区、SSH/WSL 域，附真实截图。
    link: /guide/features
  - title: 玩法与配方
    details: 状态栏、Leader 键、深浅色切换、智能分屏、项目切换器等可直接复制的 Lua 片段。
    link: /guide/recipes
  - title: AI 编程工作台
    details: 为 Claude Code / Codex / Gemini CLI / Aider 设计分屏布局、一键启动、完成提醒与脚本化会话。
    link: /guide/ai-coding
  - title: 非官方说明
    details: 本站为社区中文手册，不是官方翻译。行为与选项以 https://wezterm.org 为准。
---

## 手册导读

| 章节 | 内容 |
| --- | --- |
| [安装与入门](/guide/install) | 安装、首次启动、配置位置 |
| [配置文件](/guide/config) | 查找顺序、`config_builder`、模块拆分 |
| [可视化配置](/guide/config-builder) | 交互式生成器 + 下载起步 `wezterm.lua` |
| [外观与标签栏](/guide/appearance) | 配色、字体、标签标题与颜色 |
| [快捷键与滚动](/guide/keys-scroll) | 常用键、滚动条、TUI 滚动技巧 |
| [分屏与标签](/guide/panes-tabs) | 分屏、标签、`exit` 的含义 |
| [特有便捷性与独家功能](/guide/features) | 多路复用、命令面板、QuickSelect、工作区等 |
| [玩法与配方](/guide/recipes) | 可直接复制的 Lua 配方 |
| [AI 编程使用方案](/guide/ai-coding) | AI CLI 分屏布局、提醒与脚本化 |
| [CLI 与进阶](/guide/cli) | `wezterm` / `wezterm-gui` 与常用子命令 |
| [转义序列（概要）](/guide/escape-sequences) | OSC / CSI 等与日常相关的要点 |
| [常见问题 FAQ](/guide/faq) | TUI 无法滚动、配置误贴到 PowerShell 等 |
| [参考链接](/guide/references) | 官方文档入口 |

::: warning 声明
本手册由社区维护，**不是** WezTerm 官方文档或官方中文翻译。配置项、默认快捷键与版本行为请始终对照 [wezterm.org](https://wezterm.org)。
:::
