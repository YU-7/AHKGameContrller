#Requires AutoHotkey v2.0

; 游戏手柄映射脚本
; 功能：1. 左摇杆映射为鼠标控制 2. 十字键映射为方向键
; 重要提示：不同品牌的手柄可能有不同的按键编号，请使用Ctrl+Alt+J来识别您手柄的正确按键代码

; 配置参数（必须放在#Include之前，避免被return语句跳过）
Sensitivity := 1  ; 鼠标灵敏度 (1-10)
Deadzone := 20    ; 摇杆死区，防止微小移动被误触发
; 初始化变量
LastJoyX := 0
LastJoyY := 0
; 导入手柄按键监控模块
; #include JoyKeyMonitor.ahk

; 使用定时器代替无限循环，这样热键功能才能正常工作
SetTimer ControlMouseWithJoystick, 10  ; 每10毫秒执行一次

; 摇杆控制鼠标的函数
; 全局变量用于存储当前的移动速度
CurrentSpeed := Sensitivity

; 创建速度调节GUI的函数
CreateSpeedControlGUI() {
    static SpeedGUI := 0

    ; 如果GUI已经存在，则显示它
    if (SpeedGUI && SpeedGUI.Exist) {
        SpeedGUI.Show()
        return
    }

    ; 创建新的GUI
    SpeedGUI := Gui("+AlwaysOnTop", "鼠标移动速度调节")
    SpeedGUI.SetFont("s10")

    ; 添加滑块控件
    SpeedGUI.Add("Text", , "速度值: ")
    SpeedValueText := SpeedGUI.Add("Text", "xm w50", CurrentSpeed)

    ; 滑块范围从0.1到10，步长为0.1
    SpeedSlider := SpeedGUI.Add("Slider", "xm r1 w200 vSpeedSlider Range0.1-10 TickInterval0.1 AltSubmit gUpdateSpeed",
        CurrentSpeed)

    ; 添加说明文本
    SpeedGUI.Add("Text", "xm", "使用滑块调节摇杆控制鼠标的移动速度")
    SpeedGUI.Add("Text", "xm", "Ctrl+Alt+S 显示/隐藏此窗口")

    ; 添加按钮
    SpeedGUI.Add("Button", "xm w80 gResetSpeed", "重置默认值")
    SpeedGUI.Add("Button", "x+10 w80 gCloseSpeedGUI", "关闭")

    ; 显示GUI
    SpeedGUI.Show()

    ; 定义回调函数
    UpdateSpeed(*) {
        CurrentSpeed := SpeedSlider.Value
        SpeedValueText.Value := Round(CurrentSpeed, 1)
    }

    ResetSpeed(*) {
        CurrentSpeed := Sensitivity
        SpeedSlider.Value := CurrentSpeed
        SpeedValueText.Value := Round(CurrentSpeed, 1)
    }

    CloseSpeedGUI(*) {
        SpeedGUI.Hide()
    }
}

; 显示/隐藏速度调节窗口的热键
^!s:: CreateSpeedControlGUI()

; 摇杆控制鼠标的函数（支持参数调节速度）
ControlMouseWithJoystick() {
    ; 获取左摇杆X和Y轴的值
    JoyX := GetKeyState("JoyX")
    JoyY := GetKeyState("JoyY")

    ; 应用死区过滤和当前速度
    MoveX := Abs(JoyX - 50) > Deadzone ? (JoyX - 50) * CurrentSpeed : 0
    MoveY := Abs(JoyY - 50) > Deadzone ? (JoyY - 50) * CurrentSpeed : 0

    ; 只有当摇杆移动超出死区时才移动鼠标
    if (MoveX != 0 || MoveY != 0) {
        MouseMove MoveX, MoveY, 0, "R"  ; R表示相对移动
    }
}

; 十字键映射为方向键 - 使用POV值
SetTimer CheckPOVDirection, 50

CheckPOVDirection() {
    static LastPOV := -1
    POV := GetKeyState("JoyPOV", "P")

    ; 只有当POV值改变时才处理
    if (POV = LastPOV)
        return

    LastPOV := POV

    ; 释放所有方向键
    if GetKeyState("Up")
        Send "{Up up}"
    if GetKeyState("Down")
        Send "{Down up}"
    if GetKeyState("Left")
        Send "{Left up}"
    if GetKeyState("Right")
        Send "{Right up}"

    ; 根据POV值按下相应的方向键
    if (POV = 0)
        Send "{Up down}"      ; 上
    else if (POV = 9000)
        Send "{Right down}"   ; 右
    else if (POV = 18000)
        Send "{Down down}"    ; 下
    else if (POV = 27000)
        Send "{Left down}"    ; 左
    ; POV = -1 时为中心位置，不按任何键
}

; 添加了Z轴监控定时器
SetTimer ControlMouseWithJoyZ, 50      ; 每50毫秒检查一次Z轴状态，映射为鼠标左键

; 新增Z轴映射为鼠标左键的函数
ControlMouseWithJoyZ() {
    ; z50是未触发值，z100左扳机的触发值，z0是右扳机的触发值
    static IsLeftDown := false
    static IsRightDown := false

    ; 获取Z轴的值
    JoyZ := GetKeyState("JoyZ")

    ; 检查Z轴是否处于左扳机触发状态(100)且鼠标左键当前未按下
    if (JoyZ >= 90 && !IsLeftDown) {  ; 使用90作为阈值，避免精确值问题
        Send "{LButton down}"       ; 按下鼠标左键
        IsLeftDown := true
    }
    ; 检查Z轴是否处于右扳机触发状态(0)且鼠标右键当前未按下
    else if (JoyZ <= 10 && !IsRightDown) {  ; 使用10作为阈值，避免精确值问题
        Send "{RButton down}"       ; 按下鼠标右键
        IsRightDown := true
    }
    ; 检查Z轴是否回到未触发状态(50)且鼠标左键当前处于按下状态
    else if (JoyZ <= 60 && IsLeftDown) {  ; 使用60作为阈值，避免精确值问题
        Send "{LButton up}"         ; 释放鼠标左键
        IsLeftDown := false
    }
    ; 检查Z轴是否回到未触发状态(50)且鼠标右键当前处于按下状态
    else if (JoyZ >= 40 && IsRightDown) {  ; 使用40作为阈值，避免精确值问题
        Send "{RButton up}"         ; 释放鼠标右键
        IsRightDown := false
    }
}
