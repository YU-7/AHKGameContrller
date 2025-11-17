; 摇杆控制鼠标的工具函数库
; 本文件提供摇杆控制鼠标的功能函数，可作为库被其他脚本引用

; 确保函数在包含此文件时不会被立即执行
; 定义全局变量
#SingleInstance Force
Deadzone := 20    ; 摇杆死区，防止微小移动被误触发

; 左摇杆控制鼠标的函数（支持参数调节速度）
;   - speed: 可选参数，指定移动速度，默认为LeftCurrentSpeed
ControlMouseWithJoystick(speed := "") {
    ; 如果提供了速度参数，则使用提供的速度，否则使用全局LeftCurrentSpeed
    local moveSpeed := speed != "" ? speed : (IsSet(LeftCurrentSpeed) ? LeftCurrentSpeed : 0.5)

    ; 获取左摇杆X和Y轴的值并确保它们是数字
    JoyX := GetKeyState("JoyX")
    JoyY := GetKeyState("JoyY")

    ; 确保值是有效的数字，如果不是则默认为50（中间值）
    JoyX := IsNumber(JoyX) ? JoyX : 50
    JoyY := IsNumber(JoyY) ? JoyY : 50

    ; 应用死区过滤和当前速度
    MoveX := Abs(JoyX - 50) > Deadzone ? (JoyX - 50) * moveSpeed : 0
    MoveY := Abs(JoyY - 50) > Deadzone ? (JoyY - 50) * moveSpeed : 0

    ; 只有当摇杆移动超出死区时才移动鼠标
    if (MoveX != 0 || MoveY != 0) {
        MouseMove MoveX, MoveY, 0, "R"  ; R表示相对移动
    }
}

; 右摇杆控制鼠标的函数（使用较慢的速度）
;   - speed: 可选参数，指定移动速度，默认为RightCurrentSpeed

MouseMoveControl() {
    Sensitivity := 0.5  ; 鼠标灵敏度 (1-10)
    ; 全局变量用于存储当前的移动速度
    LeftCurrentSpeed := Sensitivity
    RightCurrentSpeed := 0.1
    ; 使用定时器代替无限循环，这样热键功能才能正常工作
    ControlMouseWithJoystick(LeftCurrentSpeed)
    ControlMouseWithRightJoystick(RightCurrentSpeed)
}
ControlMouseWithRightJoystick(speed := "") {
    ; 如果提供了速度参数，则使用提供的速度，否则使用全局RightCurrentSpeed
    local moveSpeed := speed != "" ? speed : (IsSet(RightCurrentSpeed) ? RightCurrentSpeed : 0.1)

    ; 获取右摇杆R和U轴的值并确保它们是数字（R对应X方向，U对应Y方向）
    JoyR := GetKeyState("JoyR")
    JoyU := GetKeyState("JoyU")

    ; 确保值是有效的数字，如果不是则默认为50（中间值）
    JoyR := IsNumber(JoyR) ? JoyR : 50
    JoyU := IsNumber(JoyU) ? JoyU : 50

    ; 应用死区过滤和当前速度
    MoveY := Abs(JoyR - 50) > Deadzone ? (JoyR - 50) * moveSpeed : 0
    MoveX := Abs(JoyU - 50) > Deadzone ? (JoyU - 50) * moveSpeed : 0

    ; 只有当摇杆移动超出死区时才移动鼠标
    if (MoveX != 0 || MoveY != 0) {
        MouseMove MoveX, MoveY, 0, "R"  ; R表示相对移动
    }
}

; 十字键的映射
CheckPOVDirection(CrossButton) {
    ; static LastPOV := -1
    POV := GetKeyState("JoyPOV", "P")

    ; 只有当POV值改变时才处理
    ; if (POV = LastPOV)
    ;     return

    ; LastPOV := POV

    ; 根据POV值按下相应的方向键
    if (POV = CrossButton["Up"])
        send "{Up}"  ; 上
    else if (POV = CrossButton["Right"])
        Send "{Right}"  ; 右
    else if (POV = CrossButton["Down"])
        send "{Down}"  ; 下
    else if (POV = CrossButton["Left"])
        Send "{Left}"  ; 左
    ; POV = -1 时为中心位置，不按任何键
}
; 新增Z轴映射为鼠标左键的函数，左右扳机的映射
ControlMouseWithJoyZ(TrigerButton) {
    ; z50是未触发值，z100左扳机的触发值，z0是右扳机的触发值
    static IsLeftDown := false
    static IsRightDown := false

    ; 获取Z轴的值并确保它是一个数字
    JoyZ := GetKeyState(TrigerButton['key'])

    ; 确保JoyZ是一个有效的数字，如果不是则默认为50（中间值）
    JoyZ := IsNumber(JoyZ) ? JoyZ : TrigerButton['Unpress']

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

; 全局的按钮映射
GlobalMappingButton(ControllerButtonMapping) {
    ; 左肩键
    Hotkey ControllerButtonMapping["LeftShoulderButton"], (*) => Send("{Space}")
    ; 右肩键
    Hotkey ControllerButtonMapping["RightShoulderButton"], (*) => Send("^{Tab}")
    ; B键
    Hotkey ControllerButtonMapping["ButtonB"], (*) => Send("{Escape}")
    ; X键
    Hotkey ControllerButtonMapping['ButtonX'], (*) => Send("!{F4}")
    ; Y键
    Hotkey ControllerButtonMapping["ButtonY"], (*) => Send("f")
    ; A键
    Hotkey ControllerButtonMapping["ButtonA"], (*) => Send("{space}")

    ; 非通用部分，飞智的键位
    ; Select键
    Hotkey ControllerButtonMapping["ButtonSelect"], (*) => Send("!{Tab down}")  ; 按下Alt+Tab，保持Alt键按住
    ; Start键
    Hotkey ControllerButtonMapping["ButtonStart"], (*) => Send("{F2}")
    ; leftback键
    Hotkey ControllerButtonMapping["leftbackButton"], (*) => Send("#d")  ; 按下Win+D，显示桌面
    ; rightback键
    Hotkey ControllerButtonMapping["rightbackButton"], (*) => Send("^!{Tab}") ; 按下Ctrl+Alt+Tab，保持任务栏视图
}
