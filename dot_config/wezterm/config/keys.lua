-- 快捷键绑定
local wezterm = require 'wezterm'
local module = {}
function module.apply(config)
    config.keys = {
        { key = 'm',  mods = 'CTRL', action = wezterm.action.ShowLauncher },
        { key = 'm', mods = 'CTRL|ALT', action = wezterm.action.ShowTabNavigator },
        -- Ctrl+Shift+N 新窗口
        { key = 'N', mods = 'SHIFT|CTRL', action = wezterm.action.SpawnWindow },
        -- Ctrl+Shift+T 新 tab
        { key = 'T', mods = 'SHIFT|CTRL', action = wezterm.action.ShowLauncher },
        -- Ctrl+Shift+Enter 显示启动菜单
        { key = 'Enter', mods = 'SHIFT|CTRL', action = wezterm.action.ShowLauncherArgs { flags = 'FUZZY|TABS|LAUNCH_MENU_ITEMS' } },
        { key = 'w', mods = 'CTRL', action = wezterm.action.CloseCurrentTab { confirm = false } },
    }
end
return module
