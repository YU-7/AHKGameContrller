#Requires AutoHotkey v2.0
; 从Util.ahk导入函数
#Include %A_ScriptDir%\Util.ahk
; 游戏手柄映射脚本
; 重要提示：不同品牌的手柄可能有不同的按键编号，请使用Ctrl+Alt+J来识别您手柄的正确按键代码

; 确保脚本持续运行，以便能够接收窗口消息
Persistent

; 注册为Shell Hook窗口以接收系统级别的窗口事件
; WM_SHELLHOOKMESSAGE是系统发送窗口事件的消息ID
WM_SHELLHOOKMESSAGE := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
; 注册当前脚本窗口为Shell Hook窗口
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
; 监听Shell Hook消息
OnMessage WM_SHELLHOOKMESSAGE, OnShellHookMessage

; HSHELL_WINDOWACTIVATED是窗口激活的事件代码
HSHELL_WINDOWACTIVATED := 4
Sensitivity := 0.5  ; 鼠标灵敏度 (1-10)
; 窗口脚本映射对象 - 使用Map代替Object以兼容v2语法
WindowScripts := Map()
WindowScripts["notepad.exe"] := NotepadScript
WindowScripts["chrome.exe"] := ChromeScript
global count := 0

; Shell Hook消息处理函数
OnShellHookMessage(wParam, lParam, msg, hwnd) {
    ; 检查消息类型是否为窗口激活
    if (wParam = HSHELL_WINDOWACTIVATED) {
        ; lParam包含被激活窗口的句柄
        ScreenWidth := A_ScreenWidth
        ScreenHeight := A_ScreenHeight
        global count  ; 声明使用全局变量
        
        try {
            count++
            ; 使用"A"参数获取当前活动窗口的进程名
            windowTitle := WinGetProcessName("A")
            
            ToolTip("调试信息：窗口被激活 " . count, ScreenWidth // 2, ScreenHeight - 30)
            ToolTip("当前激活的程序名: " . windowTitle, ScreenWidth // 2, ScreenHeight - 30)
            
            ; 检查是否有对应的脚本函数
            if (WindowScripts.Has(windowTitle)) {
                ; 执行对应程序的脚本函数
                WindowScripts[windowTitle]()
            }
            
        } catch {
            ; 发生错误时显示提示
            ToolTip("错误：无法获取窗口信息", ScreenWidth // 2, ScreenHeight - 30)
        }
    }
}

; Notepad专用脚本
NotepadScript() {
    ; 为记事本设置特定的控制行为
    ; 弹出提示框显示灵敏度设置
    MsgBox("记事本窗口的鼠标灵敏度设置：\n左摇杆速度: " . (Sensitivity * 0.8) . "\n右摇杆速度: 0.1", "窗口特定设置")
}

; Chrome专用脚本
ChromeScript() {
    ; 为Chrome设置特定的控制行为
    global LeftCurrentSpeed := Sensitivity * 1.2  ; 稍高的灵敏度
    global RightCurrentSpeed := 0.15  ; 右摇杆速度稍快
}

; 导入手柄按键监控模块
; #include JoyKeyMonitor.ahk
; 全局变量用于存储当前的移动速度
global LeftCurrentSpeed := Sensitivity
global RightCurrentSpeed := 0.1
; 使用定时器代替无限循环，这样热键功能才能正常工作
SetTimer (*) => ControlMouseWithJoystick(LeftCurrentSpeed), 10  ; 每10毫秒执行一次左摇杆控制
SetTimer (*) => ControlMouseWithRightJoystick(RightCurrentSpeed), 10  ; 每10毫秒执行一次右摇杆控制

; 十字键映射为方向键 - 使用POV值
SetTimer CheckPOVDirection, 50

; 添加了Z轴监控定时器
SetTimer ControlMouseWithJoyZ, 50      ; 每50毫秒检查一次Z轴状态，映射为鼠标左键
