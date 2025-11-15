#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Util.ahk

DefualtMapping() {
    Sensitivity := 0.5  ; 鼠标灵敏度 (1-10)
    ; 全局变量用于存储当前的移动速度
    LeftCurrentSpeed := Sensitivity
    RightCurrentSpeed := 0.1

    POVMapping := Map()
    POVMapping["POV_UP"] := "{Up down}"
    POVMapping["POV_DOWN"] := "{Down down}"
    POVMapping["POV_LEFT"] := "{Left down}"
    POVMapping["POV_RIGHT"] := "{Right down}"

    ; 使用定时器代替无限循环，这样热键功能才能正常工作
    SetTimer (*) => ControlMouseWithJoystick(LeftCurrentSpeed), 10  ; 每10毫秒执行一次左摇杆控制
    SetTimer (*) => ControlMouseWithRightJoystick(RightCurrentSpeed), 10  ; 每10毫秒执行一次右摇杆控制
    SetTimer CheckPOVDirection, 70
    ; 添加了Z轴监控定时器
    SetTimer ControlMouseWithJoyZ, 70      ; 每50毫秒检查一次Z轴状态，映射为鼠标左键
    SetTimer MappingButton, 120           ; 每120毫秒检查一次按钮状态，太短会多次触发，太长会反应缓慢
}
