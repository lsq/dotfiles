-- Shell 配置
local wezterm = require 'wezterm'
local ps={ label = 'PowerShell', args = { 'C:/Program Files/PowerShell/7-preview/pwsh.exe' } }
local msys2 = { label = 'MSYS / MSYS2', args = { 'C:/msys64/msys2_shell.cmd', '-defterm', '-here', '-no-start', '-shell', 'zsh', '-msys' }}
local ucrt64 = { label = 'MSYS2 / UCRT64', args = { 'C:/msys64/msys2_shell.cmd', '-defterm', '-here', '-no-start', '-shell', 'zsh', '-ucrt64' }}
local mingw64 = { label = 'MSYS2 / MINGW64', args = { 'C:/msys64/msys2_shell.cmd', '-defterm', '-here', '-no-start', '-shell', 'zsh', '-mingw64' }}
--local archwsl = { label = 'Arch-wsl', args = { 'C:/Windows/system32/wsl.exe' ,'-d','Arch' }}
--local ubuntuwsl = { label = 'Ubuntu-wsl', args = { 'C:/Windows/system32/wsl.exe' ,'-d','Ubuntu' }}
--local launch_menu = {ps, msys2, archwsl,ubuntuwsl}
local launch_menu = {ps, msys2, ucrt64, mingw64}
local module = {}
function module.apply(config)
    -- 默认终端
    config.default_prog = ucrt64.args
    -- shell 菜单列表
    config.launch_menu = launch_menu
end


return module
