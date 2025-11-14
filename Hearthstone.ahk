#Requires AutoHotkey v2.0
#SingleInstance Force
; 从Util.ahk导入函数
#Include %A_ScriptDir%\Util.ahk

HearthStroeMapping() {
    Sensitivity := 0.5  ; 鼠标灵敏度 (1-10)
    ; 全局变量用于存储当前的移动速度
    LeftCurrentSpeed := Sensitivity
    RightCurrentSpeed := 0.1

    ; 使用定时器代替无限循环，这样热键功能才能正常工作
    SetTimer (*) => ControlMouseWithJoystick(LeftCurrentSpeed), 10  ; 每10毫秒执行一次左摇杆控制
    SetTimer (*) => ControlMouseWithRightJoystick(RightCurrentSpeed), 10  ; 每10毫秒执行一次右摇杆控制
    SetTimer CheckPOVDirection, 50
    ; 添加了Z轴监控定时器
    SetTimer ControlMouseWithJoyZ, 50      ; 每50毫秒检查一次Z轴状态，映射为鼠标左键
}
