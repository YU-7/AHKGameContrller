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
CheckPOVDirection() {
    POVMapping := Map()
    POVMapping["POV_UP"] := "{Up down}"
    POVMapping["POV_DOWN"] := "{Down down}"
    POVMapping["POV_LEFT"] := "{Left down}"
    POVMapping["POV_RIGHT"] := "{Right down}"
    static LastPOV := -1
    POV := GetKeyState("JoyPOV", "P")

    ; 只有当POV值改变时才处理
    if (POV = LastPOV)
        return

    LastPOV := POV

    ; 释放所有方向键
    if GetKeyState("Up")
        Send POVMapping["POV_UP"]
    if GetKeyState("Down")
        Send POVMapping["POV_DOWN"]
    if GetKeyState("Left")
        Send POVMapping["POV_LEFT"]
    if GetKeyState("Right")
        Send POVMapping["POV_RIGHT"]

    ; 根据POV值按下相应的方向键
    if (POV = 0)
        Send POVMapping["POV_UP"]      ; 上
    else if (POV = 9000)
        Send POVMapping["POV_RIGHT"]   ; 右
    else if (POV = 18000)
        Send POVMapping["POV_DOWN"]    ; 下
    else if (POV = 27000)
        Send POVMapping["POV_LEFT"]    ; 左
    ; POV = -1 时为中心位置，不按任何键
}
; 新增Z轴映射为鼠标左键的函数，左右扳机的映射
ControlMouseWithJoyZ() {
    ; z50是未触发值，z100左扳机的触发值，z0是右扳机的触发值
    static IsLeftDown := false
    static IsRightDown := false

    ; 获取Z轴的值并确保它是一个数字
    JoyZ := GetKeyState("JoyZ")

    ; 确保JoyZ是一个有效的数字，如果不是则默认为50（中间值）
    JoyZ := IsNumber(JoyZ) ? JoyZ : 50

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
