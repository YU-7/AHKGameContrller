#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Util.ahk

DefualtMapping() {
    ; 添加了Z轴监控定时器
    SetTimer CheckPOVDirection, 120
    SetTimer ControlMouseWithJoyZ, 120      ; 每50毫秒检查一次Z轴状态，映射为鼠标左键
    SetTimer MappingButton, 120           ; 每120毫秒检查一次按钮状态，太短会多次触发，太长会反应缓慢
}
