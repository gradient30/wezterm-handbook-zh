# CLI 与进阶

官方参考：[CLI Reference](https://wezterm.org/cli/general.html)

## 两个主要可执行文件

| 程序 | 用途 |
| --- | --- |
| `wezterm`（Windows 为 `wezterm.exe`） | 在终端中与 WezTerm 交互、脚本调用；需要时会委托 GUI |
| `wezterm-gui`（Windows 为 `wezterm-gui.exe`） | 从桌面环境启动 GUI |

Windows 上若为桌面快捷方式 / 开始菜单启动，应优先指向 **`wezterm-gui.exe`**，以免系统再弹出一个用于日志的控制台窗口。

注意：在 Windows 上直接对 `wezterm-gui.exe` 运行 `--help` 可能看不到控制台输出（GUI 子系统）。请使用 `wezterm.exe --help`。

## 全局选项（节选）

```text
wezterm [OPTIONS] [COMMAND]

  -n, --skip-config           跳过加载 wezterm.lua
      --config-file <PATH>    指定配置文件
      --config <name=value>   覆盖单项配置
  -h, --help
  -V, --version
```

## 常用子命令

| 子命令 | 说明 |
| --- | --- |
| `start`（别名 `-e`） | 启动 GUI，可指定替代程序 |
| `ssh` | SSH 会话 |
| `serial` | 串口 |
| `connect` | 连接到 multiplexer |
| `ls-fonts` | 字体信息 |
| `show-keys` | 显示快捷键分配 |
| `cli` | 与实验性 mux server 交互 |
| `imgcat` | 向终端输出图像 |
| `set-working-directory` | 通过 OSC 7 告知当前目录 |
| `record` / `replay` | 录制 / 回放 asciicast |
| `shell-completion` | 生成 shell 补全 |

### 启动并运行指定程序

```bash
wezterm start -- vim ~/.wezterm.lua
wezterm start --cwd /some/path
```

Windows PowerShell 示例：

```powershell
wezterm start -- cwd $HOME\projects
```

### 查看快捷键与字体

```bash
wezterm show-keys
wezterm show-keys --lua
wezterm ls-fonts
wezterm ls-fonts --list-system
```

## 配置调试建议

1. 用 `--config-file` 指向一份最小复现配置，隔离问题。
2. 用 `--config key=value` 临时验证单个选项。
3. 需要排查按键时，可在配置中设置 `debug_key_events = true`（会在日志中打印按键），用完关闭。

```lua
config.debug_key_events = true
```

## 与 multiplexer / 域相关的进阶主题

WezTerm 支持本地与远程域、SSH 域、tls 域等高级用法。配色在 multiplexer 场景下可能由 **服务端配置** 决定。完整说明见官方文档中的 Multiplexing 章节（入口见 [参考链接](./references.md)）。

## 下一步

- [转义序列（概要）](./escape-sequences.md)
- [参考链接](./references.md)
