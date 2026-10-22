# 转义序列（概要）

本章仅作**实用概要**，便于理解 TUI、标题栏与 Shell 集成行为。完整、持续更新的说明见官方：

- [Escape Sequences](https://wezterm.org/escape-sequences.html)

::: info 文档性质
官方明确指出该页是「活文档」，可能与某一稳定版不完全同步。实现细节以你安装的版本与官方页面为准。
:::

## 编码前提

WezTerm 将终端输出视为 **UTF-8** 码点流，不支持其它字符编码。C1 控制码的 8 位形式仅在按 Unicode 码点经 UTF-8 多字节编码后才会被识别；直接发送原始 8 位二进制通常不符合预期。日常优先使用 7 位 `ESC ...` 形式。

## 与日常相关的几类序列

### OSC：操作系统命令（标题、目录、通知等）

OSC 以 `ESC ]` 开始，参数常用 `;` 分隔，以 `ST`（`ESC \`）结束；WezTerm 也接受以 `BEL`（`0x07`）结尾。

| OSC | 作用（摘自官方表） | 示例 |
| --- | --- | --- |
| `0` | 设置窗口标题，并**清空**图标名 | `\x1b]0;title\x1b\\` |
| `1` | 设置图标名；非空时用作**标签标题** | `\x1b]1;tab-title\x1b\\` |
| `2` | 设置窗口标题 | `\x1b]2;window-title\x1b\\` |
| `4` | 设置 / 查询调色板 0–255 号颜色 | `\x1b]4;2;#cccccc\x1b\\` |
| `7` | 设置当前工作目录（Shell 集成） | 见 [Shell Integration](https://wezterm.org/shell-integration.html) |
| `8` | 显式超链接 | 见 [hyperlinks](https://wezterm.org/hyperlinks.html) |
| `9` | 显示系统 toast 通知（iTerm2 风格） | `printf "\e]9;%s\e\\" "hello"` |
| `10` / `11` / `12` | 默认前景 / 默认背景 / 光标颜色 | `\x1b]10;#ff0000\x1b\\` |
| `52` | 设置 / 清空剪贴板（查询请求被忽略） | — |
| `104` | 重置调色板为默认值 | — |
| `133` | FinalTerm 语义转义（提示符 / 输入 / 输出区） | 见 Shell Integration |
| `777` | rxvt 扩展，仅支持 `notify`（toast 通知） | `printf "\e]777;notify;%s;%s\e\\" "title" "body"` |
| `1337` | iTerm2 协议（内联图片等） | 见 [iTerm Image Protocol](https://wezterm.org/imgcat.html) |

`3`（X11 窗口属性）、`5`、`6` 被 WezTerm 忽略。

示例（Bash：分别设置窗口标题与标签标题）：

```bash
printf '\033]2;my-window\033\\'   # 窗口标题
printf '\033]1;my-tab\033\\'      # 标签标题（图标名）
```

### CSI：控制序列

以 `ESC [` 引入，覆盖光标运动、擦除、模式开关、SGR 外观等。日常最常见的是 **SGR**（以 `m` 结尾），例如加粗、下划线、256 色 / TrueColor。

### 备用屏幕与鼠标

全屏 TUI 常通过模式切换进入 **alternate screen**，并开启 **鼠标跟踪**。结果是：

- 应用绘制在备用屏幕上，主屏幕回滚不一定累积 TUI 内部视图；
- 滚轮可能作为鼠标事件发给应用。

因此会出现「在 Claude Code / 其它 TUI 里滚轮不滚动终端历史」的现象。处理思路见 [快捷键与滚动](./keys-scroll.md#tui--claude-code鼠标上报与终端滚动) 与 [FAQ](./faq.md)。

## 对普通用户的建议

1. 改标题、目录集成：优先用 shell 主题 / 官方 Shell Integration，而不是手写复杂 OSC。
2. 调试「谁改了颜色 / 标题」：怀疑程序发出了 OSC 10/11/0/1/2。
3. 需要精确协议行为：直接查阅官方 Escape Sequences 长文，并对照版本发行说明。

## 下一步

- [常见问题 FAQ](./faq.md)
- [参考链接](./references.md)
