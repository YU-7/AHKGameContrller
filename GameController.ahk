#Requires AutoHotkey v2.0
; 从Util.ahk导入函数
#Include %A_ScriptDir%\Util.ahk
#include %A_ScriptDir%\Hearthstone.ahk
#include %A_ScriptDir%\Chrome.ahk
#include %A_ScriptDir%\DefaultMapping.ahk
#include %A_ScriptDir%\QuarkMapping.ahk
; 游戏手柄映射脚本
; 重要提示：不同品牌的手柄可能有不同的按键编号，请使用Ctrl+Alt+J来识别您手柄的正确按键代码

; 确保脚本持续运行，以便能够接收窗口消息
Persistent
; 先全局声明并赋值然后再具体的地方在声明一遍
global count := 0
global beforeWindowTitle := ""

; 使用定时器代替无限循环，这样热键功能才能正常工作
SetTimer (*) => MouseMoveControl(), 10  ; 每10毫秒执行一次基础控制
; 注册为Shell Hook窗口以接收系统级别的窗口事件
; WM_SHELLHOOKMESSAGE是系统发送窗口事件的消息ID
WM_SHELLHOOKMESSAGE := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
; 注册当前脚本窗口为Shell Hook窗口
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
; 监听Shell Hook消息
OnMessage WM_SHELLHOOKMESSAGE, OnShellHookMessage

; HSHELL_WINDOWACTIVATED是窗口激活的事件代码
HSHELL_WINDOWACTIVATED := 4

; 窗口脚本映射对象 - 使用Map代替Object以兼容v2语法N
WindowScripts := Map()
WindowScripts["edge.exe"] := ChromeScript
WindowScripts["Hearthstone.exe"] := HearthStroeMapping
WindowScripts["quark.exe"] := QuarkMapping

; Shell Hook消息处理函数
OnShellHookMessage(wParam, lParam, msg, hwnd) {
    ; 检查消息类型是否为窗口激活
    if (wParam = HSHELL_WINDOWACTIVATED) {
        ; lParam包含被激活窗口的句柄
        ScreenWidth := A_ScreenWidth
        ScreenHeight := A_ScreenHeight
        global count  ; 声明使用全局变量
        global beforeWindowTitle

        try {
            count++
            ; 使用"A"参数获取当前活动窗口的进程名
            windowTitle := WinGetProcessName("A")
            ToolTip("执行次数: " . count . "`n 当前激活的程序名: " . windowTitle, 0, 0)
            if (WindowScripts.has(beforeWindowTitle) && beforeWindowTitle != "") {
                ; 取消之前程序的映射，并处理为首次触发为空的情况
                SetTimer WindowScripts[beforeWindowTitle](), 0
            }

            ; 检查是否有对应的脚本函数
            if (WindowScripts.Has(windowTitle)) {
                ; 执行对应程序的脚本函数
                SetTimer (*) => WindowScripts[windowTitle](), 120
            } else {
                ToolTip("执行次数: " . count . "`n 无对应脚本函数 " . windowTitle, 0, 0)
                DefualtMapping()
            }
            beforeWindowTitle := windowTitle
        } catch as error {
            ; 发生错误时显示具体错误信息
            DefualtMapping()
            ToolTip("错误：文件名：" . error.File . "`n 错误信息：" . error.Message . "`n 错误行号：" . error.Line, 0, 0)
        }
    }
}

; 导入手柄按键监控模块
; #include JoyKeyMonitor.ahk
