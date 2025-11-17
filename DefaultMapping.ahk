#Requires AutoHotkey v2.0
#SingleInstance Force
#Include %A_ScriptDir%\Util.ahk
#Include %A_ScriptDir%\Config.ahk

DefualtMapping() {
    CheckPOVDirection(CrossButton)
    ControlMouseWithJoyZ(TrigerButton)
}
