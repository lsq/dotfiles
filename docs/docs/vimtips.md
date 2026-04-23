# Vim Tips

## Movements

#### 替换特殊字符转义

1. 比如要替换${_realname}-${pkgver}为${_realname}
    需要查找表达式前添加`\V`
2. 重复上次替换，在普通模式下，输入`&`可以重复上一次`substitute`命令, 作用范围在当前行
3. 命令模式增强版`&&`可以保留替换标记`g`、`c`

#### 根据新的 `fileencoding` 设置重新加载文件内容

在 Vim 中，当你手动设置了 `fileencoding`（例如通过 `:set fileencoding=utf-8`），**这并不会自动重新读取或转换当前缓冲区的内容**。Vim 的 `fileencoding` 选项主要用于**写入文件时的编码**，而读取时的编码由 `fileencodings` 自动检测或由你指定。

如果你希望 **根据新的 `fileencoding` 设置重新加载文件内容**（即用指定编码重新解码文件），需要**重新读取文件**。以下是几种常用方法：

---

##### ✅ 方法一：使用 `:e ++enc=编码` 重新编辑文件（推荐）

这是最安全、最标准的方式：

```vim
:e ++enc=utf-8
```

将 `utf-8` 替换为你想要的编码（如 `gb18030`, `cp936`, `latin1` 等）。

> 这会用指定的编码重新读取磁盘上的文件，并替换当前缓冲区内容。

✅ 优点：
- 不会丢失未保存的修改？⚠️ **注意：如果有未保存的修改，Vim 会拒绝重载，除非加 `!`**
- 如果你确定要丢弃修改并重载：

```vim
:e! ++enc=utf-8
```

---

##### ✅ 方法二：先设置 `fenc`，再强制重载（不推荐，易出错）

```vim
:set fileencoding=utf-8
:e!
```

但这种方式**不一定生效**，因为 `:e!` 默认仍使用原来的检测编码，而不是你刚设的 `fileencoding`。所以**优先用 `++enc` 参数**。

---

##### ✅ 方法三：转换现有内容的编码（用于修复乱码）

如果你已经打开文件但显示乱码（比如本该是 GB18030 却被当 UTF-8 读了），可以用 **编码转换**：

```vim
:edit ++enc=gb18030
```

或者，如果想把当前乱码内容“当作”某种编码重新解释：

```vim
:set encoding=utf-8        " Vim 内部编码（通常保持 utf-8）
:set fileencoding=          " 清空当前 fenc
:read ++enc=gb18030 !cat %
```

但更简单的是直接 `:e ++enc=正确的编码`。

---

##### 🔍 补充：查看当前编码信息

```vim
:set fileencoding?     " 查看当前文件编码（写入时用）
:set encoding?         " 查看 Vim 内部编码（建议保持 utf-8）
```

---

##### 📌 总结

| 目标                           | 命令                 |
| ------------------------------ | -------------------- |
| 用指定编码重新加载文件（推荐） | `:e ++enc=编码名`    |
| 强制重载（丢弃修改）           | `:e! ++enc=编码名`   |
| 查看当前文件编码               | `:set fileencoding?` |

> 💡 提示：`++enc` 是 `++encoding` 的缩写。

---

##### 示例：修复 GB18030 文件乱码

```vim
:e ++enc=gb18030
```

执行后，中文应正常显示。

如有疑问，可继续提供你的具体场景（如文件实际编码、当前显示情况等），我可以给出更精准命令。

#### auto-pairs

1. 安装后，输入 ( 会自动补全为 ()
2. 在括号内输入完内容后，直接按 ) 会跳过已存在的右括号（而不是再输入一个）

#### [traversing-text-in-insert-mode](https://stackoverflow.com/questions/1737163/traversing-text-in-insert-mode)

1. While in insert mode, use `Ctrl` `O` to go to normal mode for just one command:
```vim
CTRL-O h  move cursor left 
CTRL-O l  move cursor right
CTRL-O j  move cursor down
CTRL-O k  move cursor up
```

which is probably the simplest way to do what you want and is easy to remember.
Other very useful control keys in insert mode:
```vim
CTRL-W    delete word to the left of cursor
CTRL-O D  delete everything to the right of cursor
CTRL-U    delete everything to the left of cursor
CTRL-H    backspace/delete
CTRL-J    insert newline (easier than reaching for the return key)
CTRL-T    indent current line
CTRL-D    un-indent current line
```

these will eliminate many wasteful switches back to normal mode.

### VimScript

#### How to write a VimScript
[Write a Vim script](https://neovim.io/doc/user/usr_41.html)

### Python

#### [whats-the-fastest-way-to-select-a-function-of-python-via-vimwhats-the-fastest-way-to-select-a-function-of-python-via-vim](https://stackoverflow.com/questions/6579723/whats-the-fastest-way-to-select-a-function-of-python-via-vim)

1. try `vis` to visualy select and `o` to jump edges.

2. `v]]` if what you want to select is below the cursor

3. `v[[` if it is abover the cursor

4. With this plugin https://github.com/bps/vim-textobj-python you can select, delete, change, etc:
    * `af`: a function
    * `if`: inner functionIs there a hotkey to jump to the beginning or end of a python if statement in Vim?
    * `ac`: a class
    * `ic`: inner class

5. I assume you mean visually selecting the whole function quickly. One way
   is to use the plugin Indent text object([GitHub](https://github.com/michaeljsmith/vim-indent-object)). 
   You can use `vai` to select the whole function, provided your cursor is
   inside the function and only 1 indentation level lower.

#### [Is there a hotkey to jump to the beginning or end of a python if statement in Vim?](https://vi.stackexchange.com/questions/42685/is-there-a-hotkey-to-jump-to-the-beginning-or-end-of-a-python-if-statement-in-vi)

[More efficient movements editing python files in vimMore efficient movements editing python files in vim](https://stackoverflow.com/questions/896145/more-efficient-movements-editing-python-files-in-vim)
1. You could be interested to the [vim-indentwise](https://github.com/jeetsukumaran/vim-indentwise) plugin.

   It allows you to navigate through the code by level of indentation:
    * [- one level down (e.g. from body of if to the if condition, from def to class)
    * [= same level up (e.g. from else to if)
    * ]= same level down (e.g. from if to else)

2. Square Bracket Mappings [[, ]], [m, ]m and similar

   `$VIMRUNTIME/ftplugin/python.vim` now (2018) remaps all builtin mappings
   documented under `:h ]]` and `:h ]m` for the python language. The mappings are:
    * ]] Jump forward to begin of next toplevel
    * [[ Jump backwards to begin of current toplevel (if already there, previous toplevel)
    * ]m Jump forward to begin of next method/scope
    * [m Jump backwords to begin of previous method/scope
    * ][ Jump forward to end of current toplevel
    * [] Jump backward to end of previous of toplevel
    * ]M Jump forward to end of current method/scope
    * [M Jump backward to end of previous method/scope

3. Plugin [python-mode](https://github.com/python-mode/python-mode)

4. Plugin [Pythonsense](https://github.com/jeetsukumaran/vim-pythonsense)
