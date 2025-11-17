#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Util.ahk

QuarkMapping() {
    ; 左肩键
    Hotkey ControllerButtonMapping["LeftShoulderButton"], (*) => Send("+{Left}")
    ; 右肩键
    Hotkey ControllerButtonMapping["RightShoulderButton"], (*) => Send("+{Right}")
    ; B键
    Hotkey ControllerButtonMapping["ButtonB"], (*) => Send("{Escape}")
    ; X键
    Hotkey ControllerButtonMapping["ButtonX"], (*) => Send("!{F4}")
    ; Y键
    Hotkey ControllerButtonMapping["ButtonY"], (*) => Send("{f}")
    ; A键
    Hotkey ControllerButtonMapping["ButtonA"], (*) => Send("{space}")  ; 发送空格键，暂停/播放
}
