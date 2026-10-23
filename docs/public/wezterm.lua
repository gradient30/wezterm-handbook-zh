-- =============================================================================
-- WezTerm 起步配置 · Windows + 开发者 / AI 编程偏向（精简版）
-- 生成时间（Asia/Shanghai）: 2026-10-23
-- 中文手册: https://gradient30.github.io/wezterm-handbook-zh/
-- 可视化生成器: 见手册「可视化配置」章节
-- 官方文档: https://wezterm.org/
-- 保存位置: %USERPROFILE%\.wezterm.lua（例: C:\Users\admin\.wezterm.lua）
-- 热重载: 保存后自动，或 Ctrl+Shift+R
-- =============================================================================
-- 说明:
-- · 【已启用】段落已生效
-- · 【默认关闭】段落整段注释；去掉行首 -- 即可启用
-- · 本文件面向 Windows + PowerShell 7（pwsh）；其它系统请改 default_prog / 字体
-- =============================================================================

local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.keys = config.keys or {}

-- 【已启用】默认启动程序 default_prog（PowerShell 7）
config.default_prog = { 'C:/Program Files/PowerShell/7/pwsh.exe', '-NoLogo' }

-- 【默认关闭】初始窗口大小（可选）（取消下行注释即可启用）
-- config.initial_cols = 120
-- config.initial_rows = 36

-- 【已启用】字体与字号（Cascadia + Consolas + 雅黑 UI）
config.font = wezterm.font_with_fallback({
  'Cascadia Code',
  'Consolas',
  'Microsoft YaHei UI',
})
config.font_size = 12

-- 【已启用】配色方案
config.color_scheme = 'Catppuccin Mocha'

-- 【默认关闭】窗口透明度（取消下行注释即可启用）
-- config.window_background_opacity = 0.92

-- 【默认关闭】Windows Acrylic（取消下行注释即可启用）
-- config.win32_system_backdrop = 'Acrylic'

-- 【已启用】显示滚动条
config.enable_scroll_bar = true

-- 【已启用】回滚行数（AI 长输出建议 50000）
config.scrollback_lines = 50000

-- 【已启用】打字时隐藏鼠标
config.hide_mouse_cursor_when_typing = true

-- 【已启用】Shift 穿透鼠标上报（TUI / AI CLI 下按住 Shift 可滚回滚）
config.bypass_mouse_reporting_modifiers = 'SHIFT'

-- 【已启用】关闭 Fancy 标签栏（便于 format-tab-title 着色）
config.use_fancy_tab_bar = false

-- 【已启用】标签最大宽度
config.tab_max_width = 25

-- 【已启用】标签栏背景
config.colors = config.colors or {}
config.colors.tab_bar = {
  background = '#1a1b26',
}

-- 【已启用】彩色标签 format-tab-title
local tab_colors = {
  { bg = '#1e3a5f', fg = '#e6edf3' },
  { bg = '#3b2f4a', fg = '#e6edf3' },
  { bg = '#1f4d3a', fg = '#e6edf3' },
  { bg = '#5c3b1e', fg = '#e6edf3' },
}
wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local title = tab.tab_title
  if not title or #title == 0 then title = tab.active_pane.title end
  local palette = tab_colors[(tab.tab_index % #tab_colors) + 1]
  local bg = tab.is_active and palette.bg or '#2a2a2a'
  local fg = tab.is_active and palette.fg or '#9da7b3'
  if hover then bg = '#3a3a3a' end
  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. (tab.tab_index + 1) .. ': ' .. title .. ' ' },
  }
end)

-- 【已启用】默认快捷键说明（勿重复绑定，除非 disable_default_key_assignments）
-- Ctrl+Shift+T 新建标签 · Ctrl+Shift+W 关闭标签 · Ctrl+Tab 切换标签
-- Ctrl+Shift+F 搜索 · Ctrl+Shift+P 命令面板 · Ctrl+Shift+R 重载
-- Ctrl+Shift+C/V 复制粘贴 · Shift+PageUp/Down 按页滚 · Ctrl+=/-/0 字体
-- Ctrl+Shift+Alt+" SplitVertical(上下) · Ctrl+Shift+Alt+% SplitHorizontal(左右)
-- 手册: https://gradient30.github.io/wezterm-handbook-zh/guide/keys-scroll

