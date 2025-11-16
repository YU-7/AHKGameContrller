#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Util.ahk

QuarkMapping() {
    ; 左肩键
    LeftShoulderButton := GetKeyState("Joy5")
    if (LeftShoulderButton)
        Send "+{Left}"  ; Shift+左方向键，上一集
    ; 右肩键
    RightShoulderButton := GetKeyState("Joy6")
    if (RightShoulderButton)
        Send "+{Right}"  ; Shift+右方向键，下一集
    ; B键
    ButtonB := GetKeyState("Joy2")
    if (ButtonB)
        Send "{Escape}"
    ; X键
    ButtonX := GetKeyState("Joy3")
    if (ButtonX)
        Send "!{F4}"
    ; Y键
    ButtonY := GetKeyState("Joy4")
    if (ButtonY)
        Send "f"  ; 发送小写的f字母键，全屏
    ; A键
    ButtonA := GetKeyState("Joy1")
    if (ButtonA)
        Send "{space}"  ; 发送空格键，暂停/播放

}
