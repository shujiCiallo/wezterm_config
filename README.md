WezTerm 快捷键指南 (Ubuntu/Linux)
💡 按键说明：

ALT：即 mod.SUPER 键。

ALT + CTRL：即 mod.SUPER_REV 键（组合键）。

LEADER（前缀键）：按下 ALT + CTRL + 空格，此时左侧状态栏会出现图标，随后紧接着按下对应字母即可进入特殊模式。

📑 基础与常用操作
快捷键	功能描述
ALT + r	重载配置文件 (Reload Config)
ALT + q	退出 WezTerm
ALT + f	搜索文本 (搜索框)
ALT + CTRL + u	快速选择并打开终端里的 URL 链接
F1	进入复制模式 (Copy Mode)，可使用 Vim 键位移动光标
F2	打开命令面板 (Command Palette)
F3	打开启动器 (Launcher)
F4	打开标签页启动器 (Fuzzy Tabs)
F5	打开工作区启动器 (Fuzzy Workspaces)
F11	切换全屏 (Full Screen)
F12	显示调试覆盖层 (Debug Overlay)
📋 复制与粘贴
注意：在 Linux 下，配置默认使用 CTRL + SHIFT 进行复制粘贴，以保留原生的 CTRL + C/V 给终端内的程序使用。

快捷键	功能描述
CTRL + SHIFT + c	复制选中内容到剪贴板
CTRL + SHIFT + v	从剪贴板粘贴
🪟 窗口 (Window) 管理
快捷键	功能描述
ALT + n	新建窗口 (Spawn Window)
ALT + =	放大窗口 (每次增加 50px)
ALT + -	缩小窗口 (每次减少 50px)
ALT + CTRL + Enter	最大化当前窗口
🗂️ 标签页 (Tabs) 管理
快捷键	功能描述
ALT + t	新建标签页 (默认 Shell)
ALT + CTRL + w	关闭当前标签页
ALT + [	切换到上一个标签页
ALT + ]	切换到下一个标签页
ALT + CTRL + [	将当前标签页向左移动
ALT + CTRL + ]	将当前标签页向右移动
ALT + 0	手动修改当前标签页名称
ALT + CTRL + 0	重置标签页名称为默认
ALT + 9	隐藏/显示顶部标签栏
🪟 窗格 (Panes) 管理 (分屏)
快捷键	功能描述
ALT + \	垂直分屏 (左右分屏)
ALT + |	水平分屏 (上下分屏)
ALT + Enter	切换当前窗格缩放 (Zoom)
ALT + w	关闭当前窗格
ALT + CTRL + h	焦点切换到左侧窗格
ALT + CTRL + l	焦点切换到右侧窗格
ALT + CTRL + k	焦点切换到上方窗格
ALT + CTRL + j	焦点切换到下方窗格
ALT + CTRL + p	打开窗格选择菜单 (可按键进行交换或跳转)
ALT + u	向上滚动 5 行
ALT + d	向下滚动 5 行
PageUp / PageDown	向上/向下翻页滚动
🖼️ 背景图控制
快捷键	功能描述
ALT + /	随机切换一张背景图
ALT + ,	切换到上一张背景图
ALT + .	切换到下一张背景图
ALT + CTRL + /	打开背景选择器菜单 (可按名称搜索)
ALT + b	切换专注模式 (隐藏/显示背景图和标签栏)
🪄 特殊模式 (Key Tables)
先按下 LEADER (ALT + CTRL + 空格)，松开后，再按下以下字母进入对应模式：

1. 调整字体模式 (LEADER + f)
按下 LEADER 后按 f，进入字体调整模式：

k：放大字体

j：缩小字体

r：重置字体大小

Esc 或 q：退出该模式

2. 调整窗格大小模式 (LEADER + p)
按下 LEADER 后按 p，进入窗格调整模式：

k / j / h / l：向 上/下/左/右 调整当前窗格大小

Esc 或 q：退出该模式

3. 类 Vim (Normal) 导航模式 (LEADER + v)
按下 LEADER 后按 v，进入类似 Vim 的纯键盘操作模式（非常高效）：

h / j / k / l：在窗格之间移动

Shift + H / J / K / L：向 左/下/上/右 调整窗格大小

s：垂直分屏（左右）

v：水平分屏（上下）

c：关闭当前窗格

t：新建标签页

n：新建窗口

y：进入复制模式

Esc 或 q：退出该模式

🖱️ 鼠标操作
CTRL + 鼠标左键点击：直接打开鼠标光标下的 URL 链接。
