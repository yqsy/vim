# vim
个人 Vim 配置，十分个人化，不一定每人都喜欢，选择你需要的整合到自己配置中。

## Install

默认安装:

```bash
cd ~github
git clone https://github.com/skywind3000/vim.git
echo "source '~/github/vim/asc.vim'" >> ~/.vimrc
```

额外可选:

```bash
echo "source '~/github/vim/skywind.vim'" >> ~/.vimrc
```

本配置依个人习惯，将 tabsize shiftwidth 等设置成了 4个字节宽度，并且关闭了 expandtab，不喜欢的话可以在 source 了两个文件以后覆盖该设置。

## Keymap

### 光标移动

除了 NORMAL 模式 HJKL 移动光标外，新增加所有模式的光标移动快捷键：

| 按键    | 说 明    |
| :-----: | ------   | 
| C-H | 光标左移 |
| C-J | 光标下移 |
| C-K | 光标上移 |
| C-L | 光标右移 |

这样 INSERT下面移动几个字符，或者 COMMAND 模式下左右上下移动都都可以这么来。不喜欢可以后面 unmap 掉，但是有时候稍微移动一下还要去切换模式挺蛋疼的。

大部分默认终端都没问题，一些老终端软件，如 Xshell/SecureCRT，需要确认一下 Backspace 键的编码为 127 (`CTRL-?`) 或者勾选 Backspace sends delete，保证按下 BS 键时发送 ASCII 码 127 而不是 8 (`CTRL-H`) 。

### 插入模式

| 按键    | 说 明    |
| :-----: | ------   | 
| C-A | 移动到行首 |
| C-E | 移动到行尾 |
| C-D | 光标上移 |

### 命令模式

| 按键    | 说 明    |
| :-----: | ------   | 
| C-A | 移动到行首 |
| C-E | 移动到行尾 |
| C-D | 光标上移 |
| C-P | 历史上一条命令 |
| C-N | 历史下一条命令 |

### 窗口跳转

| 按键    | 说 明    |
| :-----: | ------   | 
| TAB h | 同 CTRL-W h |
| TAB j | 同 CTRL-W j |
| TAB k | 同 CTRL-W k |
| TAB l | 同 CTRL-W l |

先按 TAB键，再按 HJKL 其中一个来跳转窗口。


### TabPage 

除了使用原生的 TabPage 切换命令 `1gt`, `2gt`, `3gt` ... 来切换标签页外，定义了如下几个快捷命令：

| 按键    | 说 明    |
| :-----: | ------   |
| \1  | 先按反斜杠 `\`再按 `1`，切换到第一个标签页 |
| \2  | 切换到第二个标签页 |
| ... | ... |
| \9  | 切换到第九个标签页 |
| \0  | 切换到第十个标签页 |
| \t  | 新建标签页，等同于 `:tabnew` |
| \g  | 关闭标签页，等同于 `:tabclose` |
| TAB n | 下一个标签页，同 `:tabnext` |
| TAB p | 上一个标签页，同 `:tabprev` |

还可以使用 ALT+SHIFT+1 到 ALT+SHIFT+0 来切换，前提是终端软件需要配置一下，将 ALT+SHIFT+1-9 配置成发送字符串：`\033]{0}1~` 到 `\033]{0}0~` 等几个不同字符串，其中 `\033` 是 ESC键的编码。


### 编译运行

| 按键    | 说 明                                                                     |
| :-----: | ------                                                                    |
| F5      | 运行当前程序，自动检测 C/Python/Ruby/Shell/JavaScript，并调用正确命令运行 |
| F7      | 调用 emake 编译当前项目， $PATH 中需要有 emake 可执行                     |
| F9      | 调用 gcc 编译当前 C/C++ 程序，$PATH 中需要有 gcc可执行，编译到当前目录下  |
| S-F10   | 打开/关闭 Tagbar 插件（查看文件内函数和类定义列表）                       |


### GrepCode

添加 GrepCode 命令，用于搜索代码（只搜索 C/C++/Python/Java/... 等代码文件不搜索其他），并且在 Quickfix 窗口中显示结果，同时配置了下面几个快捷键：

| 按键 | 说明 |
|:----:|------|
|  F10  | 打开/关闭 Quickfix 窗口       |
|  F11  | 再当前目录下 grep 光标下面的单词，并且将结果显示在 Quickfix中 |
|  F12  | 在当前项目目录中 grep 光标下面的单词，并且将结果现实在 Quickfix中 |

如何确定文件的 **项目目录**？依靠项目标志文件（project marker）来确定，项目标志文件由一个列表：

	let g:vimmake_rootmarks = [".svn", ".git", ".project", ".hg", ".root"] 

来描述，可以配置修改，即查找当前文件目录是否包含上面任意一个**标志**，有的话当前目录就是项目目录，没有的话，往上一级目录查找，直到找到**标志**，如果向上搜索到根目录都没有找到**标志**的话，就以退回来以文件所在路径为项目文件。

假设正在编辑文件为 /home/me/code/project1/src/abc.txt, 先扫描 /home/me/code/project1/src目录下是否有**标志**；没有的话，又查找 /home/me/code/project1，这时发现下面有 .svn 的文件夹，则认为：

    /home/me/code/project1 

为项目目录，如果一直向上搜索到根目录都没有找到**标志**的话，那么 abc.txt文件所在目录：

    /home/me/code/project1/src

就被当作当前文件的项目文件夹。项目标志文件用列表描述，默认为 `[".svn", ".git", ".project"]` 三个元素，可以在配置文件中修改添加。

### Quickfix

按 F10 可以打开/关闭 Quickfix 窗口，上面很多 GrepCode/编译 之类的操作都会把结果显示到 Quickfix窗口中去，在 Quickfix窗口中，有如下只能在 Quickfix窗口里使用的快捷键：

| 按键 | 说明 |
|:----:|------|
|  u  | 在上方打开文件  |
|  p  | 在预览窗口中打开文件 |

### 文件浏览

该功能主要是使用 Vim 自带的 netrw 被编辑文件的目录，方便各种方式切换文件

| 按键 | 说明 |
|:----:|------|
|  +  | 在当前窗口打开文件浏览器，浏览之前文件所在目录（当前文件为保存且无hidden则在上方显示）  |
|  TAB 7  | 在右边新窗口打开文件浏览器，浏览之前文件所在目录  |
|  TAB 8  | 在下边新窗口打开文件浏览器，浏览之前文件所在目录  |
|  TAB 9  | 在新标签打开文件浏览器，浏览之前文件所在目录  |

当文件浏览器打开以后，按 `~` 键，返回用户目录（$HOME）；按 `反引号`（1左边那个键），返回项目根目录。

### Cscope / Pycscope / Ctags

虽然大多数环境下用 Grep比较方便，无需使用 ctags/cscope，但项目大了，经常同一个关键字 Grep 出一堆乱七八糟的不相关内容来。

| 按键 | 说明 |
|:----:|------|
|  g3  | 使用 cscope 查找函数的定义，需要生成 cscope 文件 |
|  g4  | 使用 cscope 查找函数的引用，需要生成 cscope 文件 |
|  g5  | 在预览窗口内查看光标下符号的定义，再按一次显示下一个，需要生成 ctags |
|  g6  | 调用 cscope 在当前 **项目目录** 扫描 C/C++ 代码，生成 cscope文件 .cscope |
|  g7  | 调用 pycscope 在当前 **项目目录** 扫描 Python 代码，生成 pycscope文件 .cscopy |
|  g9  | 调用 ctags 在当前 **项目目录** 扫描代码，生成 ctags文件 .tags |



