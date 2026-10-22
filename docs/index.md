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
      text: 官方文档 wezterm.org
      link: https://wezterm.org
features:
  - title: 配置即 Lua
    details: 使用 .wezterm.lua 声明外观、启动程序、快捷键与标签栏，修改后自动热重载。
  - title: Windows 友好
    details: 覆盖配置路径、PowerShell 7（pwsh）、标签颜色、滚动条与 TUI 鼠标穿透等实用主题。
  - title: 非官方说明
    details: 本站为社区中文手册，不是官方翻译。行为与选项以 https://wezterm.org 为准。
---

## 手册导读

| 章节 | 内容 |
| --- | --- |
| [安装与入门](/guide/install) | 安装、首次启动、配置位置 |
| [配置文件](/guide/config) | 查找顺序、`config_builder`、模块拆分 |
| [外观与标签栏](/guide/appearance) | 配色、字体、标签标题与颜色 |
| [快捷键与滚动](/guide/keys-scroll) | 常用键、滚动条、TUI 滚动技巧 |
| [分屏与标签](/guide/panes-tabs) | 分屏、标签、`exit` 的含义 |
| [CLI 与进阶](/guide/cli) | `wezterm` / `wezterm-gui` 与常用子命令 |
| [转义序列（概要）](/guide/escape-sequences) | OSC / CSI 等与日常相关的要点 |
| [常见问题 FAQ](/guide/faq) | TUI 无法滚动、配置误贴到 PowerShell 等 |
| [参考链接](/guide/references) | 官方文档入口 |

::: warning 声明
本手册由社区维护，**不是** WezTerm 官方文档或官方中文翻译。配置项、默认快捷键与版本行为请始终对照 [wezterm.org](https://wezterm.org)。
:::
