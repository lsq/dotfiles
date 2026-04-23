$env:scoop = "~/scoop"
$env:msHome="C:\msys64\home\Administrator\.gitconfig"

#Note that running chcp 65001 from inside a PowerShell session is not effective, because .NET caches the console's output encoding on startup and is unaware of later changes made with chcp (only changes made directly via [console]::OutputEncoding] are picked up).
[console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['Get-Content:Encoding'] = 'utf8'

function scpu {
scoop update;
scoop status -l @args
foreach ($app in (scoop status)) {
	if ($APP.Info -eq "Held package") {
		continue;
	}

	try {
		scoop update $app.Name;
	}
	catch {
		Write-Output "$($app.Name) failed to update!"
		scoop reset $app.Name;
	}

	if ($LASTEXITCODE -ne 0 -or $? -eq $FALSE) {
		Write-Output "$($app.Name) failed to update!"
		scoop reset $app.Name;
	}
}
}
function setPath {
  rundll32 sysdm.cpl,EditEnvironmentVariables
}

function downGit($repo, $folder){
	$branches = irm https://api.github.com/repos/$repo/branches
	$master = $branches | Where-Object {$_.name -like "main" -or $_.name -like "master"} | select name
    $json = irm "https://api.github.com/repos/$repo/contents/$($folder)?ref=$(${master}.name)"
    $json | ForEach-Object {
		$downloadUrl = $($_).download_url
		$savePath = $($_).path
		$type = $($_).type
		if ($type -eq "file") {
			echo "$downloadUrl to $savePath"
			iwr -useb $downloadUrl | ni $savePath -Force
		}
		else
		{
			downGit $repo $savePath
		}
    }
}

function yy {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

function getProcess {
  param(
    #[Parameter(ParameterSetName = '',Mandatory = $false)]
    [Parameter(Mandatory=$true)]
    [string]$name,
    [switch]$format
  )
  if ($format) {
  Get-CimInstance Win32_Process -Filter "name like '%$name%'" | Select ProcessId, CommandLine | Format-List
  }
  else {
  Get-CimInstance Win32_Process -Filter "name like '%$name%'" | Select ProcessId, CommandLine
  }
}

function setGitProxy {
  param(
    #[Parameter(ParameterSetName = '',Mandatory = $false)]
    #[Parameter(Mandatory=$false)]
    [string]$switch = ''
  )
  Write-host "switch: $switch"
  #scoop config aria2-options
  #<#
  if ($switch -eq 'on') {
    bash -lc "sed -i '/^#\[http/{N;s/#//g;}'  $(cygpath -u $env:msHome)"
  }
  elseif ($switch -eq 'off') { bash -lc "sed -i '/^\[http/{N;s/^/#/gm;}'  $(cygpath -u $env:msHome)" }
  git config list
  #>
}

function scoopAriaProxy {
  param(
    #[Parameter(ParameterSetName = '',Mandatory = $false)]
    #[Parameter(Mandatory=$false)]
    [string]$switch = ''
  )
  Write-host "switch: $switch"
  #scoop config aria2-options
  #<#
  if ($switch -eq 'on') {
    scoop config aria2-options @('--all-proxy="http://127.0.0.1:7890"')
  }
  elseif ($switch -eq 'off') { scoop config aria2-options @('--all-proxy=""') }
  scoop config aria2-options
  #>
}

function setProxy {
  param(
    #[Parameter(ParameterSetName = '',Mandatory = $false)]
    #[Parameter(Mandatory=$false)]
    [string]$switch = ''
  )
  Write-host "switch: $switch"
  #scoop config aria2-options
  #<#
  if ($switch -eq 'on') {
    $env:ALL_PROXY="http://127.0.0.1:7890"
  }
  elseif ($switch -eq 'off') { $env:ALL_PROXY="" }
  Write-host $env:ALL_PROXY
  #>
}

function sli { scoop list }
function sud { scoop update }
function suda { scoop update * }
function scl { scoop cleanup * }
function sst { scoop status }
function sck { scoop checkup }
function scat { scoop config aria2-enabled true }
function scaf { scoop config aria2-enabled false }
function srm { Remove-Item -r $env:scoop\cache\*; Clear-Host }
function sbl { Set-Location $env:scoop\buckets\lsq }
function sbe { Set-Location $env:scoop\buckets\extras }
function sbc { Set-Location $env:scoop\buckets\scoopet }

#Import-Module PSCompletions

Import-Module scoop-completion
#night-owl
#tonybaloney
#oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/easy-term.omp.json" | Invoke-Expression
Import-Module -Name Terminal-Icons

#if ($host.Name -eq 'ConsoleHost')
#{
  Import-Module PSReadLine
#}
#>
# 起始位置
#Set-Location ~/desktop

# ------------------设置别名-----------------------
new-alias edit notepad3.exe

# 清除主机
# Clear-Host
#<#
#-------------------PSReadline------------------------


# 设置 Ctrl+d 为菜单补全和 Intellisense #
# Set-PSReadLineKeyHandler -Key "Tab" -Function MenuComplete
#>
#<#
Set-PSReadLineOption -EditMode Emacs
if ($PSVersionTable.PSVersion -eq
  7) {
  Set-PSReadLineOption -PredictionSource HistoryAndPlugin
  Set-PSReadLineOption -PredictionViewStyle ListView
}
Set-PSReadLineOption -BellStyle None
#>

<# 下面那句有问题
# 设置 Ctrl+d 为退出
PowerShell Set-PSReadlineKeyHandler -Key "Ctrl+d" -Function ViExit
#>
# 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo
# 设置 Tab 键补全
Set-PSReadlineKeyHandler -Key Tab -Function Complete

Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Chord "Ctrl+e" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
}
# 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward

# 设置向下键为前向搜索历史纪录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
# In Emacs mode - Tab acts like in bash, but the Windows style completion
# is still useful sometimes, so bind some keys so we can do both
Set-PSReadLineKeyHandler -Key Ctrl+n -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+p -Function TabCompletePrevious
# CaptureScreen is good for blog posts or email showing a transaction
# of what you did when asking for help or demonstrating a technique.
# Set-PSReadLineKeyHandler -Chord 'Ctrl+d,Ctrl+c' -Function CaptureScreen
#>
<#
# 一些 PSReadline 配置
$PSReadLineOptions = @{
	EditMode = "Emacs"
	HistoryNoDuplicates = $true
	HistorySearchCursorMovesToEnd = $true
	Colors = @{
		# 提示文字颜色，原来的颜色太浅了，我这里换了
		Prediction = '#8F8B8B'
	}
}
Set-PSReadLineOption @PSReadLineOptions
#>
Invoke-Expression (& starship init powershell)

<#
# rbenv for Windows
$env:RBENV_ROOT = "d:\Ruby"

# 国内用户使用内置镜像
# 注意，这一行必须放在init之前
$env:RBENV_USE_MIRROR = "CN"

& "$env:RBENV_ROOT\rbenv\bin\rbenv.ps1" init
#>
Import-Module PSCompletions