------------------ bat 传递参数 --------------
@echo off
d:\dev\python25\python.exe d:\dev\mingw\emake.py %*


------------------ 右键增加 -----------------
regedit 修改注册表：
HKEY_CLASSES_ROOT\*\Shell 下面建立 Vim 项目（子目录）
右边的默认字符串改为：“Open With Vim Tab”
右边新建一个字符串值：名称为“Icon" 值为："C:\Program Files (x86)\Vim\Vim74\gvim.exe"
代表右键菜单的图标。

HKEY_CLASSES_ROOT\*\Shell\Vim 下面建立名为 command 的项目
右边的默认字符串改为：
"C:\Program Files (x86)\Vim\vim74\gvim.exe" -p --remote-tab-silent "%1" "%*"