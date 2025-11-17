#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Util.ahk
#Include %A_ScriptDir%\Config.ahk

DefualtMapping() {
    ; 添加了Z轴监控定时器
    CheckPOVDirection
    ControlMouseWithJoyZ
    GlobalMappingButton(ControllerButtonMapping)          ; 每120毫秒检查一次按钮状态，太短会多次触发，太长会反应缓慢
}