-- 【已启用】自定义分屏 Ctrl+Shift+| 与 _（SplitHorizontal=左右 · SplitVertical=上下）
table.insert(config.keys, { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } })
table.insert(config.keys, { key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } })

-- 【已启用】Alt+方向键切换窗格
table.insert(config.keys, { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' })
table.insert(config.keys, { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' })
table.insert(config.keys, { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' })
table.insert(config.keys, { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' })

-- 【已启用】关闭当前窗格
table.insert(config.keys, { key = 'x', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } })

-- 【已启用】滚到顶部/底部
table.insert(config.keys, { key = 'Home', mods = 'CTRL|SHIFT', action = act.ScrollToTop })
table.insert(config.keys, { key = 'End', mods = 'CTRL|SHIFT', action = act.ScrollToBottom })

-- 【默认关闭】Leader=Ctrl+A 类 tmux（运维多会话再开）（取消下行注释即可启用）
-- config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
-- table.insert(config.keys, { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } })
-- table.insert(config.keys, { key = '-', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } })
-- table.insert(config.keys, { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' })
-- table.insert(config.keys, { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' })
-- table.insert(config.keys, { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' })
-- table.insert(config.keys, { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' })
-- table.insert(config.keys, { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState })
-- table.insert(config.keys, { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' })
-- table.insert(config.keys, { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } })
-- table.insert(config.keys, { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } })

-- 【默认关闭】状态栏 cwd / 工作区 / 时间（update-status；运维推荐）
-- wezterm.on('update-status', function(window, pane)
--   local cwd = ''
--   local ok, uri = pcall(function() return pane:get_current_working_dir() end)
--   if ok and uri then cwd = tostring(uri.file_path or uri) end
--   window:set_left_status(wezterm.format {
--     { Foreground = { Color = '#7aa2f7' } },
--     { Text = '  ' .. cwd .. '  ' },
--   })
--   window:set_right_status(wezterm.format {
--     { Foreground = { Color = '#7aa2f7' } },
--     { Text = '  ' .. window:active_workspace() .. '  ' },
--     { Foreground = { Color = '#9ece6a' } },
--     { Text = wezterm.strftime '%Y-%m-%d %H:%M  ' },
--   })
-- end)
-- -- 旧名 update-right-status 已不推荐

-- 【已启用】AI 编程辅助说明
-- AI CLI 常启用备用屏幕 + 鼠标上报：
-- 1) 按住 Shift 再滚轮，或开 bypass_mouse_reporting_modifiers
-- 2) 更大 scrollback_lines + enable_scroll_bar
-- 3) 响铃 + Toast（见下方，默认关闭）
-- https://gradient30.github.io/wezterm-handbook-zh/guide/ai-coding

-- 【已启用】Ctrl+Alt+S 右侧 AI 窗格
table.insert(config.keys, { key = 's', mods = 'CTRL|ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } })

-- 【已启用】工作区切换 Ctrl+Shift+1..9
for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = 'CTRL|SHIFT', action = act.SwitchToWorkspace { name = 'ws' .. tostring(i) } })
end
table.insert(config.keys, { key = 'l', mods = 'CTRL|SHIFT', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } })

-- 【默认关闭】响铃 Toast（取消下行注释即可启用）
-- config.audible_bell = 'Disabled'
-- config.visual_bell = { fade_in_duration_ms = 75, fade_out_duration_ms = 75, target = 'CursorColor' }
-- wezterm.on('bell', function(window, pane)
--   window:toast_notification('WezTerm', '会话响铃（任务可能已完成）', nil, 4000)
-- end)

return config
