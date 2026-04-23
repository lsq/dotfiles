#!/usr/bin/env bash

echo "running in ${CHEZMOI_OS}."
echo "CHEZMOI_DEST_DIR is: |${CHEZMOI_DEST_DIR}|"
# printenv | grep "^CHEZMOI"
# Only run on Windows
if [ "${CHEZMOI_OS}" != "windows" ]; then
    exit 0
fi

set -euo pipefail

# ==============================
# 配置区：定义源 -> 目标的映射
# 格式: "源路径|目标路径|链接类型"
# 链接类型: hardlink (文件硬链接), symlink (文件/目录软链接), junction (目录 junction)
# ==============================

# 获取 destDir (即 C:/Users/Administrator 或其他)
DEST_DIR="${CHEZMOI_DEST_DIR:-$HOME}"

# 假设 msys2home 是 destDir 下的子目录；可改为绝对路径如 /d/dotfiles/msys2home
MSYS2_HOME="$DEST_DIR/msys2homeTest"

# 创建 msys2home 目录（如果不存在）
mkdir -p "$MSYS2_HOME"

linkContent() {
    printf '%s\n' "$DEST_DIR/$1|$MSYS2_HOME/$1|$2"
}
hardlinkct() {
    linkContent "$1" "hardlink"
}
junctionlinkct() {
    linkContent "$1" "junction"
}
symlinkct() {
    linkContent "$1" "symlink"
}

# 配置映射数组
# 注意：路径应使用 MSYS2 风格（/c/Users/...），不要用反斜杠
LINK_MAPPINGS=(
    # 源 (由 chezmoi 管理，在 DEST_DIR 下) | 目标 (在 MSYS2_HOME 下) | 类型
    "$DEST_DIR/.vimrc|$MSYS2_HOME/.vimrc|hardlink"
    # 可选：为原生 Windows Vim 创建 _vimrc
    "$DEST_DIR/.vimrc|$DEST_DIR/_vimrc|hardlink"
    # 添加更多...
    "$DEST_DIR/.bashrc|$MSYS2_HOME/.bashrc|hardlink"
    "$DEST_DIR/.bash_profile|$MSYS2_HOME/.bash_profile|hardlink"
    "$DEST_DIR/.gemrc|$MSYS2_HOME/.gemrc|hardlink"
    "$DEST_DIR/.gitconfig|$MSYS2_HOME/.gitconfig|hardlink"
    "$DEST_DIR/.globalrc|$MSYS2_HOME/.globalrc|hardlink"
    "$(hardlinkct .minttyrc)"
    "$(hardlinkct .npmrc)"
    "$(hardlinkct .p10k.zsh)"
    "$(hardlinkct .polipo)"
    "$(hardlinkct .profile)"
    "$(hardlinkct .vimrc_dpp)"
    # "$DEST_DIR/.zshrc|$MSYS2_HOME/.zshrc|hardlink"
    "$(hardlinkct .zshrc)"
    "$DEST_DIR/.config|$MSYS2_HOME/.config|junction"
    "$(junctionlinkct .cache)"
    "$(junctionlinkct .cpan-w64)"
    "$(junctionlinkct .local)"
    "$(junctionlinkct .vim)"
    "$(junctionlinkct .docs)"
    "$DEST_DIR/.vim|$DEST_DIR/vimfiles|junction"
    "$DEST_DIR/.config/clash|$DEST_DIR/.config/mihomo|junction"
    "$DEST_DIR/Documents/Microsoft.PowerShell_profile.ps1|/d/Backup/Documents/Microsoft.PowerShell_profile.ps1|symlink"
)

# ==============================
# 函数：创建链接
# $1: source (existing file/dir)
# $2: target (to be created)
# $3: type ("hardlink", "symlink", "junction")
# ==============================
create_link() {
    local src="$1"
    local tgt="$2"
    local type="$3"

    # 路径必须存在
    if [ ! -e "$src" ]; then
        echo "Warning: source does not exist, skipping: $src" >&2
        return 0
    fi

    # 如果目标已存在，先删除（谨慎！）
    if [ -e "$tgt" ] || [ -L "$tgt" ]; then
        echo "Removing existing target: $tgt"
        rm -rf "$tgt"
    fi

    case "$type" in
        hardlink)
            if [ -f "$src" ]; then
                echo "Creating hard link: $tgt <- $src"
                cp -l "$src" "$tgt"
            else
                echo "Error: hardlink only supports files, not directory: $src" >&2
                return 1
            fi
            ;;
        symlink)
            echo "Creating symbolic link: $tgt -> $src"
            ln -sf "$src" "$tgt"
            ;;
        junction)
            if [ -d "$src" ]; then
                echo "Creating junction: $tgt => $src"
                # 使用 cmd.exe 的 mklink /J 创建目录 junction
                # 注意：路径需转换为 Windows 风格（带盘符、反斜杠）
                win_src=$(cygpath -a -w "$src")
                win_tgt=$(cygpath -a -w "$tgt")
                cmd.exe //C mklink //J "${win_tgt}" "${win_src}" > /dev/null
            else
                echo "Error: junction only supports directories: $src" >&2
                return 1
            fi
            ;;
        *)
            echo "Error: unsupported link type: $type" >&2
            return 1
            ;;
    esac
}

# ==============================
# 主逻辑：遍历配置并创建链接
# ==============================
for mapping in "${LINK_MAPPINGS[@]}"; do
    IFS='|' read -r src tgt type <<< "$mapping"
    create_link "$src" "$tgt" "$type"
done

echo "✅ All links created successfully."
