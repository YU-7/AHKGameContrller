#Requires AutoHotkey v2.0
; 从Util.ahk导入函数
#Include %A_ScriptDir%\Config.ahk
#Include %A_ScriptDir%\Util.ahk
#include %A_ScriptDir%\Hearthstone.ahk
#include %A_ScriptDir%\Chrome.ahk
#include %A_ScriptDir%\DefaultMapping.ahk
#include %A_ScriptDir%\QuarkMapping.ahk
; 游戏手柄映射脚本
; 重要提示：不同品牌的手柄可能有不同的按键编号，请使用Ctrl+Alt+J来识别您手柄的正确按键代码

; 确保脚本持续运行，以便能够接收窗口消息
Persistent

; 摇杆和扳机键控制使用轮询控制
SetTimer (*) => MouseMoveControl(), 30
; 全局映射按钮
GlobalMappingButton(ControllerButtonMapping)
; 注册为Shell Hook窗口以接收系统级别的窗口事件
; WM_SHELLHOOKMESSAGE是系统发送窗口事件的消息ID
WM_SHELLHOOKMESSAGE := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
; 注册当前脚本窗口为Shell Hook窗口
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
; 监听Shell Hook消息
OnMessage WM_SHELLHOOKMESSAGE, OnShellHookMessage

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

            ; 检查是否有对应的脚本函数
            if (WindowScripts.Has(windowTitle)) {
                ; 执行对应程序的脚本函数
                WindowScripts[windowTitle]()
            } else {
                ToolTip("执行次数: " . count . "`n 无对应脚本函数 " . windowTitle, 0, 0)
                SetTimer (*) => DefualtMapping(), 120
            }
            beforeWindowTitle := windowTitle
        } catch as error {
            ; 发生错误时显示具体错误信息
            SetTimer (*) => DefualtMapping(), 120
            ToolTip("错误：文件名：" . error.File . "`n 错误信息：" . error.Message . "`n 错误行号：" . error.Line . "`n 错误类型：" .
                beforeWindowTitle, 0,
                0)
        }
    }
}

; 导入手柄按键监控模块
; #include JoyKeyMonitor.ahk
