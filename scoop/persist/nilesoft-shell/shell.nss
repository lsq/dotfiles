settings
{
	priority=1
	exclude.where = !process.is_explorer
	showdelay = 200
	// Options to allow modification of system items
	modify.remove.duplicate=1
	tip.enabled=true
}

import 'imports/theme.nss'
import 'imports/images.nss'

import 'imports/modify.nss'

menu(mode="multiple" title="Pin/Unpin" image=icon.pin)
{
}

menu(mode="multiple" title=title.more_options image=icon.more_options)
{
}

import 'imports/terminal.nss'
import 'imports/file-manage.nss'
import 'imports/develop.nss'
import 'imports/goto.nss'
import 'imports/taskbar.nss'

item(title="Hello, master!" cmd=msg('Hello @user.name'))
separator
menu(title = 'sub menu' image = #0000ff)
{
	item(title = 'test sub-item' cmd = msg('hahaha'))
}
separator
//item(where=package.exists("WindowsTerminal") title="Windows_Terminal(PowerShell)" tip=tip_run_admin admin=has_admin image='@package.path("Windows PowerShell")\powershell.exe' cmd="wt.exe" arg='new-tab -p "Windows PowerShell" -d "@sel.path\."')
item(where=package.exists("WindowsTerminal") title="Windows_Terminal(PowerShell)" tip=tip_run_admin admin=has_admin image='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' cmd="wt.exe" arg='new-tab -p "Windows PowerShell" -d "@sel.path\."')
item(where=package.exists("WindowsTerminal") title="Windows_Terminal(PowerShell7)" tip=tip_run_admin admin=has_admin image='C:\Program Files\PowerShell\7\pwsh.exe' cmd="wt.exe" arg='new-tab -p "PowerShell" -d "@sel.path\."')